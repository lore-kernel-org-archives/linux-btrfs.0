Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35676 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbbGINoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 09:44:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZDC7Q-0003Ek-Lf
	for linux-btrfs@vger.kernel.org; Thu, 09 Jul 2015 15:44:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 15:44:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2015 15:44:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs subvolume clone or fork (btrfs-progs feature request)
Date: Thu, 9 Jul 2015 13:43:53 +0000 (UTC)
Message-ID: <pan$808e5$18b28ebb$f039d1c6$8c98ba86@cox.net>
References: <CA+X5Wn4YoAByr=OMHHmS5X86iCJos4O=AbwFuy+iH=OrKmVhNg@mail.gmail.com>
	<CAG1y0scpWEF=590bM6dxkOZLAtCMwZaPCtHRuQjTT5DMu5ATrQ@mail.gmail.com>
	<559E6411.6090109@gmail.com> <20150709124121.GA25033@panda>
	<559E6D80.7010607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 09 Jul 2015 08:48:00 -0400 as
excerpted:

> On 2015-07-09 08:41, Sander wrote:
>> Austin S Hemmelgarn wrote (ao):
>>>> What's wrong with "btrfs subvolume snapshot"?
>>>
>>> Well, personally I would say the fact that once something is tagged as
>>> a snapshot, you can't change it to a regular subvolume without doing a
>>> non-incremental send/receive.
>>
>> A snapshot is a subvolume. There is no such thing as "tagged as a
>> snapshot".
>>
>> 	Sander
>>
> No, there is a bit in the subvolume metadata that says whether it's
> considered a snapshot or not.  Internally, they are handled identically,
> but it does come into play when you consider things like btrfs subvolume
> show -s (which only lists snapshots), which in turn means that certain
> tasks are more difficult to script robustly.

My use-case doesn't involve subvolumes or snapshots so I can't check for 
sure, but...

I could have sworn btrfs property -t subvolume can get/set that snapshot 
bit.  I know I saw the discussion and I think patch for it go by, but 
again, as I don't use them, I haven't tracked closely enough to see if it 
ever got in.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

