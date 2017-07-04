Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34035 "EHLO
        mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdGDLLw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jul 2017 07:11:52 -0400
Received: by mail-qk0-f178.google.com with SMTP id d78so165236208qkb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Jul 2017 04:11:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170703173040.GB2866@twin.jikos.cz>
References: <20170701165602.31189-1-nefelim4ag@gmail.com> <20170701165602.31189-3-nefelim4ag@gmail.com>
 <20170703173040.GB2866@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 4 Jul 2017 14:11:10 +0300
Message-ID: <CAGqmi74FqgHzshWZti06NBp2xYjjE0reao4AqCM6vMfz4Q-qEg@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/2] Btrfs: add heuristic method for make decision
 compress or not compress
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-07-03 20:30 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Sat, Jul 01, 2017 at 07:56:02PM +0300, Timofey Titovets wrote:
>> Add a heuristic computation before compression,
>> for avoiding load resource heavy compression workspace,
>> if data are probably can't be compressed
>>
>> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
>> --- /dev/null
>> +++ b/fs/btrfs/heuristic.c
>
> For the new heuristic-related code, please use the compression.h and .c
> files and don't add a new one. When we're going to add the clever
> heuristics, that could go to a separate file.

Okay.

>> @@ -0,0 +1,336 @@
>> +enum compression_advice btrfs_compress_heuristic(struct inode *inode,
>
> This returns enum but the caller treats it as a bool, this should be
> synced up.
>

I think for now, enum and values can be just dropped,
because it's only a proof of concept that in future, heuristic
can return more complex answer and then some of that values
can be used as acceptable for zlib and unnacceptable for lzo & etc.
Also that can be easy added again later.

>
> As mentioned in the previous mail, we'll add the skeleton code only for
> now, which means this loop, that simply calls find_get_page, kunmap and
> put_page.
>

So, i will send a separate patch for skeleton code.
And if i understood all correctly, later, we'll add complex code one by one.

>> +
>> +enum compression_advice {
>> +     COMPRESS_NONE,
>> +     COMPRESS_COST_UNKNOWN,
>> +     COMPRESS_COST_EASY,
>> +     COMPRESS_COST_MEDIUM,
>> +     COMPRESS_COST_HARD
>
> I don't find the naming good, as the cost is not easy or hard, but
> rather low/medium/high. Or you can rename the whole prefix if you find a
> better naming scheme.

(Explain above)
So just drop that for now.

About naming scheme, at least i preffer to use numbers, something like:
COMPRESS_COST_INF, // as false
COMPRESS_COST_1,
COMPRESS_COST_2,
Because it's very dependence on the step when code make a decision, and
code can't directly detect how many cpu time will be used for that data.

>>       struct btrfs_key *location;
>> @@ -458,16 +459,16 @@ static noinline void compress_file_range(struct inode *inode,
>>       unsigned long total_compressed = 0;
>>       unsigned long total_in = 0;
>>       int i;
>> -     int will_compress;
>> +     bool will_compress;
>
> Please remove this change.
>
>>       int compress_type = fs_info->compress_type;
>> -     int redirty = 0;
>> +     bool redirty = false;
>
> And this.
>

Okay, i will drop bool changes,
Thank you very match!

-- 
Have a nice day,
Timofey.
