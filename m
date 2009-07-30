From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: BTRFS file clone support for cp
Date: Fri, 31 Jul 2009 00:28:49 +0100
Message-ID: <4A722CB1.80404@draigBrady.com>
References: <8763dcvagk.fsf@master.homenet> <20090729130106.GF13940@think>	<4A705959.7010303@draigBrady.com> <20090729161014.GJ13940@think>	<4A70918D.6020003@draigBrady.com>	<20090730005702.GA32157@mail.oracle.com>	<87fxcevcuy.fsf@meyering.net> <87ocr2frmx.fsf@basil.nowhere.org>	<87iqhatqzz.fsf@meyering.net>	<20090730105416.GB4534@basil.fritz.box> <20090730180515.GB7541@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Andi Kleen <andi@firstfloor.org>, Jim Meyering <jim@meyering.net>,
	linux-btrfs@vger.kernel.org, bug-coreutils@gnu.org,
	Giuseppe Scrivano <gscrivano@gnu.org>,
	Chris Mason <chris.mason@
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090730180515.GB7541@mail.oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Joel Becker wrote:
> 	In some sense, using btrfs, nilfs2i, ocfs2 with refcount trees
> enabled, or any other CoW-ish filesystem is a tacit approval of the
> delayed ENOSPC.  The same can be said of "thin provisioning" LUNs.
> However, the other concerns are still valid.  A user invoking vanilla
> cp(1) expects two independent storage regions for the data.
> 	(Oh, and what about future support of de-duping in filesystems?
> :-)

I maintain an app to de-dupe at http://www.pixelbeat.org/fslint/
and I'll be adding reflink support as soon as it becomes available.
=46rom a filesystem point of view, one thing that would help speed
this up (and many other things like rsync etc.) would be to allow
one to associate say a sha-3 hash or whatever with the file, which
the filesystem would automatically clear when the file data changes.
So in general having a special set of extended attributes that
were auto cleared on file modification would be very useful for
lots of stuff.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
