Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48355 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2ISIcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 04:32:15 -0400
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 03B543EE0B6
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:14 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id D5A2645DE58
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:13 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id AE9A745DE54
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:13 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 9E1411DB8046
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:13 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 3AEE41DB8042
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Sep 2012 17:32:13 +0900 (JST)
Message-ID: <505982FF.407@jp.fujitsu.com>
Date: Wed, 19 Sep 2012 17:31:59 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
MIME-Version: 1.0
To: "Goffredo Baroncelli <kreijack@libero.it>" <kreijack@libero.it>
CC: linux-btrfs@vger.kernel.org
Subject: Re: R: [PATCH 2/2] Btrfs-progs: add mount-option command
In-Reply-To: <26356142.2062531347962627486.JavaMail.root@wmail62>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <26356142.2062531347962627486.JavaMail.root@wmail62>

(2012/09/18 19:03), Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi Seto,
> 
> please could you update also the man page too ? 

Sure. I'll update it next time.

> Why it was not provided a way to clear a *single* flag ? To me it seems a bit 
> too long to clear all the flag (btrfs mount-option clear) and then set the 
> right one.

Good point. We should have a way to clear defaults, by "clear" or
"set none" or so on. 

> 
> As user interface I suggest something like chmod:
> 
>    btrfs mount-option set +ssd,skip_balance -nodatacow /dev/sdX
> 
> or
> 
>    btrfs mount-option set =ssd,skip_balance,nodatacow /dev/sdX

Interesting. I guess you mean that "=<options>" will reset defaults
by specified options, while "+<options>" and "-<options>" will be
used to add/delete option to/from current defaults.

> 
> Finally I have some small concern about two macro (see below)
> 
>> ----Messaggio originale----
>> Da: seto.hidetoshi@jp.fujitsu.com
>> Data: 18/09/2012 3.30
>> A: <linux-btrfs@vger.kernel.org>
>> Ogg: [PATCH 2/2] Btrfs-progs: add mount-option command
>>
> [...]
>> +/*
>> + * Flags for mount options.
>> + *
>> + * Note: don't forget to add new options to btrfs_show_options()
>> + */
>> +#define BTRFS_MOUNT_NODATASUM		(1 << 0)
>> +#define BTRFS_MOUNT_NODATACOW		(1 << 1)
>> +#define BTRFS_MOUNT_NOBARRIER		(1 << 2)
>> +#define BTRFS_MOUNT_SSD			(1 << 3)
>> +#define BTRFS_MOUNT_DEGRADED		(1 << 4)
>> +#define BTRFS_MOUNT_COMPRESS		(1 << 5)
>> +#define BTRFS_MOUNT_NOTREELOG           (1 << 6)
>> +#define BTRFS_MOUNT_FLUSHONCOMMIT       (1 << 7)
>> +#define BTRFS_MOUNT_SSD_SPREAD		(1 << 8)
>> +#define BTRFS_MOUNT_NOSSD		(1 << 9)
>> +#define BTRFS_MOUNT_DISCARD		(1 << 10)
>> +#define BTRFS_MOUNT_FORCE_COMPRESS      (1 << 11)
>> +#define BTRFS_MOUNT_SPACE_CACHE		(1 << 12)
>> +#define BTRFS_MOUNT_CLEAR_CACHE		(1 << 13)
>> +#define BTRFS_MOUNT_USER_SUBVOL_RM_ALLOWED (1 << 14)
>> +#define BTRFS_MOUNT_ENOSPC_DEBUG	 (1 << 15)
>> +#define BTRFS_MOUNT_AUTO_DEFRAG		(1 << 16)
>> +#define BTRFS_MOUNT_INODE_MAP_CACHE	(1 << 17)
>> +#define BTRFS_MOUNT_RECOVERY		(1 << 18)
>> +#define BTRFS_MOUNT_SKIP_BALANCE	(1 << 19)
>> +#define BTRFS_MOUNT_CHECK_INTEGRITY	(1 << 20)
>> +#define BTRFS_MOUNT_CHECK_INTEGRITY_INCLUDING_EXTENT_DATA (1 << 21)
>> +#define BTRFS_MOUNT_PANIC_ON_FATAL_ERROR	(1 << 22)
>> +
>> +#define btrfs_clear_opt(o, opt)		((o) &= ~BTRFS_MOUNT_##opt)
>> +#define btrfs_set_opt(o, opt)		((o) |= BTRFS_MOUNT_##opt)
>> +#define btrfs_test_opt(root, opt)	((root)->fs_info->mount_opt& \
>> +					 BTRFS_MOUNT_##opt)
> 
> I think that the macro names are too generic, I suggest to rename the three 
> macros above as
> 
> #define btrfs_mount_XXXX_opt
> 
> Also, the last one should be 
> 
> #define btrfs_test_opt(o, opt)	( o & BTRFS_MOUNT_##opt)
> 
> Or better the other two
> 
> #define btrfs_mount_clear_opt(root, opt)		(((root)->fs_info->mount_opt) &= 
> ~BTRFS_MOUNT_##opt)
> #define btrfs_mount_set_opt(root, opt)		(((root)->fs_info->mount_opt) |= 
> BTRFS_MOUNT_##opt)

Right. I'll fix it.


Thanks,
H.Seto

