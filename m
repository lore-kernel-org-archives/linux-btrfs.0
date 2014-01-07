Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaAGVLe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 16:11:34 -0500
Date: Tue, 7 Jan 2014 22:11:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Btrfs: use flags instead of the bool variants in
 delayed node
Message-ID: <20140107211132.GD6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <1388034426-4935-1-git-send-email-miaox@cn.fujitsu.com>
 <1388034426-4935-5-git-send-email-miaox@cn.fujitsu.com>
 <20140102174955.GO6498@twin.jikos.cz>
 <52C68297.80707@cn.fujitsu.com>
 <20140103183610.GU6498@twin.jikos.cz>
 <52CB7B96.2020701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52CB7B96.2020701@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 07, 2014 at 11:59:18AM +0800, Miao Xie wrote:
> But I read a discuss about the use of boolean type, some developers suggested
> us to use bitfields instead of bool, because the bitfields can work better,
> and they are more flexible, less misuse than bool.
>   https://lkml.org/lkml/2013/9/1/154

I was searching for pros/cons of the bools but haven't found this one
nor anything useful, though not all of the advantages of bitfields apply
in our case.

I've compared the generated assembly with just this patch, and the
difference is effectively only the lock prefix for set/clear, the read
side has no significant penalty:

old:
  mov    0x128(%rbx),%esi

new:
  mov    0x120(%rbx),%rax
  test   $0x1,%al


old set:
  movb   $0x1,0x120(%rbx)

new:
  lock orb $0x1,0x120(%rbx)

The delayed_node structure is relatively short lived, is reused
frequently and I haven't seen any contention points where the lock
prefix would hurt.

So, ok to merge it.
