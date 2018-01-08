Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49586 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbeAHFb1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Jan 2018 00:31:27 -0500
Subject: Re: [PATCH 2/2] btrfs: add support for SUPER_FLAG_CHANGING_FSID in
 btrfs.ko
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: wqu@suse.com
References: <20180108030512.22344-1-anand.jain@oracle.com>
 <20180108030512.22344-2-anand.jain@oracle.com>
 <83756e06-446f-2807-8c9a-b918f609b741@gmx.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e67010f3-176d-935b-0274-58d8ddf05b31@oracle.com>
Date: Mon, 8 Jan 2018 13:10:34 +0800
MIME-Version: 1.0
In-Reply-To: <83756e06-446f-2807-8c9a-b918f609b741@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index a69e5944dc08..8b76faa77235 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -61,7 +61,8 @@
>>   				 BTRFS_HEADER_FLAG_RELOC |\
>>   				 BTRFS_SUPER_FLAG_ERROR |\
>>   				 BTRFS_SUPER_FLAG_SEEDING |\
>> -				 BTRFS_SUPER_FLAG_METADUMP)
>> +				 BTRFS_SUPER_FLAG_METADUMP |\
>> +				 BTRFS_SUPER_FLAG_CHANGING_FSID)
> 
> If we don't want the half changed fs to be mounted, it's better not to
> include FLAG_CHANGING_FSID into BTRFS_SUPER_FLAG_SUPP.

   Anyway BTRFS_SUPER_FLAG_SUPP as such does not stop to mount, it
  just warns. So when there is a new flag which is not supported
  we get this warning. As in the case with BTRFS_SUPER_FLAG_METADUMP_V2.
  As in 1/2 BTRFS_SUPER_FLAG_METADUMP_V2 in kernel is defined but not
  supported. However since we are supporting
  BTRFS_SUPER_FLAG_CHANGING_FSID, so adding to BTRFS_SUPER_FLAG_SUPP make
  sense to me. ?

Thanks, Anand
