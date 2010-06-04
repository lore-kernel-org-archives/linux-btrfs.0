From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: A couple of questions
Date: Thu, 03 Jun 2010 21:17:37 -0400
Message-ID: <yq1bpbry4su.fsf@sermon.lab.mkp.net>
References: <201005271539.55644.paul.millar@desy.de>
	<201005312006.47321.paul.millar@desy.de>
	<yq1ljaykh1z.fsf@sermon.lab.mkp.net>
	<201006021540.25725.paul.millar@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Paul Millar <paul.millar@desy.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006021540.25725.paul.millar@desy.de> (Paul Millar's message
	of "Wed, 2 Jun 2010 15:40:24 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

>>>>> "Paul" == Paul Millar <paul.millar@desy.de> writes:

Paul> Please correct me if I'm wrong here, but T10 DIF/DIX refers only
Paul> to data integrity protection from the OS's FS-level down to the
Paul> block device: a userland application doesn't know that it is
Paul> writing into a FS that is utilising DIX with a DIF-enabled storage
Paul> system.

My point was that it is possible to have different protection types in
play (and thus different checksums) as long as you overlap the
protection envelopes.  At the expense of having to calculate checksums
multiple times, of course.


Paul> Unfortunately, any such solution would be btrfs-specific, since (I
Paul> believe) no one has standardised how to extend T10 into userspace.

Not yet, but we're working on a generic interface that would allow the
protection information to be attached.  This is not going to be tied to
just T10 DIF.  The current Linux block layer integrity handles different
types of protection information.


Paul> I believe NFS currently doesn't support checksums (as per v4.1).
Paul> Looking into more detail, Alok Aggarwal gave a talk at 2006
Paul> connectathon about this.  Alok's slides have a nice diagram (slide
Paul> 11) showing the kind of end-to-end integrity I'm after.  The issue
Paul> is how to achieve the assurance between "NFS Server" and "Local
Paul> FS" on the right.

Paul> For NFS, I believe there aren't any plans for introducing checksum
Paul> support for v4.2.  Perhaps it'll appear with the later minor
Paul> versions of the standard.

I haven't looked into this for a long time.  Last time I talked to the
NFS folks they seemed to think it would be possible to bridge the two
methods.

-- 
Martin K. Petersen	Oracle Linux Engineering
