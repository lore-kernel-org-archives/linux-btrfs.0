Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbcCRIyb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 04:54:31 -0400
Subject: Re: [PATCH v2] btrfs-progs: subvolume functions reorg
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1458137673-464-1-git-send-email-anand.jain@oracle.com>
 <20160317141945.GU21722@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56EBC240.40306@oracle.com>
Date: Fri, 18 Mar 2016 16:54:24 +0800
MIME-Version: 1.0
In-Reply-To: <20160317141945.GU21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/17/2016 10:19 PM, David Sterba wrote:
> On Wed, Mar 16, 2016 at 10:14:33PM +0800, Anand Jain wrote:
>> Makes few subvol related functions usable outside of subvol
>> command set.
>>
>> This is a preparatory patch for encryption support. The changes
>> here are:
>>
>> Created new file subvolume.c
>> Created btrfs_get_subvol_info() from parts of cmd_subvol_show()
>> Moved get_subvol_name() to subvolume.c
>> Moved test_issubvolume() to subvolume.c
>> Created subvolume.h to define the above functions.
>
> Such helpers are in utils.[ch], eg. there's test_issubvolname.

  You meant to move them/it to subvolume.c/h right ?

> get_subvol_name could be renamed,

  will do.

> factoring btrfs_get_subvol_info looks good.
>
> So far the internal interfaces are not tidy,
> so everything goes to utils.

  yes. very true.

> It should be easier for you if you need to do some code
> rearrangements.

  Sure. Thanks for suggesting. Will see what I can find.

- Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
