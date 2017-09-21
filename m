Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45583 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdIUPaM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 11:30:12 -0400
Date: Thu, 21 Sep 2017 08:26:25 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: using fio to test btrfs compression
Message-ID: <20170921152624.GA23021@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 18, 2017 at 01:06:45PM +0530, shally verma wrote:
> Hi
> 
> I wanted to test btrfs compression using fio command but somehow
> during fio writes, I don't see code taking route of compression blocks
> where as If I do a copy to btrfs compression enabled mount point then
> I can easily see code falling through compression.c.
> 
> Here's how I do my setup
> 
> 1. mkfs.btrfs /dev/sdb1
> 2. mount -t btrfs -o compress=zlib,compress-force /dev/sdb1 /mnt
> 3. cp <some large test file> /mnt
> 4. dmesg shows print staments from compression.c and zlib.c confirming
> compression routine was invoked during write
> 5. now, copy back from btrfs mount point to home directory also shows
> decompress call invokation
> 
> Now, try same with fio commands:
> 
> fio command
> 
> fio --directory=/mnt/ --numjobs=1 --direct=0 --buffered=1
> --ioengine=libaio --group_reporting --bs=64k --rw=write --iodepth=128
> --name=test --size=10G --runtime=180 --time_based

fio by default uses fallocate (posix_falloc) to pre-allocate space for
the later writes, and PREALLOC path overrides compression path.

Like others mentioned, after fio and sync, you'll see 'encoded' in
filefrag -v your_file.

thanks,
-liubo

> 
> But it seems to write uncompressed data.
> 
> Any help here? what's missing?
> 
> Thanks
> Shally
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
