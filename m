Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:61976 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab3LRFDl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 00:03:41 -0500
Message-ID: <52B12C85.6090503@cn.fujitsu.com>
Date: Wed, 18 Dec 2013 13:03:01 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Michael Welsh Duggan <mwd@md5i.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: receive: fix the case that we can not find
 subvolume
References: <1387271629-11315-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20131217150919.GP6498@twin.jikos.cz> <tntbo0fcwp2.fsf@watermonitor.yellow.cert.org> <52B10EBE.4030508@cn.fujitsu.com> <8761qmsup8.fsf@maru2.md5i.com> <52B11C67.2010900@cn.fujitsu.com> <871u1asszq.fsf@maru2.md5i.com>
In-Reply-To: <871u1asszq.fsf@maru2.md5i.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/18/2013 12:06 PM, Michael Welsh Duggan wrote:
> Wang Shilong <wangsl.fnst@cn.fujitsu.com> writes:
>
>> It seems that you use older kernel version but use the latest
>> btrfs-progs, new btrfs-progs use uuid tree to search but
>> this tree did not exist yet.
>>
>> Can you try to upgrade your kernel?
> What version is necessary?  (I am currently on 3.11.10.)
3.12 is ok, btw, can you run for 3.11.10

#dmesg

Let's see if it output somthing like:

btrfs: can not found root: 9

Thanks,
Wang
>

