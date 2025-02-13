# Start with BioSim base image.
ARG BASE_IMAGE=latest
FROM ghcr.io/jimboid/biosim-jupyter-base:$BASE_IMAGE

LABEL maintainer="James Gebbie-Rayet <james.gebbie@stfc.ac.uk>"
LABEL org.opencontainers.image.source=https://github.com/jimboid/biosim-beginners-workshop
LABEL org.opencontainers.image.description="A container environment for the ccpbiosim workshop on the basics of setup, simulation and analysis combined."
LABEL org.opencontainers.image.licenses=MIT

# Switch to jovyan user.
USER $NB_USER
WORKDIR $HOME

# Python Dependencies for the workshop
RUN conda install ipywidgets MDAnalysis>=2.0.0 MDAnalysisTests MDAnalysisData scikit-learn nglview jupyter_contrib_nbextensions rise pytest nbval

# Clone workshop contents
RUN git clone https://github.com/CCPBioSim/BioSim-analysis-workshop.git && \
    mv BioSim-analysis-workshop/* . && \
    rm -r BioSim-analysis-workshop

RUN jupyter contrib nbextension install --user && \
    jupyter nbextension enable splitcell/splitcell && \
    jupyter nbextension enable rubberband/main && \
    jupyter nbextension enable exercise2/main && \
    jupyter nbextension enable autosavetime/main && \
    jupyter nbextension enable collapsible_headings/main && \
    jupyter nbextension enable codefolding/main && \
    jupyter nbextension enable limit_output/main && \
    jupyter nbextension enable toc2/main

# Copy lab workspace
#COPY --chown=1000:100 default-37a8.jupyterlab-workspace /home/jovyan/.jupyter/lab/workspaces/default-37a8.jupyterlab-workspace

# UNCOMMENT THIS LINE FOR REMOTE DEPLOYMENT
COPY jupyter_notebook_config.py /etc/jupyter/

# Always finish with non-root user as a precaution.
USER $NB_USER
