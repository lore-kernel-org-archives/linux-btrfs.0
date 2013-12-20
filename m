Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab3LTCdV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Dec 2013 21:33:21 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vtpts-00032t-89
	for linux-btrfs@vger.kernel.org; Fri, 20 Dec 2013 03:33:16 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 03:33:16 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Dec 2013 03:33:16 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
Date: Thu, 19 Dec 2013 21:33:04 -0500
Message-ID: <87d2ksp7z3.fsf@maru2.md5i.com>
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131217150919.GP6498@twin.jikos.cz>
	<tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
	<52B10EBE.4030508@cn.fujitsu.com> <8761qmsup8.fsf@maru2.md5i.com>
	<52B11C67.2010900@cn.fujitsu.com> <871u1asszq.fsf@maru2.md5i.com>
	<52B12C85.6090503@cn.fujitsu.com> <87txe5ri67.fsf@maru2.md5i.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Michael Welsh Duggan <mwd@md5i.com> writes:

> Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:
>
>> On 12/18/2013 12:06 PM, Michael Welsh Duggan wrote:
>>> Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:
>>>
>>>> It seems that you use older kernel version but use the latest
>>>> btrfs-progs, new btrfs-progs use uuid tree to search but
>>>> this tree did not exist yet.
>>>>
>>>> Can you try to upgrade your kernel?
>>> What version is necessary?  (I am currently on 3.11.10.)
>> 3.12 is ok, btw, can you run for 3.11.10
>>
> Looks like I'll be rebooting to a new kernel when I get home tonight.

Running with a 3.12 kernel does solve this problem for me.  Thank you
for your help.

-- 
Michael Welsh Duggan
(md5i@md5i.com)

