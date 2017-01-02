Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64072 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933935AbdABTgF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jan 2017 14:36:05 -0500
MIME-Version: 1.0
Message-ID: <trinity-b8db84a6-4613-42c5-8eb6-38c8b1354184-1483385761401@3capp-mailcom-bs06>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Peter Becker" <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
Content-Type: text/plain; charset=UTF-8
Date: Mon, 2 Jan 2017 20:36:01 +0100
In-Reply-To: <CAEtw4r2ksf_m8r=Bn5YPazG39y65TKFG66ekQSL8FBYgwH3XtQ@mail.gmail.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <trinity-99778bf7-78b4-4455-8c1a-32e20c3e71e8-1483245504786@3capp-mailcom-bs08>,
 <CAEtw4r2ksf_m8r=Bn5YPazG39y65TKFG66ekQSL8FBYgwH3XtQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Before doing that, probably one way to think about it could be,
what would be the probablitity of two 100M blocks generate the same hash and be treated as identical.
Thanks,
Xin
 
 

Sent: Monday, January 02, 2017 at 4:32 AM
From: "Peter Becker" <floyd.net@gmail.com>
To: "Xin Zhou" <xin.zhou@gmx.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
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
