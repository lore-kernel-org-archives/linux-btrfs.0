Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f53.google.com ([209.85.214.53]:38851 "EHLO
        mail-it0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeDRQiG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Apr 2018 12:38:06 -0400
Received: by mail-it0-f53.google.com with SMTP id 19-v6so3209463itw.3
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Apr 2018 09:38:06 -0700 (PDT)
Subject: Re: nvme+btrfs+compression sensibility and benchmark
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
References: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f336feb1-5da4-6d08-53f5-0a591253218b@gmail.com>
Date: Wed, 18 Apr 2018 12:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <271cf4a5-92d6-04eb-5f7a-471c2997ca48@swiftspirit.co.za>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-04-18 11:10, Brendan Hide wrote:
> Hi, all
> 
> I'm looking for some advice re compression with NVME. Compression helps 
> performance with a minor CPU hit - but is it still worth it with the far 
> higher throughputs offered by newer PCI and NVME-type SSDs?
> 
> I've ordered a PCIe-to-M.2 adapter along with a 1TB 960 Evo drive for my 
> home desktop. I previously used compression on an older SATA-based Intel 
> 520 SSD, where compression made sense.
> 
> However, the wisdom isn't so clear-cut if the SSD is potentially faster 
> than the compression algorithm with my CPU (aging i7 3770).
> 
> Testing using a copy of the kernel source tarball in tmpfs  it seems my 
> system can compress/decompress at about 670MB/s using zstd with 8 
> threads. lzop isn't that far behind. But I'm not sure if the benchmark 
> I'm running is the same as how btrfs would be using it internally.
BTRFS compresses chunks of 128k at a time and compresses each block one 
at a time (it doesn't do multi-threaded compression).  You can simulate 
this a bit better by splitting the files you're trying to compress into 
128k chunks (calling `split -b 131072` on the file will do this quickly 
and easily), and then passing all those chunks to the compression 
program _at the same time_ (this eliminates the overhead of re-invoking 
the compressor for each block), and then running it with one thread. 
For reference, the zstd compression in BTRFS uses level 3 by default (as 
does zlib compression IIRC), though I'm not sure about lzop (I think it 
uses the lowest compression setting).

Note that this will still not be entirely accurate (there are 
significant differences in buffer handling in the in-kernel 
implementations because of memory management differences).

Another option is to see how long it takes to copy the test data into a 
ZRAM device.  This will eliminate the storage overhead, and use the same 
compression algorithms that BTRFS does (the only big difference is that 
it compresses by page, so it will use 4k blocks instead of 128k).  zRAM 
currently doesn't support zstd (though patches have been posted), but it 
by default uses lzo, and it supports deflate as well (which is 
essentially the same mathematically as the 'zlib' compression method in 
BTRFS).
> 
> Given these numbers I'm inclined to believe compression will make things 
> slower - but can't be sure without knowing if I'm testing correctly.
On NVMe, yes, it's probably not worth it for speed.  It may however help 
in other ways.  Compressed writes are smaller than normal writes.  This 
means that rewriting a file that is compressed by the filesystem will 
result in fewer rewritten blocks of storage, which can be useful when 
dealing with flash memory.  Less written data also means you leave a bit 
more free space for the wear-leveling algorithms to work with, which can 
improve performance on some devices.
