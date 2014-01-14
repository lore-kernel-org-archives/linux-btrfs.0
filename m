Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59428 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaANXVT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jan 2014 18:21:19 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so301938pde.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jan 2014 15:21:18 -0800 (PST)
Received: from mitchelh-linux.qualcomm.com (i-global252.qualcomm.com. [199.106.103.252])
        by mx.google.com with ESMTPSA id bz4sm3681573pbb.12.2014.01.14.15.21.16
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jan 2014 15:21:17 -0800 (PST)
From: Mitchel Humpherys <mitch.special@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Hitting error after failed balance
References: <vnkwfvoq73cp.fsf@mitchelh-linux.qualcomm.com>
Date: Tue, 14 Jan 2014 15:21:19 -0800
In-Reply-To: <vnkwfvoq73cp.fsf@mitchelh-linux.qualcomm.com> (Mitchel
	Humpherys's message of "Tue, 14 Jan 2014 11:47:18 -0800")
Message-ID: <vnkwvbxm9mkw.fsf@mitchelh-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 14 2014 at 11:47:18 AM, Mitchel Humpherys <mitch.special@gmail.com> wrote:
>
> Other possibly relevant information:
>
>     $ sudo btrfs filesystem show /local
>     Label: none  uuid: 03a83a42-0bc7-42a2-bed6-df19c825897c
>             Total devices 2 FS bytes used 380.83GiB
>             devid    1 size 410.18GiB used 164.03GiB path /dev/sda6
>             devid    2 size 465.76GiB used 220.00GiB path /dev/sdc
>     
>     Btrfs v3.12
>
>     $ uname -a
>     Linux mitchelh-linux 3.12.6-1-ARCH #1 SMP PREEMPT Fri Dec 20 19:39:00 CET 2013 x86_64 GNU/Linux
>

Well I tried btrfsck --repair and now it appears to be unmountable...

    $ sudo btrfsck --repair /dev/sda6
    enabling repair mode
    Checking filesystem on /dev/sda6
    UUID: 03a83a42-0bc7-42a2-bed6-df19c825897c
    checking extents
    Backref 122643533824 parent 5 root 5 not found in extent tree
    Backref 122643533824 parent 123939635200 not referenced back 0x55ef990
    Incorrect global backref count on 122643533824 found 2 wanted 1
    backpointer mismatch on [122643533824 4096]
    ...
    Incorrect global backref count on 846095245312 found 1 wanted 0
    backpointer mismatch on [846095245312 4096]
    Backref 846103539712 parent 2 root 2 not found in extent tree
    Backref 846103539712 root 2 not referenced back 0x15d4460
    Incorrect global backref count on 846103539712 found 1 wanted 0
    backpointer mismatch on [846103539712 4096]
    repaired damaged extent references
    checking free space cache
    cache and super generation don't match, space cache will be invalidated
    checking fs roots
    root 256 inode 257 errors 800, odd csum item
    found 43901995420 bytes used err is 1
    total csum bytes: 363657120
    total tree bytes: 9200095232
    total fs tree bytes: 8303808512
    total extent tree bytes: 473149440
    btree space waste bytes: 2280314010
    file data blocks allocated: 864793686016
     referenced 757795065856
    Btrfs v3.12


    $ sudo mount -a
    mount: wrong fs type, bad option, bad superblock on /dev/sda6,
           missing codepage or helper program, or other error

           In some cases useful info is found in syslog - try
           dmesg | tail or so.

fstab entry:

    /dev/sda6           	/local    	btrfs      	skip_balance	0 0


and here's the kernel log from the mount -a:

    [13462.391937] btrfs: device fsid 03a83a42-0bc7-42a2-bed6-df19c825897c devid 2 transid 95625 /dev/sdc
    [13462.532136] btrfs: device fsid 03a83a42-0bc7-42a2-bed6-df19c825897c devid 1 transid 95625 /dev/sda6
    [13479.393750] btrfs: device fsid 03a83a42-0bc7-42a2-bed6-df19c825897c devid 1 transid 95625 /dev/sda6
    [13479.394386] btrfs: disk space caching is enabled
    [13479.995184] parent transid verify failed on 625292959744 wanted 95626 found 95625
    [13479.995191] btrfs: failed to read log tree
    [13480.051334] btrfs: open_ctree failed

> wanted 95626 found 95625

So close! :)

Am I completely hosed?

-- 
Mitch
