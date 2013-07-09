Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:33309 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3GIBRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jul 2013 21:17:34 -0400
Message-ID: <51DB64D5.90807@cn.fujitsu.com>
Date: Tue, 09 Jul 2013 09:18:13 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Cleanup for using BTRFS_SETGET_STACK instead of
 raw convert
References: <1372989690-4880-1-git-send-email-quwenruo@cn.fujitsu.com> <20130708132455.GA18204@twin.jikos.cz>
In-Reply-To: <20130708132455.GA18204@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

于 2013年07月08日 21:24, David Sterba 写道:
> On Fri, Jul 05, 2013 at 10:01:30AM +0800, Qu Wenruo wrote:
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -2807,6 +2846,14 @@ static inline unsigned long btrfs_leaf_data(struct extent_buffer *l)
>>   
>>   /* struct btrfs_file_extent_item */
>>   BTRFS_SETGET_FUNCS(file_extent_type, struct btrfs_file_extent_item, type, 8);
>> +BTRFS_SETGET_STACK_FUNCS(stack_file_extent_bytenr,
>> +			 struct btrfs_file_extent_item, disk_bytenr, 64);
> Please use the struct member name in the macro name, ie.
> stack_file_extent_disk_bytenr
Thanks for pointing out the problem.
I'll change the macro name and send a new patch.

>
> otherwise ok,
> Reviewed-by: David Sterba <dsterba@suse.cz>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

