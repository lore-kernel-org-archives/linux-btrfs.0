Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:56106 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaGBAea (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Jul 2014 20:34:30 -0400
Received: from fgwmail6.fujitsu.co.jp (fgwmail6.fujitsu.co.jp [192.51.44.36])
	by fgwmail8.fujitsu.co.jp (Postfix) with ESMTP id CFA4217930E7
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 09:26:19 +0900 (JST)
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id E4C053EE0C3
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 09:26:08 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.nic.fujitsu.com [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id DB73FAC08B4
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 09:26:07 +0900 (JST)
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 790B31DB803E
	for <linux-btrfs@vger.kernel.org>; Wed,  2 Jul 2014 09:26:07 +0900 (JST)
Message-ID: <53B35196.6040503@jp.fujitsu.com>
Date: Wed, 2 Jul 2014 09:25:58 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: atomically set inode->i_flags in btrfs_update_iflags
References: <1403732162-22405-1-git-send-email-fdmanana@gmail.com> <20140701235657.GV1553@twin.jikos.cz>
In-Reply-To: <20140701235657.GV1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/02 8:56), David Sterba wrote:
> On Wed, Jun 25, 2014 at 10:36:02PM +0100, Filipe David Borba Manana wrote:
>> This change is based on the corresponding recent change for ext4:
>>
>>    ext4: atomically set inode->i_flags in ext4_set_inode_flags()
>>
>> That has the following commit message that applies to btrfs as well:
>>
>>    "Use cmpxchg() to atomically set i_flags instead of clearing out the
>>     S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
>>     EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
>>     where an immutable file has the immutable flag cleared for a brief
>>     window of time."
>>
>> Replacing EXT4_IMMUTABLE_FL and EXT4_APPEND_FL with BTRFS_INODE_IMMUTABLE
>> and BTRFS_INODE_APPEND, respectively.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

