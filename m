Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbcBZRHV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 12:07:21 -0500
Subject: Re: loop subsystem corrupted after mounting multiple btrfs
 sub-volumes
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
References: <56CF5490.7040102@suse.cz> <56D04630.1020809@gmail.com>
 <56D0743F.9040102@suse.cz> <56D07FAF.3080605@gmail.com>
From: Stanislav Brabec <sbrabec@suse.cz>
Message-ID: <56D08647.2010508@suse.cz>
Date: Fri, 26 Feb 2016 18:07:19 +0100
MIME-Version: 1.0
In-Reply-To: <56D07FAF.3080605@gmail.com>
Content-Type: text/plain; charset=iso-8859-2; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn wrote:
 > On 2016-02-26 10:50, Stanislav Brabec wrote:
> That's just it though, from what I can tell based on what I've seen and
> what you said above, mount(8) isn't doing things correctly in this case.
>   If we were to do this with something like XFS or ext4, the filesystem
> would probably end up completely messed up just because of the log
> replay code (assuming they actually mount the second time, I'm not sure
> what XFS would do in this case, but I believe that ext4 would allow the
> mount as long as the mmp feature is off).  It would make sense that this
> behavior wouldn't have been noticed before (and probably wouldn't have
> mattered even if it had been), because most filesystems don't allow
> multiple mounts even if they're all RO, and most people don't try to
> mount other filesystems multiple times as a result of this.  If this
> behavior of allocating a new loop device for each call on a given file
> is in fact not BTRFS specific (as implied by your statement about a
> possible workaround in mount(8)), then mount(8) really should be fixed
> to not do that before we even consider looking at the issues in BTRFS,
> as that is behavior that has serious potential to result in data
> corruption for any filesystem, not just BTRFS.

Well, kernel could "fix" it in a simple way:

- don't allow two loop devices pointing to the same file
or
- don't allow two loop devices pointing to the same file being used by
   mount(2).

Then util-linux would need a behavior change for sure.

>> I already found another inconsistency caused by this implementation:
>>
>> /proc/self/mountinfo reports subvolid of the nearest upper sub-volume
>> root for the bind mount, not the sub-volume that was used for creating
>> this bind mount, and subvolid that potentially does not correspond to
>> any subvolume root.
>>
>> This could causes problem for evaluation of order of umount(2) that
>> should prevent EBUSY.
>>
>> I was talking about it with David Sterba, and he told, that in the
>> current implementation is not optimal. btrfs driver does not have
>> sufficient information to evaluate true root of the bind mount.
> I've noticed this before myself, but I've never seen any issues
> resulting from it; however, I've also not tried calling BTRFS related
> ioctls on or from such a mount, so I may just have been lucky.

I can imagine two side effects deeply inside mount(8):

- "mount -a" uses subvol internally for a path lookup of the default
   volume or volume corresponding to subvolid. (Only the GIT version,
   not yet in 2.27.1.) I could imagine that the lookup is confused by a
   bind mount reporting the searched subvolid and a "random" subvol
   subvol.  But I don't have a reproducer yet, and I am not sure,
   whether it is really possible.

- "umount -a" could have a problem to find a proper order to umount(2)
   without EBUSY. I did not check the algorithm, so I am not sure,
   whether it is a real issue.


P. S.: There were many problems with btrfs in mount(8):

https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=c4af75a84ef3430003c77be2469869aaf3a63e2a
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=618a88140e26a134727a39c906c9cdf6d0c04513
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=d2f8267847ecbe763a3b63af1289bf1179cd8c45
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=2cd28fc82d0c947472a4700d5e764265916fba1e
https://git.kernel.org/cgit/utils/util-linux/util-linux.git/commit/?id=352740e88e2c9cb180fe845ce210b1c7b5ad88c7

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
