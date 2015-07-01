Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35797 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116AbbGACuI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 22:50:08 -0400
Received: by pdbci14 with SMTP id ci14so16766837pdb.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 19:50:07 -0700 (PDT)
Message-ID: <55935520.3000603@gmail.com>
Date: Wed, 01 Jul 2015 10:49:04 +0800
From: Wang Shilong <wangshilong1991@gmail.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix wrong check for btrfs_force_chunk_alloc()
References: <552A1228.4090700@gmail.com> <CAL3q7H56kXw3KZ3bOkm71O1wGxxuWBsuZmM73XmSPGMAhp8haQ@mail.gmail.com>
In-Reply-To: <CAL3q7H56kXw3KZ3bOkm71O1wGxxuWBsuZmM73XmSPGMAhp8haQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On Sun, Apr 12, 2015 at 7:35 AM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> btrfs_force_chunk_alloc() return 1 for allocation chunk successfully.
>> This problem exists since commit c87f08ca4.
>>
>> With this patch, we might fix some enospc problems for balances.
>>
>> Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> Tested-by: Filipe Manana <fdmanana@suse.com>

Thanks Filipe!

Regards,
Shilong

> 
>> ---
>>  fs/btrfs/relocation.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> index d830853..c453464 100644
>> --- a/fs/btrfs/relocation.c
>> +++ b/fs/btrfs/relocation.c
>> @@ -4037,7 +4037,7 @@ restart:
>>         if (trans && progress && err == -ENOSPC) {
>>                 ret = btrfs_force_chunk_alloc(trans, rc->extent_root,
>>                                               rc->block_group->flags);
>> -               if (ret == 0) {
>> +               if (ret == 1) {
>>                         err = 0;
>>                         progress = 0;
>>                         goto restart;
>> --
>> 1.7.12.4
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
