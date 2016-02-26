Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44431 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbcBZPuZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 10:50:25 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <56D0743F.9040102@suse.cz>
Date: Fri, 26 Feb 2016 16:50:23 +0100
MIME-Version: 1.0
In-Reply-To: <56D04630.1020809@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn wrote:
 > Added linux-btrfs as this should be documented there as a known issue
 > until it gets fixed (although I have no idea which side is the issue).

This is a very bad behavior, as it makes impossible to safely use btrfs
loop bind mounts in fstab. (Well, it is possible to write a work-around
in util-linux: Remember the source file, and if -oloop is specified
next time, and source file is already assigned to a loop device, use
existing loop device.)

> I'm not 100% certain, but I think this is a interaction between how
> BTRFS handles multiple mounts of the same filesystem on a given system
> and how mount handles loop mounts.  AFAIUI, all instances of a given
> BTRFS filesystem being mounted on a given system are internally
> identical to bind mounts of a hidden mount of that filesystem.  This is
> what allows both manual mounting of sub-volumes, and multiple mounting
> of the FS in general.

Yes, internal implementation is the same.

But here it causes a  real trouble: However both mounts point to the
same file, first and second mount use different loop device. To create
a bind mount, something ugly needs to be done. And it is done in an
incorrect way.


I already found another inconsistency caused by this implementation:

/proc/self/mountinfo reports subvolid of the nearest upper sub-volume
root for the bind mount, not the sub-volume that was used for creating
this bind mount, and subvolid that potentially does not correspond to
any subvolume root.

This could causes problem for evaluation of order of umount(2) that
should prevent EBUSY.


I was talking about it with David Sterba, and he told, that in the
current implementation is not optimal. btrfs driver does not have
sufficient information to evaluate true root of the bind mount.

Maybe the same is valid for the reported loop issue, and this is just
an ugly side effect.


P. S.: There are some use differences between bind mounts and btrfs
sub-volumes:

- Bind mounts can be created for any file or directory.
- Sub-volume mounts can be created only for inodes marked as sub-volume
   root.

- Bind mounts can be mounted only if any of upper sub-volume root is
   mounted.
- Sub-volumes can be mounted even if volume root is not mounted.

-- 
Best Regards / S pozdravem,

Stanislav Brabec
software developer
---------------------------------------------------------------------
SUSE LINUX, s. r. o.                         e-mail: sbrabec@suse.com
Lihovarská 1060/12                            tel: +49 911 7405384547
190 00 Praha 9                                 fax:  +420 284 084 001
Czech Republic                                    http://www.suse.cz/
PGP: 830B 40D5 9E05 35D8 5E27 6FA3 717C 209F A04F CD76
