Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:60258
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754186AbdEIRQ2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 9 May 2017 13:16:28 -0400
Received: from mail-ua0-f182.google.com ([209.85.217.182]:36297)
        by p3plcpnl0639.prod.phx3.secureserver.net with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.88)
        (envelope-from <lakshmipathi.g@giis.co.in>)
        id 1d88jP-0003z7-6a
        for linux-btrfs@vger.kernel.org; Tue, 09 May 2017 10:15:27 -0700
Received: by mail-ua0-f182.google.com with SMTP id j17so7509511uag.3
        for <linux-btrfs@vger.kernel.org>; Tue, 09 May 2017 10:15:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170509154120.GG5491@suse.cz>
References: <20170427100534.GA10404@giis.co.in> <20170502150601.GK23260@twin.jikos.cz>
 <20170502153556.GM23260@twin.jikos.cz> <20170503163819.GA10030@giis.co.in>
 <CAKuJGC8SndPLuVDVtJZLEzYg-Vfh0U1Y-wF4pr093yTnjJfkXg@mail.gmail.com> <20170509154120.GG5491@suse.cz>
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Date: Tue, 9 May 2017 22:45:26 +0530
Message-ID: <CAKuJGC-JLgm6_A5UEQkjPzcLgB22+_MN8mROTEicotE+yqCAJA@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
To: dsterba@suse.cz, "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>,
        quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Does the mke2fs command exist on your system? We maybe want to use
> mkfs.ext4 directly.

Yes, mke2fs is there. (I'll check using mkfs.ext4 directly)

# ./convert-tests/009-common-inode-flags/test.sh
    [TEST/conv]     common inode flags test, btrfs defaults
failed: mke2fs -t ext4 -b 4096 -F
/home/laks/centos/laks/BTRFS/btrfs-progs/tests/test.img

After failure, I can run failed command manually.
# mke2fs -t ext4 -b 4096 -F
/home/laks/centos/laks/BTRFS/btrfs-progs/tests/test.imgmke2fs 1.42.13
(17-May-2015)
Discarding device blocks: done
Creating filesystem with 131072 4k blocks and 32768 inodes
Filesystem UUID: 659dbb16-ea5e-48e0-8b1a-30474f54c282
Superblock backups stored on blocks:
	32768, 98304

Allocating group tables: done
Writing inode tables: done
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done

-- 
----
Cheers,
Lakshmipathi.G
