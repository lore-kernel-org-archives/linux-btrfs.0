Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:12662 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3GaGKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 02:10:06 -0400
Message-ID: <51F8A9F3.8070304@cn.fujitsu.com>
Date: Wed, 31 Jul 2013 14:08:51 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <mangoo@wpkg.org>
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
References: <20130728135116.5ed992d4@wpkg.org> <8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com> <20130730192525.42725e74@wpkg.org> <3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com> <20130731104624.163d07d7@wpkg.org> <51F89058.6080101@cn.fujitsu.com> <20130731113644.0d98bb06@wpkg.org> <51F89D01.2020703@cn.fujitsu.com> <20130731123910.28016442@wpkg.org>
In-Reply-To: <20130731123910.28016442@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On 07/31/2013 01:39 PM, Tomasz Chmielewski wrote:
> On Wed, 31 Jul 2013 13:13:37 +0800
> Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:
> 
>>> # git pull origin master
>>
>> Oops, i am sorry, here should:
>>
>> git pull origin qgroup
>>
>> would you please try it again
> 
> Excellent, it works:
> 
> # btrfs qgroup show -p /mnt/lxc2
> 0/260 154273873920 154273873920 ---
> 0/261 181260288 181260288 ---
> 0/262 155557888 983040 ---
> 0/377 180539392 26005504 ---
> 0/378 308607238144 308607238144 ---
> 0/535 572407808 417832960 ---
> 0/536 68085026816 68085026816 ---
> 0/642 247824384 93282304 ---
> 0/1276 636026880 4096 1/1
> 0/1277 38301687808 4096 1/1
> 0/1278 617164800 32768 1/1
> 0/1279 38297591808 4096 1/1
> 0/1284 38299160576 0 1/1
> 0/1285 38299160576 21364736 1/1
> 0/1286 620396544 0 1/1
> 0/1287 633090048 12722176 1/1
> 0/1293 38301687808 4096 1/1
> 0/1294 636026880 4096 1/1
> 1/1 38972137472 38972137472 ---
> 
> 
> Thanks a lot!
> 
> 
> Am I correct to think that I have to run quota rescan after
> assigning groups?
> 
> # btrfs qgroup assign 378 1/1 /mnt/lxc2  <<----- assigning volid 378, having 300+ GB

Until now, Yes, we have to recan to correct qgroup accounting.

> 
> # btrfs qgroup show -p /mnt/lxc2 | grep 1/1
> 0/378 308607238144 308607238144 1/1
> 0/1276 636026880 4096 1/1
> 0/1277 38301687808 4096 1/1
> 0/1278 617164800 32768 1/1
> 0/1279 38297591808 4096 1/1
> 0/1284 38299160576 0 1/1
> 0/1285 38299160576 21364736 1/1
> 0/1286 620396544 0 1/1
> 0/1287 633090048 12722176 1/1
> 0/1293 38301687808 4096 1/1
> 0/1294 636026880 4096 1/1
> 1/1 38972137472 38972137472 ---  <<----- although we've added 300+ GB volume, the total numbers are unchanged
> 
> 
> That can be quite a bit of IO?
> 
> 

