Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:47845 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839Ab3GaFjV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 01:39:21 -0400
Date: Wed, 31 Jul 2013 12:39:10 +0700
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
Message-ID: <20130731123910.28016442@wpkg.org>
In-Reply-To: <51F89D01.2020703@cn.fujitsu.com>
References: <20130728135116.5ed992d4@wpkg.org>
	<8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
	<20130730192525.42725e74@wpkg.org>
	<3C9EC4DB-0B63-49A8-B53C-24E162CB8FEF@gmail.com>
	<20130731104624.163d07d7@wpkg.org>
	<51F89058.6080101@cn.fujitsu.com>
	<20130731113644.0d98bb06@wpkg.org>
	<51F89D01.2020703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 13:13:37 +0800
Wang Shilong <wangsl.fnst@cn.fujitsu.com> wrote:

> > # git pull origin master
> 
> Oops, i am sorry, here should:
> 
> git pull origin qgroup
> 
> would you please try it again

Excellent, it works:

# btrfs qgroup show -p /mnt/lxc2
0/260 154273873920 154273873920 ---
0/261 181260288 181260288 ---
0/262 155557888 983040 ---
0/377 180539392 26005504 ---
0/378 308607238144 308607238144 ---
0/535 572407808 417832960 ---
0/536 68085026816 68085026816 ---
0/642 247824384 93282304 ---
0/1276 636026880 4096 1/1
0/1277 38301687808 4096 1/1
0/1278 617164800 32768 1/1
0/1279 38297591808 4096 1/1
0/1284 38299160576 0 1/1
0/1285 38299160576 21364736 1/1
0/1286 620396544 0 1/1
0/1287 633090048 12722176 1/1
0/1293 38301687808 4096 1/1
0/1294 636026880 4096 1/1
1/1 38972137472 38972137472 ---


Thanks a lot!


Am I correct to think that I have to run quota rescan after
assigning groups?

# btrfs qgroup assign 378 1/1 /mnt/lxc2  <<----- assigning volid 378, having 300+ GB

# btrfs qgroup show -p /mnt/lxc2 | grep 1/1
0/378 308607238144 308607238144 1/1
0/1276 636026880 4096 1/1
0/1277 38301687808 4096 1/1
0/1278 617164800 32768 1/1
0/1279 38297591808 4096 1/1
0/1284 38299160576 0 1/1
0/1285 38299160576 21364736 1/1
0/1286 620396544 0 1/1
0/1287 633090048 12722176 1/1
0/1293 38301687808 4096 1/1
0/1294 636026880 4096 1/1
1/1 38972137472 38972137472 ---  <<----- although we've added 300+ GB volume, the total numbers are unchanged


That can be quite a bit of IO?


-- 
Tomasz Chmielewski
http://wpkg.org
