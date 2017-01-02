Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33548 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdABMcK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jan 2017 07:32:10 -0500
Received: by mail-yw0-f193.google.com with SMTP id s68so35377140ywg.0
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Jan 2017 04:32:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <trinity-99778bf7-78b4-4455-8c1a-32e20c3e71e8-1483245504786@3capp-mailcom-bs08>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <trinity-99778bf7-78b4-4455-8c1a-32e20c3e71e8-1483245504786@3capp-mailcom-bs08>
From: Peter Becker <floyd.net@gmail.com>
Date: Mon, 2 Jan 2017 13:32:08 +0100
Message-ID: <CAEtw4r2ksf_m8r=Bn5YPazG39y65TKFG66ekQSL8FBYgwH3XtQ@mail.gmail.com>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Xin Zhou <xin.zhou@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 1M is already a little bit too big in size.

Not in my usecase :)

Is it right the this isn't an limit in btrfs? So i can patch this and try 100M.
The reason is, that i must dedupe the whole 8 TB in less then a day
but with 128K and 1M blocksize it will take a week.

I don't know why adding extends take so long.
I/O during adding extends is less then 4MB/s, and CPU (dual core) and
memory (8 GB) usage are less then 20%, on bare metal.

2017-01-01 5:38 GMT+01:00 Xin Zhou <xin.zhou@gmx.com>:
> Hi,
>
> In general, the larger the block / chunk size is, the less dedup can be achieved.
> 1M is already a little bit too big in size.
>
> Thanks,
> Xin
>
>
>
>
> Sent: Friday, December 30, 2016 at 12:28 PM
> From: "Peter Becker" <floyd.net@gmail.com>
> To: linux-btrfs <linux-btrfs@vger.kernel.org>
> Subject: [markfasheh/duperemove] Why blocksize is limit to 1MB?
> Hello, i have a 8 TB volume with multiple files with hundreds of GB each.
> I try to dedupe this because the first hundred GB of many files are identical.
> With 128KB blocksize with nofiemap and lookup-extends=no option, will
> take more then a week (only dedupe, previously hashed). So i tryed -b
> 100M but this returned me an error: "Blocksize is bounded ...".
>
> The reason is that the blocksize is limit to
>
> #define MAX_BLOCKSIZE (1024U*1024)
>
> But i can't found any description why.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
