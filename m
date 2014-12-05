Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52763 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932981AbaLEA0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 19:26:06 -0500
Message-ID: <5480FB9D.7030708@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 08:26:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs:fsck: Recover btree with some corrupted
 leaf/node.
References: <1417661565-14595-1-git-send-email-quwenruo@cn.fujitsu.com> <1417661565-14595-3-git-send-email-quwenruo@cn.fujitsu.com> <20141204173546.GI9754@twin.jikos.cz> <5480FACB.7090601@cn.fujitsu.com>
In-Reply-To: <5480FACB.7090601@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 2/3] btrfs-progs:fsck: Recover btree with some 
corrupted leaf/node.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Date: 2014年12月05日 08:22
>
> -------- Original Message --------
> Subject: Re: [PATCH 2/3] btrfs-progs:fsck: Recover btree with some 
> corrupted leaf/node.
> From: David Sterba <dsterba@suse.cz>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2014年12月05日 01:35
>> On Thu, Dec 04, 2014 at 10:52:44AM +0800, Qu Wenruo wrote:
>>> +    trans = btrfs_start_transaction(root, -1);
>> What does '-1' mean here? I've never seen this before, just curious.
> I'am not completely sure, but when deleting item, num_blocks will be 
> minus or still 1?
>
> Thanks,
> Qu
Oh, no, I got it confused with btrfs_search_slot...
start_transcation should only accept positive value.

I'll update the patch with your other comment.

Sorry for the mistake.

Thanks for your reviewing.
Qu
