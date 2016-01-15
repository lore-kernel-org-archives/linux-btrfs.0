Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45583 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbcAOBr2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jan 2016 20:47:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aJtU7-0002tr-7u
	for linux-btrfs@vger.kernel.org; Fri, 15 Jan 2016 02:47:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 02:47:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Jan 2016 02:47:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Query about proposed dedup patches and behaviours
Date: Fri, 15 Jan 2016 01:47:21 +0000 (UTC)
Message-ID: <pan$b0586$d2b2b229$291cbb7b$f3802e23@cox.net>
References: <CAGkb5vfzcOmj1Js=pBR6=-Uad7jY2bJy5ht3F-m-1TEOBjwCYA@mail.gmail.com>
	<5697D0E9.3080007@gmail.com>
	<20160114192647.GB24567@localhost.localdomain>
	<5697F9E7.1020004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Thu, 14 Jan 2016 14:41:27 -0500 as
excerpted:

> On 2016-01-14 14:26, Liu Bo wrote:
>> On Thu, Jan 14, 2016 at 11:46:33AM -0500, Austin S. Hemmelgarn wrote:
>>> On 2016-01-14 11:13, James Hogarth wrote:

>>>> Finally what's the present situation with regards to defragmentation
>>>> and deduplication? Is it safe to turn on autodefrag now when using
>>>> snapshots and duperemove? What should the behaviour be with the
>>>> proposed 4.5 dedup patches if both inline dedup and autodefrag are
>>>> enabled as mount options?

>>> I'm not entirely certain how deduplication would interact with any
>>> form of defragmentation.  I'm pretty certain though that autodefrag
>>> does properly handle snapshots, such that the reflinks aren't broken,
>>> and it's the original copy that gets any shared extents defragmented
>>> into it.
>>
>> If it refers to snapshot-aware defrag, it's been disabled, so now btrfs
>> will not maintain reflinks between snapshots.
>>
> I was under the impression that autodefrag had been done separately from
> the snapshot-aware manually triggered defrag, and that it's always been
> snapshot aware.

Hugo should really explain as he was the one that said that, but upon 
looking into it, he found that while he was correct in a sense, his 
reasoning was a bit narrow, and autodefrag isn't snapshot aware in the 
wider context.

Without attempting to explain his reasoning as I think I sort of 
understand it but not well enough to try to explain, autodefrag isn't 
snapshot aware and will break reflinks, but due to $reasons, autodefrag's 
damage to reflinking apparently isn't as bad as manual defrag.

That's the best I can do to explain the situation.  In general, 
autodefrag remains bad for reflinks, but apparently not h***-bad, as 
manual defrag is.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

