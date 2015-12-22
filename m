Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35645 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbbLVEVV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Dec 2015 23:21:21 -0500
Received: by mail-io0-f178.google.com with SMTP id q126so175172286iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Dec 2015 20:21:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5678B25E.5030104@cn.fujitsu.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
	<CAJCQCtSEx_wYPkfazik0bcpQwXxJCA=O5f0o6RbxON4jjB4q7A@mail.gmail.com>
	<5677592F.5000202@cn.fujitsu.com>
	<CAJCQCtRyCxiAKDuyX-F_5Kmn8Xq+RruEo=H-S32FJPr_=b33TA@mail.gmail.com>
	<567762A3.9060007@cn.fujitsu.com>
	<20151222020529.1ac0c913@jupiter.sol.kaishome.de>
	<5678A5CC.7050900@cn.fujitsu.com>
	<20151222024804.5c4f7da2@jupiter.sol.kaishome.de>
	<5678B25E.5030104@cn.fujitsu.com>
Date: Mon, 21 Dec 2015 21:21:21 -0700
Message-ID: <CAJCQCtSGrTkHN9NQ2PPx7b1ba7oSNn9qh5eN5yB5YCgY+8OaXw@mail.gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Latest update.

4.4.0-0.rc6.git0.1.fc24.x86_64
btrfs-progs v4.3.1

Mounted the volume normally with both devices available, no mount
options, so it is a rw mount. And it mounts with only the normal
kernel messages:
[ 9458.290778] BTRFS info (device sdc): disk space caching is enabled
[ 9458.290788] BTRFS: has skinny extents

I left the volume alone for 20 minutes. After that time,
btrfs-show-super still shows different generation numbers for the two
devids.

I did an ls -l at the top level of the fs. And btrfs-show-super now
shows the same generation numbers and backup_roots information for
both devids.

Next, I read the most recently modified files, they all read OK, no
kernel messages, no missing files.

Last, I umounted the volume and did a btrfs check, and it comes up
completely clean, no errors.

No scrub done yet, no (user space) writes done yet. But going back to
the original btrfs check with all the errors, it really doesn't give a
user/admin of the volume any useful information what the problem is.
After-the-fact it's relatively clear that devid 1 has generation 4924,
and devid 2 has generation 4923, and that's what the btrfs check
complaints are about: just a generation mismatch and the associated
missing metadata on one device.

By all measures it's checking out and behaving completely healthy and
OK. So I'm going to play with some fire, and treat it normally for a
few days: including making snapshots and writing files. I'll do a
scrub in a few days and report back.



Chris Murphy
