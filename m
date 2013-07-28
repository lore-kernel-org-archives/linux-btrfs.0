Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63402 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab3G1Hgs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jul 2013 03:36:48 -0400
Received: by mail-pa0-f45.google.com with SMTP id bg4so4747138pad.32
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 00:36:48 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs qgroup assign -> "ERROR: bad relation requested"
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130728135116.5ed992d4@wpkg.org>
Date: Sun, 28 Jul 2013 15:36:41 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <8C42FC74-384A-4D88-9D11-17AC7394A20B@gmail.com>
References: <20130728135116.5ed992d4@wpkg.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> I'm trying to use this feature of qgroup:
> 
> btrfs qgroup assign <srcid> <destid> <path>
>    Assigns the lower level qgroup src to the higher level qgroup dest
>    in the btrfs found in <path>. It is used to build qgroup
>    hierarchies.
> 
> 
> However, I fail to understand how this feature should work, and I'm
> getting "ERROR: bad relation requested":
> 
> # btrfs sub create test1
> Create subvolume './test1'
> 
> # btrfs sub create test2
> Create subvolume './test2'
> 
> # btrfs sub list /mnt/lxc2 | grep test
> ID 1177 gen 85131 top level 5 path test1
> ID 1178 gen 85132 top level 5 path test2
> 
> # btrfs qgroup show /mnt/lxc2
> 0/1177 4096 4096
> 0/1178 4096 4096
> 
> # btrfs qgroup assign 1177 1178 /mnt/lx2
> ERROR: bad relation requested '/mnt/lx2'
> 
> 
> Could anyone give examples of proper usage of this feature?
> 

Now qgroup require strict hierarchy. Every qgroup can be divided into
two parts:
		<level>/id

Btrfs group assign requires parent's level > children's level, For your example
below, you can do like:

btrfs qgroup create 1/1 <mnt>
btrfs qgroup assign  1177 1/1 <mnt>
btrfs qgroup assign  1178 1/1  <mnt>

And if you want to limit subvol(1177), you can do

btrfs qgroup limit  size 1177 <mnt>

Also, if you want to limit total size of 1177 and 1178, you
can set limit on qgroup 1/1.

Thanks,
Wang

> This is Linux 3.10.m
> 
> 
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

