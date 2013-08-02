Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:40530 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3HBG12 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Aug 2013 02:27:28 -0400
Message-ID: <51FB5059.1080406@gmx.net>
Date: Fri, 02 Aug 2013 08:23:21 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: btrfs quota examples?
References: <20130610152127.38fb8a50@virtall.com> <51B58333.3050901@gmx.net> <20130729150510.19e5886a@virtall.com>
In-Reply-To: <20130729150510.19e5886a@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/29/13 10:05, Tomasz Chmielewski wrote:
> On Mon, 10 Jun 2013 09:41:39 +0200
> Arne Jansen <sensille@gmx.net> wrote:
> 
>>> Now, my questions:
>>>
>>> - what do both 104882176 104882176 numbers represent?
>>
>> The first number represents the amount of data in that subvolume,
>> regardless whether that data is shared with other subvolumes or
>> not.
>> The second number shows the amount of data that is unique to this
>> subvolume and not shared with others, i.e. the amount of space
>> that will get freed if you delete this subvolume.
> 
> I've played with qgroups for some time, but the results are rather
> inconsistent.
> 
> I.e. here - what does a negative number represent in 0/1181 row?

Either you have turned on qgroups after filling the subvol with
some data, or you've managed to produce a tracking error. In that
case, we would be interested how you did that and how to reproduce
it.

-Arne

> 
> # btrfs qgroup show /mnt/lxc2
> 0/260 151490953216 151490953216
> 0/261 180969472 180969472
> 0/262 155557888 983040
> 0/377 180310016 25776128
> 0/378 304088072192 304088072192
> 0/535 571944960 417370112
> 0/536 68550987776 68550987776
> 0/642 247463936 92921856
> 0/1175 617213952 827392
> 0/1181 16112013312 -22184235008
> 0/1268 38296248320 0
> 0/1269 616386560 0
> 0/1270 4096 4096
> 0/1271 4096 4096
> 
> 

