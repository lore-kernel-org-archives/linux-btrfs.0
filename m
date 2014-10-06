Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33523 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbaJFC3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Oct 2014 22:29:14 -0400
Message-ID: <5431FEA1.20803@cn.fujitsu.com>
Date: Mon, 6 Oct 2014 10:29:53 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Niklas Fischer <niklas@niklasfi.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check segfaults after flipping 2 Bytes
References: <542C6443.1010809@niklasfi.de>
In-Reply-To: <542C6443.1010809@niklasfi.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: btrfs check segfaults after flipping 2 Bytes
From: Niklas Fischer <niklas@niklasfi.de>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年10月02日 04:29
> Hello,
>
> I was trying to determine how btrfs reacts to disk errors, when I
> discovered, that flipping two Bytes, supposedly inside of a file can
> render the filesystem unusable. Here is what I did:
>
> 1. dd if=/dev/zero of=/dev/sdg2 bs=1M
> 2. mkfs.btrfs /dev/sdg2
> 3. mount /dev/sdg2 /tmp/btrfs
> 4. echo "hello world this is some text" > /tmp/btrfs/hello
> 5. umount /dev/sdg2
>
> this should result in this image [1]
>
> in the following steps /dev/sdg2 is altered. Basically, we want to apply
> s/world/wirld/g
>
> 6. dd if=/dev/sdg2 of=/tmp/sdg2 bs=1M
> 7. edit /tmp/sdg2 in ghex, find & replace all occurences of "world" with
> "wirld" (two occurences found), save as /tmp/sdg2_new
2 problems here.

[1] csum mismatch
As already mentioned by Ducan and Brendan, the csum does not match.

What makes thing much worse, since small file's extent is inlined, the 
data is stored in metadata tree blocks,
and the file system is almost empty so the inline extent lies in the 
*root* leaf of fs_tree.
These two unfortunate facts makes the whole fs_tree corrupted(only one 
leaf, and its cusm dismatch),
which cause btrfs-progs segfault.

The good news is that, the bug in btrfs-progs is already fixed by Wang's 
patch:
https://patchwork.kernel.org/patch/4254631/
So at least, btrfs-progs will not segfault anymore.

[2] two occurences?
So you definitely changed something you should not touch... maybe 
another tree root?

Anyway, almost everything in btrfs is csums, so any manual modification 
may cause problem.

> 8. dd if=/tmp/sdg2_new of=/dev/sdg2 bs=1M
>
> /dev/sdg2 now looks like this [2]
>
> now, when I try mounting /dev/sdg2:
>
> """22:21 root@localhost ~#
> LANG=EN mount /dev/sdg2 /tmp/btrfs/
> mount: mount /dev/sdg2 on /tmp/btrfs failed: Cannot allocate memory"""
>
> ok, so let us try btrfs check
>
> """22:21 root@localhost ~#
> LANG=EN btrfs check /dev/sdg2
> checksum verify failed on 4222976 found F22E71BD wanted CE334502
> checksum verify failed on 4222976 found F22E71BD wanted CE334502
> Csum didn't match
> Checking filesystem on /dev/sdg2
> UUID: ea2843f1-e8aa-420f-acf8-6ef13f6c6753
> checking extents
> Speicherzugriffsfehler (Speicherabzug geschrieben)"""
>
> that last line reads "Segfault, memory dumped". Is this behaviour expected?
>
> Kind regards,
> Niklas
>
> [1] tgz: https://gigamove.rz.rwth-aachen.de/d/id/R5CKikxbYTBdqs
>      raw: https://gigamove.rz.rwth-aachen.de/d/id/VgMXAicS7CGEjt
> [2] tgz: https://gigamove.rz.rwth-aachen.de/d/id/cEebNYne9ppFy4
>      raw: https://gigamove.rz.rwth-aachen.de/d/id/ATJa7wpfEWdfL2
BTW, [2]'s tgz is in fact raw, and raw is tgz....

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

