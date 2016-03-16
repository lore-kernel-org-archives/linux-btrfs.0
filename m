Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50005 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbcCPNmV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 09:42:21 -0400
Subject: Re: [PATCH] btrfs: rename save_error_info to set_fs_error
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
References: <1458117788-840-1-git-send-email-anand.jain@oracle.com>
 <20160316100535.GH21722@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56E962B3.2000700@oracle.com>
Date: Wed, 16 Mar 2016 21:42:11 +0800
MIME-Version: 1.0
In-Reply-To: <20160316100535.GH21722@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 03/16/2016 06:05 PM, David Sterba wrote:
> On Wed, Mar 16, 2016 at 04:43:05PM +0800, Anand Jain wrote:
>> @@ -171,7 +171,7 @@ void __btrfs_std_error(struct btrfs_fs_info *fs_info, const char *function,
>>   #endif
>>
>>   	/* Don't go through full error handling during mount */
>> -	save_error_info(fs_info);
>> +	set_fs_error(fs_info);
>
> The helper is too trivial, can you please drop it and replace by the
> it's code here

Dave,

In fact I was thinking that too, but comments below stop me doing that,
potentially this function might provision persistent FS state.

----
         /*
          * today we only save the error info into ram.  Long term we'll
          * also send it down to the disk
          */
-----

Thanks, Anand

>
>>   	if (sb->s_flags & MS_BORN)
>>   		btrfs_handle_error(fs_info);
>>   }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
