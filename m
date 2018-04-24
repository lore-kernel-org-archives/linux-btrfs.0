Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757954AbeDXN1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 09:27:10 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1C974AC65
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Apr 2018 13:27:09 +0000 (UTC)
Subject: Re: [PATCH 5/5] btrfs: Unexport btrfs_alloc_delalloc_work
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1524470057-21969-1-git-send-email-nborisov@suse.com>
 <1524470057-21969-6-git-send-email-nborisov@suse.com>
 <20180424132231.GF21272@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <44118bac-8b9c-11c1-2d7b-ad45f92fb91a@suse.com>
Date: Tue, 24 Apr 2018 16:27:08 +0300
MIME-Version: 1.0
In-Reply-To: <20180424132231.GF21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.04.2018 16:22, David Sterba wrote:
> On Mon, Apr 23, 2018 at 10:54:17AM +0300, Nikolay Borisov wrote:
>> It's used only in inode.c so makes no sense to have it exported.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>>  fs/btrfs/ctree.h | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
>> index 91f51a80334f..e5c24d86fdfa 100644
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -3170,8 +3170,6 @@ struct btrfs_delalloc_work {
>>  	struct btrfs_work work;
>>  };
>>  
>> -struct btrfs_delalloc_work *btrfs_alloc_delalloc_work(struct inode *inode);
> 
> So thic can be also made static, I can fix that.


I forgot, my bad.

> 
