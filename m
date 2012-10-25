Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m53-178.qiye.163.com ([123.58.178.53]:54605 "EHLO
	m53-178.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2JYXhp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 19:37:45 -0400
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com [209.85.215.46])
	by m53-178.qiye.163.com (HMail) with ESMTPA id EFCCC1228437
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Oct 2012 07:37:40 +0800 (CST)
Received: by mail-la0-f46.google.com with SMTP id h6so2090254lag.19
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 16:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025164350.GL10679@twin.jikos.cz>
References: <CAMRmmpLUsC=L=4sUf09Gx97W1hvc2FoOMmqOydiZQ6XwumUoYQ@mail.gmail.com>
 <20121025164350.GL10679@twin.jikos.cz>
From: Rock Lee <zimilo@code-trick.com>
Date: Fri, 26 Oct 2012 07:36:58 +0800
Message-ID: <CAMRmmpJ9R2xPE-ppoyD+9N53eWH0CO1DB8HLCZPdtsb=SaMLeg@mail.gmail.com>
Subject: Re: [PATCH V2][BTRFS-PROGS] [BUG] Fix Bug to corrupt the img file
 Reply-To: dave@jikos.cz
To: Rock Lee <zimilo@code-trick.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your review.

Sorry for the problem line wrapped, I will resend the patch.


Thanks
-Rock

2012/10/26 David Sterba <dave@jikos.cz>:
> On Fri, Oct 26, 2012 at 12:12:24AM +0800, Rock Lee wrote:
>> Fix Bug to corrupt the img file
>>
>> Reproduce steps:
>>   > dd if=/dev/zero of=btrfs-small.img bs=1M count=1
>>   > ls -lh btrfs-small.img
>>   -rw-rw-r--. 1 rock rock 1.0M Oct 24 09:51 btrfs-small.img
>>                                       ^^^
>>   > mkfs.btrfs btrfs-small.img
>>   -rw-rw-r--. 1 rock rock 2.0M Oct 24 09:53 btrfs-small.img
>>                                       ^^^
>>
>> Here you can see the original img file's size goes larger to 2Mb.
>
> Thanks, fixes this particular bug; although it crashes later at
>
>   mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed
>
> but this is a separate issue and you've sent patches for that IIRC.
>
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -557,6 +557,12 @@ int btrfs_prepare_device(int fd, char *file, int
>> zero_end, u64 *block_count_ret,
>>         }
>>         if (max_block_count)
>>                 block_count = min(block_count, max_block_count);
>> +
>> +       if (block_count < 2 * 1024 * 1024) {
>> +               fprintf(stderr, "size of %s is too small(less than
>> 2Mb)\n", file);
>
> line wrapped, please check your mailer (easy to fix but additional
> unnecessary work)
>
>> +               exit(1);
>> +       }
>> +
>
> Otherwise ack from me.
>
> david
