Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34841 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbCQJfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 05:35:30 -0400
Received: by pabyw6 with SMTP id yw6so4789321pab.2
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Mar 2015 02:35:30 -0700 (PDT)
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2070.6\))
Subject: Re: Btrfs Send/Receive "WARN_ON Cannot allocate memory" And "no such file or directory" error
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAJiZgcoWzBtqNQo54GCAw=WH1BtMm2wdScJeTjyJWeypeep=Bw@mail.gmail.com>
Date: Tue, 17 Mar 2015 17:34:14 +0800
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <BD452F14-7041-43B3-B6AA-3DE83A86D3B1@gmail.com>
References: <CAJiZgcoWzBtqNQo54GCAw=WH1BtMm2wdScJeTjyJWeypeep=Bw@mail.gmail.com>
To: Robbie Ko <robbieko@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> 
> Hi,
> 
> I have been testing btrfs send/receive recently.
> I got an error "send ioctl failed with -12: Cannot allocate memory" on
> send side.
> WARN_ON happened on "len > PATH_MAX" in fs_path_ensure_buf.
> 
> I got an error "rename failed: no such file or directory" on receive side.
> The followings are simple reproduced steps and related information,
> Is there any  idea about what this might be or how to fix it?
> 
> uanme -a
> Linux ubuntu 4.0.0-rc1-custom #2 SMP Fri Feb 27 22:20:12 CST 2015
> x86_64 x86_64 x86_64 GNU/Linux
> btrfs --version
> Btrfs v3.14.1

I don¡¯t know exact commit that fix this problem.
But there are some bug fixes since v3.14.

Could you try latest kernel and see if problem still exist?
 
> 
> Steps to reproduce:
> 
>  $ mkfs.btrfs -f /dev/sdb
>  $ mount /dev/sdb /mnt
>  $ mkfs.btrfs -f /dev/sdc
>  $ mount /dev/sdc /mnt2
> 
> $ mkdir /mnt/data
> $ mkdir /mnt/data/n1
> $ mkdir /mnt/data/n1/n2
> $ mkdir /mnt/data/n4
> $ mkdir /mnt/data/n1/n2/p1
> $ mkdir /mnt/data/n1/n2/p1/p2
> $ mkdir /mnt/data/t6
> $ mkdir /mnt/data/t7
> $ mkdir -p /mnt/data/t5/t7
> $ mkdir /mnt/data/t2
> $ mkdir /mnt/data/t4
> $ mkdir -p /mnt/data/t1/t3
> $ mkdir /mnt/data/p1
> $ mv /mnt/data/t1 /mnt/data/p1
> $ mkdir -p /mnt/data/p1/p2
> $ mv /mnt/data/t4 /mnt/data/p1/p2/t1
> $ mv /mnt/data/t5 /mnt/data/n4/t5
> $ mv /mnt/data/n1/n2/p1/p2 /mnt/data/n4/t5/p2
> $ mv /mnt/data/t7 /mnt/data/n4/t5/p2/t7
> $ mv /mnt/data/t2 /mnt/data/n4/t1
> $ mv /mnt/data/p1 /mnt/data/n4/t5/p2/p1
> $ mv /mnt/data/n1/n2 /mnt/data/n4/t5/p2/p1/p2/n2
> $ mv /mnt/data/n4/t5/p2/p1/p2/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1
> $ mv /mnt/data/n4/t5/t7 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7
> $ mv /mnt/data/n4/t5/p2/p1/t1/t3 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3
> $ mv /mnt/data/n4/t5/p2/p1/p2/n2/p1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1
> $ mv /mnt/data/t6 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t5
> $ mv /mnt/data/n4/t5/p2/p1/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t3/t1
> $ mv /mnt/data/n1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/n1
> 
>  $ btrfs subvolume snapshot -r /mnt /mnt/snap1
> 
> $ mv /mnt/data/n4/t1 /mnt/data/n4/t5/p2/p1/p2/n2/t1/t7/p1/t1
> $ mv /mnt/data/n4/t5/p2/p1/p2/n2/t1 /mnt/data/n4/
> $ mv /mnt/data/n4/t5/p2/p1/p2/n2 /mnt/data/n4/t1/n2
> $ mv /mnt/data/n4/t1/t7/p1 /mnt/data/n4/t1/n2/p1
> $ mv /mnt/data/n4/t1/t3/t1 /mnt/data/n4/t1/n2/t1
> $ mv /mnt/data/n4/t1/t3 /mnt/data/n4/t1/n2/t1/t3
> $ mv /mnt/data/n4/t5/p2/p1/p2 /mnt/data/n4/t1/n2/p1/p2
> $ mv /mnt/data/n4/t1/t7 /mnt/data/n4/t1/n2/p1/t7
> $ mv /mnt/data/n4/t5/p2/p1 /mnt/data/n4/t1/n2/p1/p2/p1
> $ mv /mnt/data/n4/t1/n2/t1/t3/t5 /mnt/data/n4/t1/n2/p1/p2/t5
> $ mv /mnt/data/n4/t5 /mnt/data/n4/t1/n2/p1/p2/p1/t5
> $ mv /mnt/data/n4/t1/n2/p1/p2/p1/t5/p2 /mnt/data/n4/t1/n2/p1/p2/p1/p2
> $ mv /mnt/data/n4/t1/n2/p1/p2/p1/p2/t7 /mnt/data/n4/t1/t7
> 
>  $ btrfs subvolume snapshot -r /mnt /mnt/snap2
> 
>  $ btrfs send /mnt/snap1 | btrfs receive /mnt2
>  $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive -vv /mnt2
> ERROR: send ioctl failed with -12: Cannot allocate memory
> rename data/n4/t5/p2/p1/p2 -> o272-10-0
> rename data/n4/t5/p2/p1/p2/n2/t1/t7 -> o266-9-0
> ERROR: rename data/n4/t5/p2/p1/p2/n2/t1/t7 -> o266-9-0 failed. No such
> file or directory
> 
> It seems that "data/n4/t5/p2/p1/p2" had been renamed but the file path
> had not been updated to
> "o272-10-0".
> Thus it makes the next rename failed.
> 
> Thanks.
> robbieko
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

