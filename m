Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40557 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2HQAml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 20:42:41 -0400
Received: by pbbrr13 with SMTP id rr13so2408031pbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2012 17:42:41 -0700 (PDT)
Message-ID: <502D9374.8030909@gmail.com>
Date: Fri, 17 Aug 2012 08:42:28 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] btrfs: fix trivial typo for the comment of BTRFS_FREE_INO_OBJECTID
References: <502D0986.8050202@gmail.com> <502D0F30.8030901@oracle.com>
In-Reply-To: <502D0F30.8030901@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年08月16日 23:18, Liu Bo wrote:
> On 08/16/2012 10:53 PM, Wang Sheng-Hui wrote:
>> It should be "storing".
>>
> 
> Please cc these typo fixes to trivial@kernel.org.
> 
> thanks,
> liubo

OK.

> 
>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>> ---
>>  fs/btrfs/ctree.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 4bab807..f9289db 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -116,7 +116,7 @@ struct btrfs_ordered_sum;
>>  #define BTRFS_FREE_SPACE_OBJECTID -11ULL
>>  
>>  /*
>> - * The inode number assigned to the special inode for sotring
>> + * The inode number assigned to the special inode for storing
>>   * free ino cache
>>   */
>>  #define BTRFS_FREE_INO_OBJECTID -12ULL
>>
> 

