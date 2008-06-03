From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Future Linux filesystems
Date: Tue, 03 Jun 2008 12:06:15 -0400
Message-ID: <yq1ve0qo64o.fsf@sermon.lab.mkp.net>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>
	<20080603065205.GA19533@infradead.org>
	<9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>
	<48455D1E.8010006@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Thomas King <kingttx@tomslinux.homelinux.org>,
	linux-btrfs@vger.kernel.org
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48455D1E.8010006@gentoo.org> (Joe Peterson's message of "Tue\, 03 Jun 2008 09\:02\:54 -0600")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Joe" == Joe Peterson <lavajoe@gentoo.org> writes:

Joe> You don't mention what I believe is the *key* issue (and I don't
Joe> think the author did either, but I skimmed his article): data
Joe> integrity.  I'm not talking about blatant failures or known need
Joe> for an fsck, but rather silent corruption.

We're very concerned about data integrity.  With btrfs everything is
checksummed at the logical level.  This allows you to detect data
corruption, repair bad blocks using redundant, good copies, perform
data scrubbing, etc.

A related, but orthogonal data integrity measure is the T10 DIF
infrastructure that I am working on.  DIF enables protection at the
sector level and includes stuff like a data checksum and a locality
check which ensures that the sector ends up the right place on disk.

If there is a mismatch the I/O will be reject by either the HBA or the
storage device.  That allows us to catch a lot of the corruption
scenarios where we accidentally write bad stuff to disk.

Right now the DIF checksum is added at the block layer level.  Work is
in progress to move it up into the filesystems and from there into
user space.  Eventually we'd like to be able to generate the checksum
in the application and pass it along the I/O path all the way out to
the physical disk.

-- 
Martin K. Petersen	Oracle Linux Engineering

