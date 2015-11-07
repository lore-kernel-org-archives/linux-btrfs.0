Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:33120 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbKGQYO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Nov 2015 11:24:14 -0500
Received: by wijp11 with SMTP id p11so46436436wij.0
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Nov 2015 08:24:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <563B54DF.7080202@googlemail.com>
References: <1420473663-9315-1-git-send-email-naota@elisp.net>
	<54AC65C2.8000801@jp.fujitsu.com>
	<CAOcd+r10Q08zhvjMawOrQ8jWBReD6dYxeEtiZSoqUEuHCeM27g@mail.gmail.com>
	<563B54DF.7080202@googlemail.com>
Date: Sat, 7 Nov 2015 18:24:12 +0200
Message-ID: <CAOcd+r1=D0MY=0bGBRwX_K5eEUxmzmxVKjNHpgd0520T3+avdw@mail.gmail.com>
Subject: Re: [PATCH] btrfs: clear bio reference after submit_one_bio()
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Naohiro Aota <naota@elisp.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Holger,
I think it will cause an invalid paging request, just like in case
that Naohiro has fixed.
I am not running the "latest and greatest" btrfs in my system, and it
is not easy to set it up, that's why I cannot submit patches based on
the latest code, I can only review and comment on patches.

Alex.


On Thu, Nov 5, 2015 at 3:08 PM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On 10/11/15 20:09, Alex Lyakas wrote:
>> Hi Naota,
>>
>> What happens if btrfs_bio_alloc() in submit_extent_page fails? Then we
>> return -ENOMEM to the caller, but we do not set *bio_ret to NULL. And
>> if *bio_ret was non-NULL upon entry into submit_extent_page, then we
>> had submitted this bio before getting to btrfs_bio_alloc(). So should
>> btrfs_bio_alloc() failure be handled in the same way?
>>
>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>> index 3915c94..cd443bc 100644
>> --- a/fs/btrfs/extent_io.c
>> +++ b/fs/btrfs/extent_io.c
>> @@ -2834,8 +2834,11 @@ static int submit_extent_page(int rw, struct
>> extent_io_tree *tree,
>>
>>         bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
>>                         GFP_NOFS | __GFP_HIGH);
>> -       if (!bio)
>> +       if (!bio) {
>> +               if (bio_ret)
>> +                       *bio_ret = NULL;
>>                 return -ENOMEM;
>> +       }
>>
>>         bio_add_page(bio, page, page_size, offset);
>>         bio->bi_end_io = end_io_func;
>>
>
> Did you get any feedback on this? It seems it could cause data loss or
> corruption on allocation failures, no?
>
> -h
>
