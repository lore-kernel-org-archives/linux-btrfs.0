Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33559 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750886AbdCPCCt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 22:02:49 -0400
Subject: Re: [PATCH 2/2] btrfs: replace hardcoded value with SEQ_NONE macro
To: <dsterba@suse.cz>, <ednadolski@gmail.com>, <linux-btrfs@vger.kernel.org>,
        Edmund Nadolski <enadolski@suse.com>
References: <20170313203204.11857-1-enadolski@suse.com>
 <20170313203204.11857-3-enadolski@suse.com>
 <20170315143801.GH14605@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <befed888-5df2-9fd3-f0fa-a95d8feffda4@cn.fujitsu.com>
Date: Thu, 16 Mar 2017 09:59:38 +0800
MIME-Version: 1.0
In-Reply-To: <20170315143801.GH14605@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/15/2017 10:38 PM, David Sterba wrote:
> On Mon, Mar 13, 2017 at 02:32:04PM -0600, ednadolski@gmail.com wrote:
>> From: Edmund Nadolski <enadolski@suse.com>
>>
>> Define the SEQ_NONE macro to replace (u64)-1 in places where said
>> value triggers a special-case ref search behavior.
>
>> index 9c41fba..20915a6 100644
>> --- a/fs/btrfs/backref.h
>> +++ b/fs/btrfs/backref.h
>> @@ -23,6 +23,8 @@
>>  #include "ulist.h"
>>  #include "extent_io.h"
>>
>> +#define SEQ_NONE	((u64)-1)

The naming of SEQ_NONE sounds not that good to me.

The (u64)-1 is to to info the backref walker to only search current 
root, and no need to worry about delayed_refs, since the caller (qgroup) 
will ensure that no delayed_ref will exist.

While the name SEQ_NONE seems a little like to 0, which is far from the 
original meaning.

What about SEQ_FINAL or SEQ_LAST?
Since the timing we use (u64)-1 is just before switching commit roots, 
it would be better for the naming to indicate that.

Thanks,
Qu



>
> Can you please move the definition to ctree.h, near line 660, where
> seq_list and SEQ_LIST_INIT are defined, so thay're all grouped together?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


