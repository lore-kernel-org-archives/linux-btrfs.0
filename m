Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59136 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbbIPEJP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 00:09:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zc41x-0003IA-8k
	for linux-btrfs@vger.kernel.org; Wed, 16 Sep 2015 06:09:13 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 06:09:13 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2015 06:09:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs kernel warning
Date: Wed, 16 Sep 2015 04:09:02 +0000 (UTC)
Message-ID: <pan$35c0$ee8bc3de$636c8076$39ddea5d@cox.net>
References: <CALq_kZHBx8hR_6kfwYgJChdK2RKw1+up07pGGYe+RRGOb2rhKA@mail.gmail.com>
	<55F8643F.5070701@gmail.com>
	<CALq_kZGHM2D7-XhrMbkhik2Hn=CWJGPBjbGrJWqS32k7nQEZ3g@mail.gmail.com>
	<55F86784.6060707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Tue, 15 Sep 2015 14:46:28 -0400 as
excerpted:

> On 2015-09-15 14:42, Tyler Williams wrote:
>> So I only had qgroups enabled because at some point it seemed like it
>> gave me the size of individual snapshots. Would it be likely that if I
>> just removed qgroups from that volume that would prevent that message
>> in the future?
>>
> Maybe, I'm not entirely certain if disabling qgroups on a volume removes
> the qgroup metadata, and if the metadata is still there, it might still
> cause issues.  It's worth trying though because it shouldn't make
> anything worse than it already is.

Confirming the two-step, disabling unlikely to do it without removal...

I'm not a quota/qgroup user either, but FWIW, after someone else reported 
problems (in that case, performance related) that I suspected were quota 
related, as they ultimately turned out to be, he did say that simply 
disabling quotas wasn't enough, he had to delete the quota tracking 
metadata to eliminate the issue.  Without personal btrfs quota feature 
experience I can't supply details as to what that involves, but he did 
specifically mention that simply disabling them didn't solve the problem, 
while removing them did.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

