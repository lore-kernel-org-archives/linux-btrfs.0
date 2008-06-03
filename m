From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: Future Linux filesystems
Date: Tue, 03 Jun 2008 10:46:15 -0600
Message-ID: <48457557.30000@gentoo.org>
References: <20824.143.166.255.41.1212443217.squirrel@tomslinux.homelinux.org>	<20080603065205.GA19533@infradead.org>	<9885.143.166.226.57.1212503847.squirrel@tomslinux.homelinux.org>	<48455D1E.8010006@gentoo.org> <yq1ve0qo64o.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Thomas King <kingttx@tomslinux.homelinux.org>,
	linux-btrfs@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <yq1ve0qo64o.fsf@sermon.lab.mkp.net>
List-ID: <linux-btrfs.vger.kernel.org>

Martin K. Petersen wrote:
> We're very concerned about data integrity.  With btrfs everything is
> checksummed at the logical level.  This allows you to detect data
> corruption, repair bad blocks using redundant, good copies, perform
> data scrubbing, etc.

That's the main reason I am interesting in btrfs, actually.  :)

> A related, but orthogonal data integrity measure is the T10 DIF
> infrastructure that I am working on.  DIF enables protection at the
> sector level and includes stuff like a data checksum and a locality
> check which ensures that the sector ends up the right place on disk.

Great!  Really great to hear that this issue is being actively worked.

> Right now the DIF checksum is added at the block layer level.  Work is
> in progress to move it up into the filesystems and from there into
> user space.  Eventually we'd like to be able to generate the checksum
> in the application and pass it along the I/O path all the way out to
> the physical disk.

Yep, end-to-end is a great idea.  Kudos to this and to btrfs!

					-Joe
