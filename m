Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50714 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaLaQ2j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Dec 2014 11:28:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y6M8I-0002PJ-MS
	for linux-btrfs@vger.kernel.org; Wed, 31 Dec 2014 17:28:26 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Dec 2014 17:28:26 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Dec 2014 17:28:26 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: should I use btrfs on Centos 7 for a new production server?
Date: Wed, 31 Dec 2014 16:28:17 +0000 (UTC)
Message-ID: <pan$b5028$e294cf67$70ec31a2$f06c9aab@cox.net>
References: <20141230192910.50345rkrnf3a8akm@webmail.uniserve.com>
	<B12D4A1D-8EB5-4C9B-A8DC-7280D333E2BC@gmail.com>
	<D5E9E585-E843-4D79-A881-EB5863FB4F8B@gmail.com>
	<54A391D8.6020201@redhat.com>
	<CAG1y0seVZipbGtonxt2iFfNYO_8kzvQZgzJeYd-zJxHUCod+sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Wed, 31 Dec 2014 13:16:14 +0700 as excerpted:

> On Wed, Dec 31, 2014 at 1:04 PM, Eric Sandeen <sandeen@redhat.com>
> wrote:
>> On 12/30/14 10:06 PM, Wang Shilong wrote:
>>>> I used CentOS7 btrfs myself, just doing some tests..it crashed
>>>> easily.
>>>> I don’t know how much efforts that Redhat do on btrfs for 7 series.
>>>
>>> Maybe use SUSE enterprise for btrfs will be a better choice, they
>>> offered better support for btrfs as far as i know.
>>
>> I believe SuSE's most recent support statement on btrfs is here, I
>> think.
>>
>> https://www.suse.com/releasenotes/x86_64/SUSE-SLES/12/#fate-317221
> 
> Wow. Suse use btrfs for root by default, but actively prevents user from
> using compression (unless specifically overiden using module parameter)?
> 
> Weird, since IIRC compression has been around and stable for a long
> time.

I noticed that.

I also noticed that they mention reiserfs as btrfs-convert-ready.  That I 
didn't know.  I thought btrfs-convert only supported ext*.

Tho I'd guess ext* has had more testing, and given the headaches I've 
seen people posting here having with it, I'd strongly recommend creating 
and testing a backup and restoring from it onto the new btrfs, as opposed 
to doing the direct convert.

Still, I wasn't aware it was even possible, and definitely not that it 
was good enough for SuSE to support. Cool that it is. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

