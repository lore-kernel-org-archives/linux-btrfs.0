Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58648 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbcHKIUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Aug 2016 04:20:48 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bXlEM-0001dU-4D
	for linux-btrfs@vger.kernel.org; Thu, 11 Aug 2016 10:20:46 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Date: Thu, 11 Aug 2016 08:20:38 +0000 (UTC)
Message-ID: <pan$89fac$51ff83ce$ca9a7014$9d3cfce9@cox.net>
References: <CAGdWbB5k_HmN2b4zzrnYN+ExiqeP_9Eu9mVBCHEtgZNKHfTARA@mail.gmail.com>
	<pan$d9b53$c31dc60$985cf806$b833643c@cox.net>
	<CAJCQCtTHH=q9cE-BHDYuDpUASQx4Rnzx_b3VR=v-3s_THf1f4w@mail.gmail.com>
	<CAGdWbB72DLAkV3EwO-7Sakc4gPHRT=GmU5ftxo0YfR0wjBefNQ@mail.gmail.com>
	<pan$631e4$8ace778e$d2bf1967$d5b4e8cc@cox.net>
	<CA+WRLO8MoW9kEy50u_QMvoB2Lejcjp49BjHqEjtWjZZOPtfetg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Thu, 11 Aug 2016 15:06:48 +1000 as excerpted:

> Is there some simple muddling of meta data that could be done to force
> dup meta data on deduping SSDs? Like a simple 'random' byte repeated
> often enough it would defeat any sane dedup? I know it would waste data
> but clearly that is considered worth it with dup metadata (what is the
> difference between 50% metadata efficiency and 45%?)

Well, the FTLs are mostly proprietary, AFAIK, so it's probably hard to 
prove the "force", but given the 512-byte sector standard (some are a 
multiple of that these days but 512 should be the minimum), in theory one 
random byte out of every 512 should do it... unless the compression these 
deduping FTLs generally run as well catches that difference and 
compresses it out to a different location where it can be compactly 
stored, allowing multiple copies of the same 512-byte sector to be stored 
in a single sector, so long as they only had a single byte or two 
different.

So it could probably be done, but given that the deduping and compression 
features of these ssds are listed as just that, features, and that people 
buy them for that, it may be that it's better to simply leave well enough 
alone.  Folks who want dup metadata can set it, and if they haven't 
bought one of these ssds with dedup as a feature, they can be reasonably 
sure it'll be set.  And people who don't care will simply get the 
defaults and can live with them the same way that people that don't care 
generally live with defaults that may or may not be the absolute best 
case for them, but are generally at least not horrible.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

