Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:48783 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378AbcGJDkE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Jul 2016 23:40:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP id 7F80735F333
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Jul 2016 05:39:59 +0200 (CEST)
Received: from mailext.virtall.com ([127.0.0.1])
	by localhost (web1.virtall.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id owCu9COVEmso for <linux-btrfs@vger.kernel.org>;
	Sun, 10 Jul 2016 05:39:58 +0200 (CEST)
Received: from admin.virtall.com (localhost [127.0.0.1])
	by mailext.virtall.com (Postfix) with ESMTP
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Jul 2016 05:39:58 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 10 Jul 2016 12:39:58 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: filesystem read only after power outage
In-Reply-To: <f98c7bca36bd8d075fcde4aff0c1fbed@admin.virtall.com>
References: <7db11e52ffdd949a917036bc38f4b0f1@admin.virtall.com>
 <f98c7bca36bd8d075fcde4aff0c1fbed@admin.virtall.com>
Message-ID: <f7c66413aea9dfe6a5f608df105a8490@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-05 15:55, Tomasz Chmielewski wrote:
> On 2016-07-05 14:56, Tomasz Chmielewski wrote:
>> Getting this lengthy output logged, and the fs mounter read-only after
>> a power outage.
>> 
>> 
>> Tried also 4.6.3, but it ends just alike.
>> 
>> Jul  5 02:04:20 bkp011 kernel: [  799.298303] ------------[ cut here
>> ]------------
>> Jul  5 02:04:20 bkp011 kernel: [  799.298335] WARNING: CPU: 0 PID:
>> 1896 at /home/kernel/COD/linux/fs/btrfs/extent-tree.c:6599
>> __btrfs_free_extent.isra.70+0x877/0xd50 [btrfs]
> 
> 
> FYI, 4.7-rc6 breaks just like 4.6.0 and 4.6.3.

I've tried running btrfs check --repair -p, but after some 2 days it 
ended with:

reset nbytes for ino 2418526 root 12989
reset nbytes for ino 2634616 root 12989
reset nbytes for ino 2746243 root 12989
reset nbytes for ino 2824005 root 12989
ctree.c:195: update_ref_for_cow: Assertion `ret` failed.
btrfs(__btrfs_cow_block+0x399)[0x43a719]
btrfs(btrfs_cow_block+0x102)[0x43afac]
btrfs(btrfs_search_slot+0x1cc)[0x43da5d]
btrfs[0x423daa]
btrfs(cmd_check+0x29bf)[0x42c68c]
btrfs(main+0x155)[0x409f63]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf0)[0x7f96b3271830]
btrfs(_start+0x29)[0x409b59]
reset nbytes for ino 3217513 root 12989
Failed to find [90569834496, 168, 16384]



Tomasz Chmielewski
https://wpkg.org
