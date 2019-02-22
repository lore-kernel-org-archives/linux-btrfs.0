Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CA8C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 13:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC172075A
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 13:29:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QqDev9DY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbfBVN3m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 08:29:42 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40346 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfBVN3m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 08:29:42 -0500
Received: by mail-ed1-f65.google.com with SMTP id 10so1747951eds.7
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2019 05:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ye28bOj2Uke5gCehuMC9hYe0bLuwHX1hHm+fyusExLM=;
        b=QqDev9DYwbiPLu19PPwn5MSQ3NZ5RaAGCSb299zDjXKWaAgL8orSi/PYYhb8pfXiwl
         RErC3OWQplX/FI3Ter7frt+2hRzyJO6sXAFWAaW4kX8yRhjW4XmNrbTEHa9tlcg7i0tY
         RHz1q3765XkbDvOHh1eEzI1g1s4gVXjPvjSEd/+7EEIM0BmYs31SvO5Oxz8z0zsF4mKG
         dg98x3uK4O3LIZb8/r2w63VLDXAMeFOtpY0yYzGi4pL50QlpAiv30PjBpnK206aceOlP
         4zpTyavkAqgV88/SFipS3zIfiU1pfHp8rSTeG80LQacaXIuQzt6Bhdg5S+gci9pffoiH
         1s6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ye28bOj2Uke5gCehuMC9hYe0bLuwHX1hHm+fyusExLM=;
        b=kdC8jlQdjG5BVWvIK3VxF1zdA+eHheZj6HAft3Xat/OqTKjh3aIEgFvL5DNlO/Ze8u
         MG8RKeEPhk7MVzWfTueO0HDbR6qc12NlOYNw0tL7VliAt1QG/smoUzDXS+7RDfN8pe12
         Ti6wuv9zRuj0x12she3u05IDbmwsKW9iSsz1MZJEiXRHT2DLOcPgb9eS23gxlbJpOrIb
         HJUSIUkfhkPQ168/sz8+yzhVBj1s/fRTrD2v2I0M2wH9z9O7CRbrxovffiQSx5/iRtxd
         oahSq5PJIKN4LaT8T8g8wGjc+7eZZ4lSkD4aOXhwzZCy1Xex3ncZE23jq5N8We+HsTh1
         4ZSA==
X-Gm-Message-State: AHQUAuYLqIrkXwqLuGUsCZF8MZAkE9o+3pQiIvw61TEtluqOlTZblICu
        l0Vgt6N5orNFVnab7rhVDvg=
X-Google-Smtp-Source: AHgI3IZ7b6uDengY4A6C1oBnenL30mI92ZcrJMdG5/zPjWcb3j7TAZkF8cObtIzQll4fQBgFYLkUmw==
X-Received: by 2002:a50:ac58:: with SMTP id w24mr3122142edc.287.1550842180236;
        Fri, 22 Feb 2019 05:29:40 -0800 (PST)
Received: from [10.20.1.223] (ivokamhome.ddns.nbis.net. [87.120.136.31])
        by smtp.gmail.com with ESMTPSA id f48sm411333edd.56.2019.02.22.05.29.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Feb 2019 05:29:39 -0800 (PST)
Subject: Re: [PATCH 0/5] Unify the return value of alloc/clone_extent_buffer()
To:     Qu Wenruo <wqu@suse.de>, linux-btrfs@vger.kernel.org
Cc:     dan.carpenter@oracle.com
References: <20190222101645.4403-1-wqu@suse.com>
 <b676a401-2eeb-f105-d363-742137a13ded@gmail.com>
 <b132529d-1246-4cb4-202a-37bf84e7ba43@suse.de>
From:   Nikolay Borisov <n.borisov.lkml@gmail.com>
Message-ID: <7845f981-dbc3-6160-a329-33f0014ba973@gmail.com>
Date:   Fri, 22 Feb 2019 15:29:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <b132529d-1246-4cb4-202a-37bf84e7ba43@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 22.02.19 г. 15:02 ч., Qu Wenruo wrote:
> 
> 
> On 2019/2/22 下午8:54, Nikolay Borisov wrote:
>>
>>
>> On 22.02.19 г. 12:16 ч., Qu Wenruo wrote:
>>> This patchset can be fetched from github:
>>> https://github.com/adam900710/linux/tree/cleanup_alloc_extent_buffer
>>> Which is based on v5.0-rc7
>>>
>>> There are 5 extent buffer alloc functions in btrfs:
>>> __alloc_extent_buffer();
>>> alloc_extent_buffer();
>>> __alloc_dummy_extent_buffer();
>>> alloc_dummy_extent_buffer();
>>> alloc_test_extent_buffer();
>>>
>>> However their return value is not unified for failure mode:
>>> __alloc_extent_buffer()		Never fail
>>> alloc_extent_buffer()		PTR_ERR()
>>> __alloc_dummy_extent_buffer()	NULL
>>
>> This function can never return NULL, if __alloc_extent_buffer cannot
>> fail then the only error this function returns is ERR_PTR(ENOMEM);
> 
> Nope.
> 
>         for (i = 0; i < num_pages; i++) {
>                 eb->pages[i] = alloc_page(GFP_NOFS);
>                 if (!eb->pages[i])
>                         goto err; <<< Page alloc failure here
>         }
> ...
> err:
>         for (; i > 0; i--)
>                 __free_page(eb->pages[i - 1]);
>         __free_extent_buffer(eb);
>         return NULL; << We got NULL.

Right, I was looking at the code AFTER having applied your patches. So I
agree with yout. However, the ordering of your patches and the
changelogs make it rather hard to understand. What I'd suggest regarding
the changelogs is - forget about unification, just say what you are
doing, which is always ensuring that an error is returned from
__alloc_extent_buffer in one patch - this should involve both changes to
__alloc_extent_buffer as well as it's (in)direct callers. Then you do
the same for other function. Otherwise review is somewhat hindered.

> }
> 
> For __alloc_dummy_extent_buffer, that's the only failure case.
> 
> And I'm interested how did you get the PTR_ERR() case?
> 
>>
>>> alloc_dummy_extent_buffer()	NULL
>> Same thing applies to this function
> 
> Nope.
> 
>>
>>> alloc_test_extent_buffer()	NULL
>>
>> Same thing for this function, if we return exists then we must have
>> found it by find_extent_buffer hence it cannot be null. Otherwise we
>> return eb as allocated from alloc_dummy_extent_buffer. So how can null
>> be returned?
> 
> And nope.
> 
>>
>> To me it really seems none of the function could return a NULL value, no?
> 
> Your misunderstand of __alloc_dummy_extent_buffer() makes the call chain
> all wrong.
> 
> Thanks,
> Qu
> 
>>
>>>
>>> This causes some wrapper function to have 2 failure modes, like
>>> btrfs_find_create_tree_block() can return NULL or PTR_ERR(-ENOMEM) for
>>> its failure.
>>>
>>> This inconsistent behavior is making static checker and reader crazy.
>>>
>>> This patchset will unify the failure more of above 5 functions to
>>> PTR_ERR().
>>>
>>> Qu Wenruo (5):
>>>   btrfs: extent_io: Add comment about the return value of
>>>     alloc_extent_buffer()
>>>   btrfs: extent_io: Unify the return value of __alloc_extent_buffer()
>>>     with alloc_extent_buffer()
>>>   btrfs: extent_io: Unify the return value of
>>>     alloc_dummy_extent_buffer() with alloc_extent_buffer()
>>>   btrfs: extent_io: Unify the return value of alloc_test_extent_buffer()
>>>     with alloc_extent_buffer()
>>>   btrfs: extent_io: Unify the return value of
>>>     btrfs_clone_extent_buffer() with alloc_extent_buffer()
>>>
>>>  fs/btrfs/backref.c                     |  8 ++--
>>>  fs/btrfs/ctree.c                       | 16 ++++----
>>>  fs/btrfs/extent_io.c                   | 56 +++++++++++++++++---------
>>>  fs/btrfs/qgroup.c                      |  5 ++-
>>>  fs/btrfs/tests/extent-buffer-tests.c   |  6 ++-
>>>  fs/btrfs/tests/extent-io-tests.c       |  4 +-
>>>  fs/btrfs/tests/free-space-tree-tests.c |  3 +-
>>>  fs/btrfs/tests/inode-tests.c           |  6 ++-
>>>  fs/btrfs/tests/qgroup-tests.c          |  3 +-
>>>  9 files changed, 68 insertions(+), 39 deletions(-)
>>>
>>
> 
