Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38634 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752449AbdACMlE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 07:41:04 -0500
Received: by mail-it0-f54.google.com with SMTP id x2so295761759itf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Jan 2017 04:41:03 -0800 (PST)
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
Date: Tue, 3 Jan 2017 07:40:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-30 15:28, Peter Becker wrote:
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
Beyond what Xin mentioned (namely that 1MB is a much larger block than 
will be duplicated in most data-sets), there are a couple of other reasons:
1. Smaller blocks will actually get you better deduplication on average 
because they're more likely to match.  As an example, assume you have 2 
files with the same 8 4k blocks in different orders:
   FileA: 1 2 3 4 5 6 7 8
   FileB: 7 8 5 6 3 4 1 2
In such a case, deduplicating at any block size above 8k would result in 
zero deduplication between these files, while 8k or less would 
completely deduplicate them.  This is of course a highly specific and 
somewhat contrived example (in most cases it will be scattered duplicate 
blocks over dozens of files), but it does convey this specific point.
2. The kernel will do a byte-wise comparison of all ranges you pass into 
the ioctl at the same time.  Larger block sizes here mean that:
	a) The extents will be locked longer, which will prevent any I/O to the 
files being deduplicated for the duration of the comparison, which may 
in turn cause other issues on the system.
	b) The deduplication process will be stuck in uninterruptible sleep 
longer, which on many systems will trigger hung task detection, which 
will in turn either spam the system log or panic the system depending on 
how it's configured.

