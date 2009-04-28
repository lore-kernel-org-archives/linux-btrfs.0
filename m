From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 17:59:00 +0200
Message-ID: <20090428155900.GA1722@cip.informatik.uni-erlangen.de>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240839448.26451.13.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I have a few more questions to this:

        - Is there a checksum for every block in btrfs?

        - Is it possible to retrieve these checksums from userland?

        - Is it possible to use a blocksize of 4 or 8 kbyte with btrfs?

To get a bit more specific: If it is relatively easy to identify and
deduplicate blocks, and if btrfs supports relatively small block sizes
like 4 / 8 kbyte, it is the perfect candidate for VMs. To give you some
data. I took 300 Gbyte (note this is the disk space that is used not the
provisioned space (the space that isn't currently used by the VM so it's the
data that are in use) of VMs running different operating systems and used a
perl script to identify how many data could be deduped give a specific
blocksize:

300 Gbyte of used storage of several productive VMs with the following
Operatings systems running:
\begin{itemize}
        \item Red Hat Linux 32 and 64 Bit (Release 3, 4 and 5)
        \item SuSE Linux 32 and 64 Bit (SLES 9 and 10)
        \item Windows 2003 Std. Edition 32 Bit
        \item Windows 2003 Enterprise Edition 64 Bit
\end{itemize}
\begin{tabular}{r|r|r|l}
blocksize & Deduplicated Data \\
\hline
128k      &  29.9 G \\
 64k      &  41.3 G \\
 32k      &  59.2 G \\
 16k      &  82   G \\
  8k      & 112   G \\
\

Bottom line with 8 K blocksize you can get more than 33% of deduped data
running a productive set of VMs.

        Thomas
