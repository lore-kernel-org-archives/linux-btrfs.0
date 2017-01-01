Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61686 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752989AbdAAEi1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Dec 2016 23:38:27 -0500
MIME-Version: 1.0
Message-ID: <trinity-99778bf7-78b4-4455-8c1a-32e20c3e71e8-1483245504786@3capp-mailcom-bs08>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Peter Becker" <floyd.net@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
Content-Type: text/plain; charset=UTF-8
Date: Sun, 1 Jan 2017 05:38:24 +0100
In-Reply-To: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

In general, the larger the block / chunk size is, the less dedup can be achieved.
1M is already a little bit too big in size.

Thanks,
Xin

 
 

Sent: Friday, December 30, 2016 at 12:28 PM
From: "Peter Becker" <floyd.net@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: [markfasheh/duperemove] Why blocksize is limit to 1MB?
Hello, i have a 8 TB volume with multiple files with hundreds of GB each.
I try to dedupe this because the first hundred GB of many files are identical.
With 128KB blocksize with nofiemap and lookup-extends=no option, will
take more then a week (only dedupe, previously hashed). So i tryed -b
100M but this returned me an error: "Blocksize is bounded ...".

The reason is that the blocksize is limit to

#define MAX_BLOCKSIZE (1024U*1024)

But i can't found any description why.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
