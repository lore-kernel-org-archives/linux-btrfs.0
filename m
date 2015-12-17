Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49079 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbbLQFNB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Dec 2015 00:13:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a9Qs6-0004FR-VJ
	for linux-btrfs@vger.kernel.org; Thu, 17 Dec 2015 06:12:58 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 06:12:58 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Dec 2015 06:12:58 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [auto-]defrag, nodatacow - general suggestions?(was: btrfs:
 poor performance on deleting many large files?)
Date: Thu, 17 Dec 2015 05:12:51 +0000 (UTC)
Message-ID: <pan$4b498$a87081b0$12c8e894$cf149ced@cox.net>
References: <CA+ve2MYBAPbLPiX4i2oZeDeu+9=JurXHsx5fMef2iV3rRrCKxg@mail.gmail.com>
	<56530DAD.9080607@gmail.com> <1448497439.28195.33.camel@scientia.net>
	<pan$3c463$5dc6ffa1$704b2ca2$141e65cc@cox.net>
	<5667C00B.4010100@scientia.net>
	<pan$7e682$345fe6d2$de13162d$f5ac4118@cox.net>
	<1450303141.6242.50.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 16 Dec 2015 22:59:01 +0100 as
excerpted:

>> he obviously didn't think thru the fact that compression MUST be a
>> rewrite, thereby breaking snapshot reflinks, even were normal
>> non-compression defrag to be snapshot aware, because compression
>> substantially changes the way the file is stored), that's _implied_,
>> not explicit.
> So you mean, even if ref-link aware defrag would return, it would still
> break them again when compressing/uncompressing/recompressing?
> I'd have hoped that then, all snapshots respectively other reflinks
> would simply also change to being compressed,

You're correct.  I "obviously didn't thing thru" that the whole way, 
myself. =:^(

But meanwhile, we don't have snapshot-aware-defrag, and in that case, the 
implication... and his result... remains.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

