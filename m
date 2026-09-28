Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090904C33D6
	for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790632749; cv=none; b=qs5ksywjTRG9ZhoELsggT8zZtTsYNMBgOTrSadPXEMhBwLz8j7ao88BM5r1cRqoIDupVJLH5jlF+XKnUicUxMcYwqpXN5xANH6vFT581fqF3HX1/LLsxANWUrgsfVLLDxCInWFh1tFJBU9l7MsuCrQJovsM/oW56IHkUfJd1jas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790632749; c=relaxed/simple;
	bh=JTkZ8iO5TojJ0b+y+8HP96WhBFRVhrd5WKuFaL+85Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E16CuEIEFTtJ5riVFoCQ9iydD0lPBrF5W46N5TB2/bFY+dvSVqgLPNxE1KEPnnhX6hFlKId5Mup4kaIr5fU4tLh+QgMNDCLJnV3DpEw6J8tpyA25ESgBOyzmRi4O1ZGetYjkmXD9lr2IjEcrxy/y1j4CL+Q8qGMx6qDg/r5/Ih8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=BvhzwYdL; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="BvhzwYdL"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7bcb94d3so26167375e9.2
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Sep 2026 14:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790632745; x=1791237545; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gUCTjWRArg7XG8udPABK3T4ssyv2d91SWVxVNBbNR8=;
        b=BvhzwYdLVLGScd8DJHoXpOEiMh/sGJOIyiHmfCN2lARTNZ2vhArlX9ICifalpkTWK2
         YXRSgj0sLim+xBv+8Fn5flahM2IyX9XOCcpKcKQ/hanb0H1jC5LitoD18InyHTNv1etx
         W8dvn7XzMBzC9LeTeHourNsussGxi5cKx2LaF7/EK1mdazN5RuvSvmCMSqS35VNMjfo5
         bp8rlDA7WA0CHdeDbLJ2P0MO0x1O5+d47Rtr4mL2rU2oUkr1husa8y9xdEkg+cGKAn8e
         TznV1wxBybstR5GDC08nkCkXZDa2sfQ2PxfBk04rNpUlh6+NhFalQaQHO5clIUfcYNu7
         zhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790632745; x=1791237545;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8gUCTjWRArg7XG8udPABK3T4ssyv2d91SWVxVNBbNR8=;
        b=HVU6qDuTQ3iRSOK5NIEw263DNTZ7Jfi3ySoJF3Y+tyAg/64ziQ0qs0kox3MlVklrRQ
         7xCs83iPpWVm1sEw1OVSLgL7KdwiYsa2quu9zHZscJnzUtcDQXmzWikzAMINIPzBby6I
         aTKdyPu6wdmbmSL1Fr0cfCCQQXqEOL4/CDBFwWSt5f4mFfdNZU0KtP2M8dXvMEchKKn7
         /EtkF6NQM6FvptURiqaQGf4FO/hlG5/CT/7HcgJNeAxzsLuPYlqSMDHGfjWicR0jBlmS
         XBJ1BXf5V+rOkrDKwXQC5aGNJQSkFbw2aB0KynFG41/r6Oj73QzIF51ra7ChbWrgo0Z8
         nraA==
X-Gm-Message-State: AFuF++lWfM2Q4LoZfG4hm9Jm7VlDRBc5Q5pTi9tmWA9Rxzm0viBd5DRv
	vPUS/obgJEjqJUcX2Yy38zh8RIrn18crCkOkVD00WUnBbsxW9zMqSKoeQlJA02p8fTpt9QiitdD
	V+Pf7n7zhPA==
X-Gm-Gg: AYBFou3B6UJzuTKvh8dK9ffbMBioRO0PWarN67mQda8ezJxlShFjkFNARaQDSPyYM/E
	WDjsztTpqe26pYKr8h5PBh6IeTL4PZjkjHhFIGjCPUD/usNgjTIcjjsPIHlb0WPZnnX/qmlzEmc
	zvSt+KHF5g6ZY9176H7X+DWeWTlcpn9IuzVZIqr4umZKz1N21ZoqFpSpQ3vQEC8LITBOWQ6Rvh8
	see2X+VFnKrmtUYkpQlpzueA5L11wJRyvR6n8AJbcfC5We2aASWcO0o0JvANILOkBx7LVg9Llcv
	NmnpUCeTji6A/cMYgan8TQpvq8SGGRfRUAFHAH54/QTgJEycG6x1HKrTJ2f76TqbiKOwSmhjFI+
	cSDRe0hryu0IywaC3n1TgR6Fgr5uvf247Vy4nsYzWRwZgaEepJJGqQmJsU4pZ+9NjJ5MiiMyk5u
	RonB7bul9syXrx10G6jgo3TYCDFiepLIsWPvCyx1t2BlcUH1vAshKnvgPKazce/eG5
X-Received: by 2002:a05:600c:4745:b0:49d:10d6:fd55 with SMTP id 5b1f17b1804b1-49fe66abd7fmr256583735e9.1.1790632744751;
        Mon, 28 Sep 2026 14:59:04 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc794ef8befsm4387609a12.12.2026.09.28.14.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 14:59:03 -0700 (PDT)
Message-ID: <0638f593-0dba-46d4-a786-cdc1f2b365b7@suse.com>
Date: Tue, 29 Sep 2026 07:29:00 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: move __TRANS_* and TRANS_* flags out of
 transaction.h
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1790229298.git.wqu@suse.com>
 <f8b46621fa212642c4d961f790bac84ec42adb49.1790229298.git.wqu@suse.com>
 <CAL3q7H5MNUCakyQSzYQgBcrb79qtYDEHGfsrjoaHTAkRv=Kz_A@mail.gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <CAL3q7H5MNUCakyQSzYQgBcrb79qtYDEHGfsrjoaHTAkRv=Kz_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/29 03:57, Filipe Manana 写道:
> On Thu, Sep 24, 2026 at 7:00 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> Among all those flags, only __TRANS_DUMMY is used outside of
>> transaction.[ch], and there are only two places using it:
>>
>> - find_parent_nodes()
>>    Introduce a helper, btrfs_trans_is_dummy(), for this call site.
>>
>> - btrfs_init_dummy_trans()
>>    Move the function into transaction.[ch], and hide it behind
>>    CONFIG_BTRFS_FS_RUN_SANITY_TESTS.
>>
>> With the above changes, we can hide __TRANS_* and TRANS_* flags inside
>> transaction.c. This allows us to modify those flags in the future
>> without causing any changes to existing callers.
>>
>> After the flags relocation, now we can also hide __TRANS_DUMMY behind
>> CONFIG_BTRFS_FS_RUN_SANITY_TESTS.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/backref.c           |  2 +-
>>   fs/btrfs/tests/btrfs-tests.c |  9 ---------
>>   fs/btrfs/tests/btrfs-tests.h |  2 --
>>   fs/btrfs/transaction.c       | 36 ++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/transaction.h       | 29 +++++++++++------------------
>>   5 files changed, 48 insertions(+), 30 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 1be632c742bd..939511629ecc 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -1432,7 +1432,7 @@ static int find_parent_nodes(struct btrfs_backref_walk_ctx *ctx,
>>                  goto out;
>>          }
>>
>> -       if (ctx->trans && likely(ctx->trans->type != __TRANS_DUMMY) &&
>> +       if (ctx->trans && likely(!btrfs_trans_is_dummy(ctx->trans)) &&
>>              ctx->time_seq != BTRFS_SEQ_LAST) {
>>                  /*
>>                   * We have a specific time_seq we care about and trans which
>> diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
>> index 6287d940323d..cebc9a17b94d 100644
>> --- a/fs/btrfs/tests/btrfs-tests.c
>> +++ b/fs/btrfs/tests/btrfs-tests.c
>> @@ -247,15 +247,6 @@ void btrfs_init_dummy_transaction(struct btrfs_transaction *trans, struct btrfs_
>>          spin_lock_init(&trans->delayed_refs.lock);
>>   }
>>
>> -void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
>> -                           struct btrfs_fs_info *fs_info)
>> -{
>> -       memset(trans, 0, sizeof(*trans));
>> -       trans->transid = 1;
>> -       trans->type = __TRANS_DUMMY;
>> -       trans->fs_info = fs_info;
>> -}
>> -
>>   int btrfs_run_sanity_tests(void)
>>   {
>>          int ret, i;
>> diff --git a/fs/btrfs/tests/btrfs-tests.h b/fs/btrfs/tests/btrfs-tests.h
>> index cea58fe84a6d..a16855138105 100644
>> --- a/fs/btrfs/tests/btrfs-tests.h
>> +++ b/fs/btrfs/tests/btrfs-tests.h
>> @@ -59,8 +59,6 @@ btrfs_alloc_dummy_block_group(struct btrfs_fs_info *fs_info, unsigned long lengt
>>   void btrfs_free_dummy_block_group(struct btrfs_block_group *cache);
>>   DEFINE_FREE(btrfs_free_dummy_block_group, struct btrfs_block_group *,
>>              btrfs_free_dummy_block_group(_T));
>> -void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
>> -                           struct btrfs_fs_info *fs_info);
>>   void btrfs_init_dummy_transaction(struct btrfs_transaction *trans, struct btrfs_fs_info *fs_info);
>>   struct btrfs_device *btrfs_alloc_dummy_device(struct btrfs_fs_info *fs_info);
>>
>> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
>> index ca114235bbe1..4181f3897a30 100644
>> --- a/fs/btrfs/transaction.c
>> +++ b/fs/btrfs/transaction.c
>> @@ -38,6 +38,26 @@
>>
>>   static struct kmem_cache *btrfs_trans_handle_cachep;
>>
>> +enum {
>> +       ENUM_BIT(__TRANS_FREEZABLE),
>> +       ENUM_BIT(__TRANS_START),
>> +       ENUM_BIT(__TRANS_ATTACH),
>> +       ENUM_BIT(__TRANS_JOIN),
>> +       ENUM_BIT(__TRANS_JOIN_NOLOCK),
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +       ENUM_BIT(__TRANS_DUMMY),
>> +#endif
>> +       ENUM_BIT(__TRANS_JOIN_NOSTART),
>> +};
>> +
>> +#define TRANS_START            (__TRANS_START | __TRANS_FREEZABLE)
>> +#define TRANS_ATTACH           (__TRANS_ATTACH)
>> +#define TRANS_JOIN             (__TRANS_JOIN | __TRANS_FREEZABLE)
>> +#define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
>> +#define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)
>> +
>> +#define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
>> +
>>   /*
>>    * Transaction states and transitions
>>    *
>> @@ -139,6 +159,22 @@ static const unsigned int btrfs_blocked_trans_types[TRANS_STATE_MAX] = {
>>                                             __TRANS_JOIN_NOSTART),
>>   };
>>
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
>> +{
> 
> So most of our exported transaction functions have names like:
> 
> btrfs_end_transaction()
> btrfs_commit_transaction()
> btrfs_start_transaction()
> btrfs_abort_transaction()
> etc
> 
> So I would suggest, for consistency, naming it as:  btrfs_is_dummy_transaction()

That sounds good.
> 
>> +       return trans->type == __TRANS_DUMMY;
>> +}
>> +
>> +void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
>> +                           struct btrfs_fs_info *fs_info)
>> +{
> 
> And here; btrfs_init_dummy_transaction()

Unfortunately we already have one in the selftests with the same name, 
but using btrfs_transaction as the first parameter.

Thus I'm afraid I have to keep this name.

Thanks,
Qu

> 
> Otherwise:
> 
> Reviewed-by: Filipe Manana <fdmanana@suse.com>
> 
> Thanks.
> 
>> +       memset(trans, 0, sizeof(*trans));
>> +       trans->transid = 1;
>> +       trans->type = __TRANS_DUMMY;
>> +       trans->fs_info = fs_info;
>> +}
>> +#endif
>> +
>>   void btrfs_put_transaction(struct btrfs_transaction *transaction)
>>   {
>>          if (refcount_dec_and_test(&transaction->use_count)) {
>> diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
>> index 89153cd22596..9eb92b1ad54d 100644
>> --- a/fs/btrfs/transaction.h
>> +++ b/fs/btrfs/transaction.h
>> @@ -119,24 +119,6 @@ struct btrfs_transaction {
>>          wait_queue_head_t pending_wait;
>>   };
>>
>> -enum {
>> -       ENUM_BIT(__TRANS_FREEZABLE),
>> -       ENUM_BIT(__TRANS_START),
>> -       ENUM_BIT(__TRANS_ATTACH),
>> -       ENUM_BIT(__TRANS_JOIN),
>> -       ENUM_BIT(__TRANS_JOIN_NOLOCK),
>> -       ENUM_BIT(__TRANS_DUMMY),
>> -       ENUM_BIT(__TRANS_JOIN_NOSTART),
>> -};
>> -
>> -#define TRANS_START            (__TRANS_START | __TRANS_FREEZABLE)
>> -#define TRANS_ATTACH           (__TRANS_ATTACH)
>> -#define TRANS_JOIN             (__TRANS_JOIN | __TRANS_FREEZABLE)
>> -#define TRANS_JOIN_NOLOCK      (__TRANS_JOIN_NOLOCK)
>> -#define TRANS_JOIN_NOSTART     (__TRANS_JOIN_NOSTART)
>> -
>> -#define TRANS_EXTWRITERS       (__TRANS_START | __TRANS_ATTACH)
>> -
>>   /*
>>    * Number of extent buffers a transaction handle tracks for writeback
>>    * inhibition. The CLOCK reference bits pack into a u32 so this must not exceed
>> @@ -305,6 +287,17 @@ do {                                                               \
>>                                    __LINE__, __error);           \
>>   } while (0)
>>
>> +#ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
>> +bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans);
>> +void btrfs_init_dummy_trans(struct btrfs_trans_handle *trans,
>> +                           struct btrfs_fs_info *fs_info);
>> +#else
>> +static inline bool btrfs_trans_is_dummy(const struct btrfs_trans_handle *trans)
>> +{
>> +       return false;
>> +}
>> +#endif
>> +
>>   int btrfs_end_transaction(struct btrfs_trans_handle *trans);
>>   struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,
>>                                                     unsigned int num_items);
>> --
>> 2.55.0
>>
>>

