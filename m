Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:9117 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756459AbeDXGma (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Apr 2018 02:42:30 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: remove comments about delayed ref in
 backref.c
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
References: <20180424055233.6420-1-suy.fnst@cn.fujitsu.com>
 <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <30643dd4-0f17-d89e-0216-9751d7133703@cn.fujitsu.com>
Date: Tue, 24 Apr 2018 14:48:17 +0800
MIME-Version: 1.0
In-Reply-To: <59c132d1-f6eb-708d-2c8f-96533ac9ce59@gmx.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/24/2018 02:02 PM, Qu Wenruo wrote:
> 
> 
> On 2018年04月24日 13:52, Su Yue wrote:
>> There is no delayed ref in btrfs-progs, so remove related comments.
>>
> 
> Indeed.
> Delayed ref is only used to speed up extent tree modification with the
> cost of code complexity.
> 
Thanks for your explanation :).

> For btrfs-progs we don't need to worry about it at all.
> 
So I suggest to remove comments in progs.

Thanks,
Su

> Thanks,
> Qu
> 
>> Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
>> ---
>>   backref.c | 19 +++----------------
>>   1 file changed, 3 insertions(+), 16 deletions(-)
>>
>> diff --git a/backref.c b/backref.c
>> index 27309e07a1e9..c144dbf060f2 100644
>> --- a/backref.c
>> +++ b/backref.c
>> @@ -155,19 +155,6 @@ static void init_pref_state(struct pref_state *prefstate)
>>    * - if you cannot add the parent or a correct key, then we will look into the
>>    *   block later to set a correct key
>>    *
>> - * delayed refs
>> - * ============
>> - *        backref type | shared | indirect | shared | indirect
>> - * information         |   tree |     tree |   data |     data
>> - * --------------------+--------+----------+--------+----------
>> - *      parent logical |    y   |     -    |    -   |     -
>> - *      key to resolve |    -   |     y    |    y   |     y
>> - *  tree block logical |    -   |     -    |    -   |     -
>> - *  root for resolving |    y   |     y    |    y   |     y
>> - *
>> - * - column 1:       we've the parent -> done
>> - * - column 2, 3, 4: we use the key to find the parent
>> - *
>>    * on disk refs (inline or keyed)
>>    * ==============================
>>    *        backref type | shared | indirect | shared | indirect
>> @@ -735,9 +722,9 @@ static int __add_keyed_refs(struct btrfs_fs_info *fs_info,
>>   }
>>   
>>   /*
>> - * this adds all existing backrefs (inline backrefs, backrefs and delayed
>> - * refs) for the given bytenr to the refs list, merges duplicates and resolves
>> - * indirect refs to their parent bytenr.
>> + * this adds all existing backrefs (inline backrefs, backrefs for the given
>> + * bytenr to the refs list, merges duplicates and resolves indirect refs to
>> + * their parent bytenr.
>>    * When roots are found, they're added to the roots list
>>    *
>>    * FIXME some caching might speed things up
>>
> 


