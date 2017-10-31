Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58762 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751848AbdJaB7S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 21:59:18 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1e9LpV-0001hM-Oi
        for linux-btrfs@vger.kernel.org; Tue, 31 Oct 2017 02:59:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Problem with file system
Date: Tue, 31 Oct 2017 01:58:48 +0000 (UTC)
Message-ID: <pan$ee545$db8b9e33$aca1e421$80413db9@cox.net>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
        <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com>
        <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
        <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com>
        <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
        <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave posted on Sun, 29 Oct 2017 23:31:57 -0400 as excerpted:

> It's all part of the process of gaining critical experience with BTRFS.
> Whether or not BTRFS is ready for production use is (it seems to me)
> mostly a question of how knowledgeable and experienced are the people
> administering it.
> 
> In the various online discussions on this topic, all the focus is on
> whether or not BTRFS itself is production-ready. At the current maturity
> level of BTRFS, I think that's the wrong focus. The right focus is on
> how production-ready is the admin person or team (with respect to their
> BTRFS knowledge and experience). When a filesystem has been around for
> decades, most of the critical admin issues become fairly common
> knowledge, fairly widely known and easy to find. When a filesystem is
> newer, far fewer people understand the gotchas. Also, in older or widely
> used filesystems, when someone hits a gotcha, the response isn't "that
> filesystem is not ready for production". Instead the response is, "you
> should have known not to do that."

That's a view I hadn't seen before, but it seems reasonable and I like it.

Indeed, there were/are a few reasonably widely known caveats with both 
ext3 and reiserfs, for instance, and certainly some that apply to fat/
vfat/fat32, the three filesystems other than btrfs I know most about, and 
if anything they're past their prime, /not/ "still maturing", as btrfs is 
typically described.  For example, setting either of the two to writeback 
journaling and then losing data results in something akin to "you should 
have known not to do that unless you were prepared for the risk, as it's 
definitely a well known one."

Which of course was about my own reaction when Linus and the other powers 
that be decided to set ext3 to writeback journaling by default for a few 
kernel cycles.  Having lived thru that on reiserfs, I /knew/ where /that/ 
was headed, and sure enough...

Similarly, ext3's performance problems with fsync, because it effectively 
forces a full filesystem sync not just a file sync, are well known, as 
are the risks of storing a reiserfs in a loopback file on reiserfs and 
then trying to run a tree restore on the host, since it's known to mix up 
the two filesystems in that case.

It's thus a reasonable viewpoint to consider some of the btrfs quirks to 
be in the same category.  Of course btrfs being the first COW-based-fs 
most will have had experience with, and the first filesystem most will 
have experienced that handles raid, snapshotting, etc, it's definitely 
rather different and more complex than the filesystems most people are 
familiar with, and thus can only be expected to have rather different and 
more complex caveats than the filesystems most are familiar with, as well.

OTOH, there's definitely some known low-hanging-fruit in terms of ease of 
use, remaining to be implemented, tho I'd argue that we've reached the 
point where general stability is such that it has allowed the focus to 
gradually tilt toward implementing some of this, over the last year or 
so, and we're beginning to see the loose ends tied up in the 
documentation, for instance.  I'd say we are getting close, and your 
viewpoint is a definite argument in support of that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

