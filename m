Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7764 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab3LUOOy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 09:14:54 -0500
Message-ID: <52B5A259.1020805@fb.com>
Date: Sat, 21 Dec 2013 09:14:49 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: rework qgroup accounting
References: <1387400849-7274-1-git-send-email-jbacik@fb.com> <1387400849-7274-3-git-send-email-jbacik@fb.com> <A4C427B3-2FE2-4032-A085-77117A678B0F@gmail.com>
In-Reply-To: <A4C427B3-2FE2-4032-A085-77117A678B0F@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/21/2013 03:56 AM, Wang Shilong wrote:
> Hello Josef,
>
> Though i know there are still problems related to qgroup(for example removing snapshot
> will beak qgroup accounting).I did a simple test about your patch..
>
>
> # btrfs quota enable /mnt
> # dd if=/dev/zero of=/mnt/data bs=4k count=102400 oflag=direct
> # btrfs sub snapshot /mnt/ /mnt/snap1
> # btrfs sub snapshot /mnt /mnt/snap2
> # btrfs sub delete /mnt/snap1 /mnt/snap2
> # sync
> # rm -rf /mnt/data
> # sync
> # dmesg
> # btrfs qgroup show /mnt
>
>
> Firstly, qgroup accounting is wrong, this is maybe expected because efficient  fs tree removal.
> However, from dmesg, i get the  WARNING:
>
> WARNING: CPU: 1 PID: 2650 at fs/btrfs/qgroup.c:1486 btrfs_delayed_qgroup_accounting
>
> I did not take a deep look at codes, but i think you will be interested in taking a look at this. ^_^

Yup we shouldn't be warning, but I didn't change anything wrt quotas and 
snapshot deletion, that's a whole other issue I don't care about right 
now ;).  Thanks,

Josef
