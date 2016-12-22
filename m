Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:59849 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764222AbcLVXi2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 18:38:28 -0500
MIME-Version: 1.0
Message-ID: <trinity-bd177067-2929-40d1-8548-fed25a956b10-1482449901027@3capp-mailcom-bs12>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "David Hanke" <hanke.list@ece.wisc.edu>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
Content-Type: text/plain; charset=UTF-8
Date: Fri, 23 Dec 2016 00:38:21 +0100
In-Reply-To: <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
References: <89be6fee-5b18-7a9d-11ea-85abeab28022@ece.wisc.edu>
 <pan$14679$e5d5bc21$812abe03$ef75194d@cox.net>,
 <4e2fcf15-5af4-54b0-f7bb-46518b9bb5a4@ece.wisc.edu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
If the change of disk format between versions is precisely documented,
it is plausible to create a utility to convert the old volume to new ones,
trigger the workflow, upgrade the kernel and boots up for mounting the new volume.
Currently, the btrfs wiki shows partial content of the on-disk format.
Thanks,
Xin
 
 

Sent: Wednesday, December 21, 2016 at 6:50 AM
From: "David Hanke" <hanke.list@ece.wisc.edu>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs_log2phys: cannot lookup extent mapping
Hi Duncan,

Thank you for your reply. If I've emailed the wrong list, please let me
know. What I hear you saying, in short, is that btrfs is not yet fully
stable but current 4.x versions may work better. I'm willing to upgrade,
but I'm told that the upgrade process may result in total failure, and
I'm not sure I can trust the contents of the volume either way. Given
that, it seems I must backup the backup, erase and start over. What
would you do?

Thank you,

David


On 12/20/16 17:24, Duncan wrote:
> David Hanke posted on Tue, 20 Dec 2016 09:52:25 -0600 as excerpted:
>
>> I've been using a btrfs-based volume for backups, but lately the
>> system's been filling the syslog with errors like "btrfs_log2phys:
>> cannot lookup extent mapping for 7129125486592" at the rate of hundreds
>> per second. (Please see output below for more details.) Despite the
>> errors, the files I've looked at appear to be written and read
>> successfully.
>>
>> I'm wondering if the contents of the volume are trustworthy and whether
>> this problem is resolvable without backing up, erasing and starting
>> over?
>>
>> Thank you!
>>
>> David
>>
>>
>> # uname -a
>> Linux backup2 3.0.101.RNx86_64.3 #1 SMP Wed Apr 1 16:02:14 PDT 2015
>> x86_64 GNU/Linux
>>
>> # btrfs --version
>> Btrfs v3.17.3
> FWIW...
>
> [TL;DR: see the four bottom line choices, at the bottom.]
>
> This is the upstream btrfs development and discussion list for a
> filesystem that's still stabilizing (that is, not fully stable and
> mature) and that remains under heavy development and bug fixing. As
> such, list focus is heavily forward looking, with an extremely strong
> recommendation to use current kernels (and to a lessor extent btrfs
> userspace) if you're going to be running btrfs, as these have all the
> latest bugfixes.
>
> Put a different way, the general view and strong recommendation of the
> list is that because btrfs is still under heavy development, with bug
> fixes, some more major than others, every kernel cycle, while we
> recognize that choosing to run old and stale^H^Hble kernels and userspace
> is a legitimate choice on its own, that choice of stability over support
> for the latest and greatest, is viewed as incompatible with choosing to
> run a still under heavy development filesystem. Choosing one OR the
> other is strongly recommended.
>
> For list purposes, we recommend and best support the last two kernel
> release series in two tracks, LTS/long-term-stable, or current release
> track. On the LTS track, that's the LTS 4.4 and 4.1 series. On the
> current track, 4.9 is the latest release, so 4.9 and 4.8 are best
> supported.
>
> Meanwhile, it's worth keeping in mind that the experimental label and
> accompanying extremely strong "eat your babies" level warnings weren't
> peeled off until IIRC 3.12 or so, meaning anything before that is not
> only ancient history in list terms, but also still labeled as "eat your
> babies" level experimental. Why anyone choosing to run an ancient eat-
> your-babies level experimental version of a filesystem that's now rather
> more stable and mature, tho not yet fully stabilized, is beyond me. If
> they're interested in newer filesystems, running newer and less buggy
> versions is reasonable; if they're interested in years-stale level of
> stability, then running such filesystems, especially when still labeled
> eat-your-babies level experimental back then, seems an extremely odd
> choice indeed.
>
> Of course, on-list we do recognize that various distros did and do offer
> support at some level for older than list-recommended version btrfs, in
> part because they backport fixes from newer versions. However, because
> we're forward development focused we don't track what patches these
> distros may or may not have backported and thus aren't in a good position
> to provide good support for them. Instead, users choosing to use such
> kernels are generally asked to choose between upgrading to something
> reasonably supportable on-list if they wish to go that route, or referred
> back to their distros for the support they're in a far better position to
> offer, since they know what they've backported and what they haven't,
> while we don't.
>
> As for btrfs userspace, the way btrfs works, during normal runtime,
> userspace primarily calls the kernel to do the real work, so userspace
> version isn't as big a deal unless you're trying to use a feature only
> supported by newer versions, except that if it's /too/ old, the impedance
> mismatch between the commands as they were then and the commands in
> current versions makes support rather more difficult. However, once
> there's a problem, then the age of userspace code becomes more vital, as
> then it's actually the userspace code doing the work, and only newer
> versions of btrfs check and btrfs restore, for instance, can detect and
> fix problems where code has only recently been added to do so.
>
> In general, then, with btrfs-progs releases and versioning synced to that
> of the kernel, a reasonable rule of thumb is to run userspace of a
> similar version to your kernel, tho unless you're experiencing problems,
> getting a version or two behind on your userspace isn't a big deal. That
> way, userspace command formats and output will be close enough to current
> for easier support, and if there's a fix for a specific problem you've
> posted in newer userspace, the problem and fix are still fresh enough in
> people's minds that someone will probably recognize it and point out that
> a newer version can handle that, and you can worry about upgrading to the
> latest and greatest at that point.
>
> So bottom line, you have four choices:
>
> 1) Upgrade to something reasonably current to get better on-list support.
>
> This would be LTS kernels 4.4 preferred, or 4.1, acceptable, or current
> kernels 4.9 or 4.8, and similarly versioned userspace, so no older than
> btrfs-progs 4.0.
>
> 2) Choose to stay with your distro's versions and get support from them.
>
> Particularly if you are already paying for that support, might as well
> use it.
>
> 3) Recognize the fundamental incompatibility between wanting to run old
> and stale/stable for the stability it is supposed to offer, and wanting
> to run a still under heavy development not fully stable and mature
> filesystem like btrfs, and either switch to a more stable and mature
> filesystem that better meets your needs for those qualities, or upgrade
> to a distro or distro version that better meets your needs for current
> software better supported by current upstreams like this btrfs list.
>
> 4) Stay with what you have, and muddle through as best you can.
>
> After all, it's not like we /refuse/ to offer support to btrfs that old,
> if we recognize a problem that we know can be fixed by code that old
> we'll still tell you, and if we know there's a fix in newer versions
> we'll still tell you and try to point you at the appropriate patch for
> you to apply to your old version if possible, but we simply recognize
> that for something that old, our support will be rather limited, at best.
>
> But it remains your system and your data, so your choice, even if it's
> against everything we normally recommend.
>
>
> Finally, a personal disclosure. I'm a btrfs user and list regular, not a
> dev. As such, my own answers will rarely get code-level technical or
> point to specific patches, but because I /am/ a regular, I can still
> answer the stuff that comes up regularly, leaving the real devs and more
> expert replies to cover detailed content that's beyond me. So while it's
> quite possible someone else will recognize a specific bug and be able to
> point you toward a specific fix, tho honestly I don't expect it for
> something as old as what you're posting about, general list-recommended
> upgrades and alternatives for people posting with positively ancient
> versions is squarely within my reply territory. =:^)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
