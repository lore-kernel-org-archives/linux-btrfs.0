Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42310 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3LRU5w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 15:57:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VtOBf-0003W4-45
	for linux-btrfs@vger.kernel.org; Wed, 18 Dec 2013 21:57:47 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 21:57:47 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 21:57:47 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find subvolume
Date: Wed, 18 Dec 2013 15:57:36 -0500
Message-ID: <87txe5ri67.fsf@maru2.md5i.com>
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131217150919.GP6498@twin.jikos.cz>
	<tntbo0fcwp2.fsf@watermonitor.yellow.cert.org>
	<52B10EBE.4030508@cn.fujitsu.com> <8761qmsup8.fsf@maru2.md5i.com>
	<52B11C67.2010900@cn.fujitsu.com> <871u1asszq.fsf@maru2.md5i.com>
	<52B12C85.6090503@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:

> On 12/18/2013 12:06 PM, Michael Welsh Duggan wrote:
>> Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:
>>
>>> It seems that you use older kernel version but use the latest
>>> btrfs-progs, new btrfs-progs use uuid tree to search but
>>> this tree did not exist yet.
>>>
>>> Can you try to upgrade your kernel?
>> What version is necessary?  (I am currently on 3.11.10.)
> 3.12 is ok, btw, can you run for 3.11.10
>
> #dmesg
>
> Let's see if it output somthing like:
>
> btrfs: can not found root: 9

Indeed.

    $ dmesg | grep "root 9"
    [305770.945287] could not find root 9
    [305770.945300] could not find root 9
    [305770.945369] could not find root 9
    [305770.945398] could not find root 9
    [305915.405421] could not find root 9
    [305915.405483] could not find root 9
    [305962.927150] could not find root 9
    [305962.927222] could not find root 9
    [399096.924559] could not find root 9
    [399096.924617] could not find root 9
    [399195.585768] could not find root 9
    [399195.585823] could not find root 9

Looks like I'll be rebooting to a new kernel when I get home tonight.

-- 
Michael Welsh Duggan
(md5i@md5i.com)

