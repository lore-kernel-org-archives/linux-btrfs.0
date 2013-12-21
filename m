Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56928 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab3LUONn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 21 Dec 2013 09:13:43 -0500
Message-ID: <52B5A20F.1050008@fb.com>
Date: Sat, 21 Dec 2013 09:13:35 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] Btrfs: rework qgroup accounting
References: <1387400849-7274-1-git-send-email-jbacik@fb.com> <1387400849-7274-3-git-send-email-jbacik@fb.com> <D8610409-5BF3-4150-A0DF-DC9985169540@gmail.com>
In-Reply-To: <D8610409-5BF3-4150-A0DF-DC9985169540@gmail.com>
Content-Type: text/plain; charset="GB2312"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/21/2013 03:01 AM, Wang Shilong wrote:
> Hi Josef,
>
> I compie btrfs-next in my 32-bit machine, i get the following warnings:
>
> fs/btrfs/qgroup.c: In function ¡®qgroup_excl_accounting¡¯:
> fs/btrfs/qgroup.c:1503:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    qgroup = (struct btrfs_qgroup *)unode->aux;
>             ^
> fs/btrfs/qgroup.c: In function ¡®qgroup_calc_old_refcnt¡¯:
> fs/btrfs/qgroup.c:1571:9: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>     qg = (struct btrfs_qgroup *)tmp_unode->aux;
>          ^
> fs/btrfs/qgroup.c: In function ¡®qgroup_account_deleted_refs¡¯:
> fs/btrfs/qgroup.c:1665:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    qg = (struct btrfs_qgroup *)unode->aux;
>         ^
> fs/btrfs/qgroup.c: In function ¡®qgroup_calc_new_refcnt¡¯:
> fs/btrfs/qgroup.c:1705:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    qg = (struct btrfs_qgroup *)unode->aux;
>         ^
> fs/btrfs/qgroup.c: In function ¡®qgroup_adjust_counters¡¯:
> fs/btrfs/qgroup.c:1767:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
>    qg = (struct btrfs_qgroup *)unode->aux;
>
> this patch is newly added into btrfs-next, so i think it is better that you fix these warnings locally .^_^

Crap I fixed part of these but not the other part, I'll fix it up and
push it out Monday. Thanks,

Josef
