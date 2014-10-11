Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbaJKLe2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Oct 2014 07:34:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XcuwM-0008EH-3O
	for linux-btrfs@vger.kernel.org; Sat, 11 Oct 2014 13:34:26 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Oct 2014 13:34:26 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Oct 2014 13:34:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS root filesystem and large discrepancy between du (73Gb
 used) and df (125 Gb used)?
Date: Sat, 11 Oct 2014 11:34:14 +0000 (UTC)
Message-ID: <pan$a0cab$22b4ec04$54b04b41$fb188d3c@cox.net>
References: <CAMnnoUJawjQM48AiE_WhvJt9QMy=b+MacOJ4wUcrRvDmH3jOZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Victor Hooi posted on Sat, 11 Oct 2014 22:07:12 +1100 as excerpted:

> I have a Ubuntu 14.04 Server host using BTRFS that seems to show large
> discrepancies between the output of du (73 GB used) and df (125 GB
> used).

A sampling from the FAQ:

https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_Btrfs_claims_I.27m_out_of_space.2C_but_it_looks_like_I_should_have_lots_left.21

https://btrfs.wiki.kernel.org/index.php/FAQ#Aaargh.21_My_filesystem_is_full.2C_and_I.27ve_put_almost_nothing_into_it.21

https://btrfs.wiki.kernel.org/index.php/FAQ#Why_is_free_space_so_complicated.3F

https://btrfs.wiki.kernel.org/index.php/FAQ#Why_is_there_so_much_space_overhead.3F

Basically, use btrfs filesystem show and btrfs filesystem df on btrfs.
You may also wish to use the compress mount-option, and if you're
using btrfs snapshotting, consider regularly thinning out the
old snapshots.

Additionally, be aware that snapshot-aware defrag is disabled
ATM as it wasn't scaling well, so if you're
using snapshots, anything you defrag will take up more room
as only the snapshot you point defrag at is defragged, while
the other snapshots are still pointing to the old version and
won't free that space until the snapshots are removed.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

