Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:61039 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033966AbdDTUkj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Apr 2017 16:40:39 -0400
Received: from [192.168.8.100] ([80.187.100.203]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MhiTL-1cfdOo10M7-00MwDd for
 <linux-btrfs@vger.kernel.org>; Thu, 20 Apr 2017 22:40:37 +0200
Date: Thu, 20 Apr 2017 22:40:29 +0200
In-Reply-To: <trinity-726bddc0-9890-43bb-97d9-65ba9d426e17-1492544073645@3capp-gmx-bs21>
References: <trinity-726bddc0-9890-43bb-97d9-65ba9d426e17-1492544073645@3capp-gmx-bs21>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: btrfs check bug
To: linux-btrfs@vger.kernel.org
From: =?ISO-8859-1?Q?Jan_K=F6ster?= <jan.koester@gmx.net>
Message-ID: <70779CFA-5593-4FE2-AC14-00AF3507BE0B@gmx.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

An other Information needed ? 

Am 18. April 2017 21:34:33 MESZ schrieb Jan Koester <jan.koester@gmx.net>:
>
>Hi,
>
>i have to try to create a new extent-tree after checksum error not
>solveable with srub or init-csum-tree.
>Now i got this failure output from btrfs --repair:
> 
>ERROR: errors found in extent allocation tree or chunk allocation
>Fixed 0 roots.
>checking free space cache
>checking fs roots
>root 5 missing its root dir, recreating
>btrfs unable to find ref byte nr 2279425310720 parent 0 root 5  owner 3
>offset 0
>btrfs unable to find ref byte nr 2279422181376 parent 0 root 5  owner 2
>offset 1
>btrfs unable to find ref byte nr 2279422672896 parent 0 root 5  owner 1
>offset 1
>btrfs unable to find ref byte nr 2279413121024 parent 0 root 5  owner 0
>offset 1
>cmds-check.c:3370: check_inode_recs: BUG_ON `ret` triggered, value -17
>btrfs(+0x50788)[0x5565c775b788]
>btrfs(+0x507db)[0x5565c775b7db]
>btrfs(+0x598e6)[0x5565c77648e6]
>btrfs(cmd_check+0x2bd4)[0x5565c7770185]
>btrfs(main+0x8b)[0x5565c771c0f5]
>/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f76045232b1]
>btrfs(_start+0x2a)[0x5565c771bd7a]
>enabling repair mode
>Checking filesystem on /dev/disk/by-label/home
>UUID: 74454fdd-035b-4a3d-98ec-e38d3e7bcd6b
>cache and super generation don't match, space cache will be invalidated
>Failed to find [2278878576640, 168, 16384]
>Failed to find [2278878593024, 168, 16384]
>Failed to find [2278878609408, 168, 16384]
>Failed to find [2278878625792, 168, 16384]
>--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
