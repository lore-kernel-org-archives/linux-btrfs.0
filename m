Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58364 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750718AbdFFFlr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 01:41:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dI7FL-0000C1-Sz
        for linux-btrfs@vger.kernel.org; Tue, 06 Jun 2017 07:41:39 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: send operates on ro snapshots only
Date: Tue, 6 Jun 2017 05:41:33 +0000 (UTC)
Message-ID: <pan$442fa$c52a63d2$b43f5df4$7921ee00@cox.net>
References: <20170605233218.12421-1-hans.van.kranenburg@mendix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans van Kranenburg posted on Tue, 06 Jun 2017 01:32:18 +0200 as
excerpted:

> While talking to another btrfs user on IRC today, it became clear that a
> major point of confusion in the btrfs send manual is that it's not
> telling the user soon enough that send/receive solely operates on
> subvolume snapshots instead of the original (read/write) subvolumes.
> 
> So, change the first few alineas to explicitely mention snapshots

... lines to explicitly ...

> instead. Technically, snapshots are also just subvolumes, but requiring
> this level of technical detailed knowledge doesn't help the user which
> is just trying out things.

[actual patch omitted]

LGTM (other than the commit description spelling as above, neither my 
read-thru nor the spellchecker flagged anything in the actual patch).

The new wording is indeed much clearer.  Thanks. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

