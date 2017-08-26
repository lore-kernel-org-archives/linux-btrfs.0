Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:34075 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdHZVlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Aug 2017 17:41:46 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dlipb-000632-R3
        for linux-btrfs@vger.kernel.org; Sat, 26 Aug 2017 23:41:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: cause of dmesg call traces?
Date: Sat, 26 Aug 2017 21:41:21 +0000 (UTC)
Message-ID: <pan$b1d1f$b7a32c53$b09186ba$df8c5d45@cox.net>
References: <CACzgC9h7xiVQswvLgbSi=7bNyrO=hKV5dxO7yXz4Zy3C5Sdx0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Bahe posted on Sat, 26 Aug 2017 15:30:54 -0500 as excerpted:

> Hello all. Recently I added another 10TB sas drive to my btrfs array and
> I have received the following messages in dmesg during the balance. I
> was hoping someone could clarify what seems to be causing this.
> 
> Some additional info, I did a smartctl long test and one of my brand new
> 8TB drives warned me with this:
> 
>     197 Current_Pending_Sector 0x0022 100 100 000 Old_age Always - 136 #
>     5  Extended offline    Completed: servo/seek failure 90%
> 474         0
> 
> Are the messages in dmesg caused by the issues with the hard drive, or
> something else entirely?

I am not a developer, just a btrfs user and list regular, with my reply 
being based on what I've seen on-list.  For a more authoritative answer 
you can wait for other replies, but this one can cover a few basics.

Answering the above question, FWIW, the dmesg below seems to be something 
else...

> A few months ago I had a total failure
> requiring a complete nuke and pave so I am trying to track down any
> potential issues aggressively and appreciate any help. Thanks!
> 
> Also, how many current_pending_sectors do you tolerate before you swap a
> drive? I am going to pull this drive as soon as this current balance
> finishes. But for future reference it would be good to keep an eye on.
> 
> 
> 
> [Sat Aug 26 03:01:53 2017] WARNING: CPU: 30 PID: 5516 at
> fs/btrfs/extent-tree.c:3197 btrfs_cross_ref_exist+0xd1/0xf0 [btrfs]

Note warning, not error...  It's unexpected but not fatal, and the 
balance should continue without making whatever triggered the warning 
worse.

If I'm not mistaken (and if I am it doesn't change the conclusion), the 
triggering of this warning is a known issue related to a rather narrow 
kernel version window.  A newer current series kernel, or potentially 
older LTS series kernel, could well fix the problem.   See below.

> [Sat Aug 26 03:01:53 2017] CPU: 30 PID: 5516 Comm: kworker/u97:5
> Tainted: G        W       4.10.6-1.el7.elrepo.x86_64 #1

Kernel 4.10.x.  That's outside this list's recommended and best supported 
range, tho not massively so.  Given that this list is development focused 
and btrfs, while stabilizing, isn't yet considered fully stable and 
mature, emphasis tends to be forward-focused toward relatively new 
kernels.

The list recommendation is therefore one of the two latest kernel release 
series in either current-mainline-stable or mainline-LTS support tracks.

For current track, 4.12 is the latest release (with 4.13 getting close), 
so 4.12 and 4.11 are best supported, and with 4.13 nearing release 4.11 
is actually already EOLed with no further mainline updates.

For LTS track, 4.9 is the latest LTS series, with 4.4 the previous one, 
and 4.1 the one before that, tho btrfs development is moving fast enough 
that it's no longer recommended and even with 4.4, requests to duplicate 
reported issues with 4.9 may be expected.

So 4.10 has dropped off the recommended list as a non-LTS series kernel 
that's too old, and the recommendation would be to either upgrade to the 
latest 4.12-stable release (4.12.9 according to kernel.org as I post), or 
downgrade to the latest 4.9-LTS release (4.9.45 ATM).

And if I'm not mixing up issues and that's the one I think it is, the 
latest 4.12 should have that fix (tho 4.12.0 may not, IIRC the fix made 
4.13 and was backported to 4.12.x), and 4.9, IIRC, wasn't subject to the 
issue.

If you continue to see that warning with 4.13-rc6+, 4.12.9+ or 4.9.45+, 
then I'm obviously mixed up, and the devs may well be quite interested as 
it may be a new issue.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

