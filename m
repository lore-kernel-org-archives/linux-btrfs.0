Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36552 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753588AbdETSb3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 May 2017 14:31:29 -0400
Received: by mail-qk0-f196.google.com with SMTP id y128so14146322qka.3
        for <linux-btrfs@vger.kernel.org>; Sat, 20 May 2017 11:31:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170520191400.25202d75@jupiter.sol.kaishome.de>
References: <20170520164953.7344-1-nefelim4ag@gmail.com> <20170520164953.7344-3-nefelim4ag@gmail.com>
 <20170520191400.25202d75@jupiter.sol.kaishome.de>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Sat, 20 May 2017 21:30:47 +0300
Message-ID: <CAGqmi76cLmXOj=P7qeR58n1aHNB-6e1R0yo+PjuMVLLgnWaryg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] Btrfs: compression must free at least PAGE_SIZE
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-20 20:14 GMT+03:00 Kai Krakow <hurikhan77@gmail.com>:
> Am Sat, 20 May 2017 19:49:53 +0300
> schrieb Timofey Titovets <nefelim4ag@gmail.com>:
>
>> Btrfs already skip store of data where compression didn't free at
>> least one byte. So make logic better and make check that compression
>> free at least one PAGE_SIZE, because in another case it useless to
>> store this data compressed
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> ---
>>  fs/btrfs/lzo.c  | 5 ++++-
>>  fs/btrfs/zlib.c | 3 ++-
>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
>> index bd0b0938..7f38bc3c 100644
>> --- a/fs/btrfs/lzo.c
>> +++ b/fs/btrfs/lzo.c
>> @@ -229,8 +229,11 @@ static int lzo_compress_pages(struct list_head
>> *ws, in_len = min(bytes_left, PAGE_SIZE);
>>       }
>>
>> -     if (tot_out > tot_in)
>> +     /* Compression must save at least one PAGE_SIZE */
>> +     if (tot_out + PAGE_SIZE => tot_in) {
>
> Shouldn't this be ">" instead of ">=" (btw, I don't think => works)...
(D'oh, typo, thanks)

> Given the case that tot_in is 8192, and tot_out is 4096, we saved a
> complete page but 4096+4096 would still be equal to 8192.
>
> The former logic only pretended that there is no point in compression
> if we saved 0 bytes.

Before my changes,
lzo: if compressed data use same or less space in compare to not
compressed -> save compressed version
zlib: if profit of compression will not save at least one byte -> not
compress that data

zlib logic is right, so i just did copy-paste that, but after my
changes this case where compressed size == input size doesn't valid
(i.e. it's ok then tot_out + PAGE_SIZE == tot_in),
so you right ">=" -> ">"

i will fix that and resend patch set, thanks.

> BTW: What's the smallest block size that btrfs stores? Is it always
> PAGE_SIZE? I'm not familiar with btrfs internals...
https://btrfs.wiki.kernel.org/index.php/Manpage/mkfs.btrfs
AFAIK btrfs works with storage and account data by PAGE_SIZEd block,
so it's must be usefull to check if compressed size will give as at
least one PAGE_SIZE space.

>
>> +             ret = -E2BIG;
>>               goto out;
>> +     }
>>
>>       /* store the size of all chunks of compressed data */
>>       cpage_out = kmap(pages[0]);
>> diff --git a/fs/btrfs/zlib.c b/fs/btrfs/zlib.c
>> index 135b1082..2b04259b 100644
>> --- a/fs/btrfs/zlib.c
>> +++ b/fs/btrfs/zlib.c
>> @@ -191,7 +191,8 @@ static int zlib_compress_pages(struct list_head
>> *ws, goto out;
>>       }
>>
>> -     if (workspace->strm.total_out >= workspace->strm.total_in) {
>> +     /* Compression must save at least one PAGE_SIZE */
>> +     if (workspace->strm.total_out + PAGE_SIZE >=
>> workspace->strm.total_in) { ret = -E2BIG;
>
> Same as above...
>
>>               goto out;
>>       }
>> --
>> 2.13.0
>
>
> --
> Regards,
> Kai



-- 
Have a nice day,
Timofey.
