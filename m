Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49325 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbaFDGUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 Jun 2014 02:20:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ws4Yq-0003eS-Bs
	for linux-btrfs@vger.kernel.org; Wed, 04 Jun 2014 08:20:32 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 08:20:32 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 08:20:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH] btrfs-progs: Documentation: Add filter section for
 btrfs-balance.
Date: Wed, 4 Jun 2014 06:20:17 +0000 (UTC)
Message-ID: <pan$7402f$cb6972d1$db2b852d$277f3bef@cox.net>
References: <1401776408-32699-1-git-send-email-quwenruo@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo posted on Tue, 03 Jun 2014 14:20:08 +0800 as excerpted:

> Man page for 'btrfs-balance' mentioned <filters> but does not explain
> them, which make end users hard to use '-d', '-m' or '-s options.
> 
> This patch will use the explanations from
> https://btrfs.wiki.kernel.org/index.php/Balance_Filters to enrich the
> man page.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Thanks.  The wiki-only nature of the balance-filters documentation has 
been a bit of a complication.  This should fix that. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

