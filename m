Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from m199-177.yeah.net ([123.58.177.199]:42117 "EHLO
	m199-177.yeah.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2JYP7L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 11:59:11 -0400
Received: from mail-wi0-f178.google.com (mail-wi0-f178.google.com [209.85.212.178])
	by m199-177.yeah.net (HMail) with ESMTPA id 54AF010027C
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 23:59:07 +0800 (CST)
Received: by mail-wi0-f178.google.com with SMTP id hr7so1811579wib.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2012 08:59:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025153731.GI10679@twin.jikos.cz>
References: <CAMRmmpL01PqR1nZPGhyDv1ECdWaBDrhVbx-9FH83x-3ez+M_pQ@mail.gmail.com>
 <20121025153731.GI10679@twin.jikos.cz>
From: Rock Lee <zimilo@code-trick.com>
Date: Thu, 25 Oct 2012 23:58:24 +0800
Message-ID: <CAMRmmpLfbzAcf7M5T0UYHv7-R6PeprwGpgb-YfLfWpvp9PA8Gw@mail.gmail.com>
Subject: Re: [BUG][BTRFS-PROGS] Fix Bug to corrupt the img file
To: dave@jikos.cz, Rock Lee <zimilo@code-trick.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Got it.

2012/10/25 David Sterba <dave@jikos.cz>:
> On Wed, Oct 24, 2012 at 10:04:47AM +0800, Rock Lee wrote:
>> @@ -572,7 +576,7 @@ int btrfs_prepare_device(int fd, char *file, int
>> zero_end, u64 *block_count_ret,
>>                 discard_blocks(fd, 0, block_count);
>>         }
>>
>> -       ret = zero_dev_start(fd);
>> +       ret = zero_dev_start(fd, block_count);
>>         if (ret) {
>>                 fprintf(stderr, "failed to zero device start %d\n", ret);
>>                 exit(1);
>
> Please add a separate check for a minimal image size instead, right after
>
>  553         block_count = device_size(fd, &st);
>  554         if (block_count == 0) {
>  555                 fprintf(stderr, "unable to find %s size\n", file);
>  556                 exit(1);
>  557         }
>  558         if (max_block_count)
>  559                 block_count = min(block_count, max_block_count);
>
>              if (block_count < 2 MB ) {
>                      fprintf(stderr, "Image too small (less than 2MB)");
>                      exit
>              }
>
> thanks,
> david
