Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16933 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbbBLE7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:59:15 -0500
Date: Thu, 12 Feb 2015 12:59:03 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: "P. Remek" <p.remek1@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs performance, sudden drop to 0 IOPs
Message-ID: <20150212045902.GD2416@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABdHLQ7QPjUbzqNdzCfR0QxC-0coYs0dofuFvsROYXy-M9u4ig@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 06:26:49PM +0100, P. Remek wrote:
> Hello,
> 
> I am benchmarking Btrfs and when benchmarking random writes with fio
> utility, I noticed following two things:
> 
> 1) On first run when target file doesn't exist yet, perfromance is
> about 8000 IOPs. On second, and every other run, performance goes up
> to 70000 IOPs. Its massive difference. The target file is the one
> created during the first run.

I was doing similar tests in the last few days, well, the huge performance difference comes from AIO+DIO path,

fs/direct-io.c: 1170
        /*
         * For file extending writes updating i_size before data
         * writeouts
         * complete can expose uninitialized blocks in dumb filesystems.
         * In that case we need to wait for I/O completion even if asked
         * for an asynchronous write.
         */
        if (is_sync_kiocb(iocb))
                dio->is_async = false;
        else if (!(dio->flags & DIO_ASYNC_EXTEND) &&
            (rw & WRITE) && end > i_size_read(inode))
                dio->is_async = false;
        else
                dio->is_async = true;

So you may like to play with fio's fallocate option, although it's 'posix' on default which should have set proper i_size for you, but I don't believe it unless I set it to.


> 
> 2) There are windows during the test where IOPs drop to 0 and stay 0
> about 10 seconds and then it goes back again, and after couple of
> seconds again to 0. This is reproducible 100% times.
> 
> Can somobody shred some light on what's happening?
> 

I'd use a blktrace based tool like iowatcher or seekwatcher to see
what's really happening on the performance drops.


> 
> Command: fio --randrepeat=1 --ioengine=libaio --direct=1
> --gtod_reduce=1 --name=test9 --filename=test9 --bs=4k --iodepth=256
> --size=10G --numjobs=1 --readwrite=randwrite

Since this is just a libaio-dio random write, I think it has nothing to do with
progs side.

Thanks,

-liubo
> 
> Environment:
> CPU: dual socket: E5-2630 v2
>    RAM: 32 GB ram
>    OS: Ubuntu server 14.10
>    Kernel: 3.19.0-031900rc2-generic
>    btrfs tools: Btrfs v3.14.1
>    2x LSI 9300 HBAs - SAS3 12/Gbs
>    8x SSD Ultrastar SSD1600MM 400GB SAS3 12/Gbs
> 
> Regards,
> Premek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
