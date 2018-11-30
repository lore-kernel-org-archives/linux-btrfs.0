Return-Path: <SRS0=Nx1q=OJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84913C64EB4
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 06:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3947F20863
	for <linux-btrfs@archiver.kernel.org>; Fri, 30 Nov 2018 06:00:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MUKfcAlq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3947F20863
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbeK3RIf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 30 Nov 2018 12:08:35 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53348 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbeK3RIf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Nov 2018 12:08:35 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAU609Pm184028;
        Fri, 30 Nov 2018 06:00:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : cc : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=oPwe3if1gAGQyM1Gp5StGTDJVqt1OSJwn9u1qSv+E4o=;
 b=MUKfcAlqszUZM20LsyOZVAYsS6wMhbSNc3bU/mi79009aURNhwIXuK2Vc1UClziY8rbZ
 zQ66mQ9jJmTUosITctHEkgU3s8G9HP585CENl8dxfv1vN7QAkZ8wLn7UfN+MHQgjSkx5
 /2buIrjc416iCSK5EQcPVMckUfNxEh9ryEBxFiPbn/kWR0CDSsAvHEtke7LlFY/aKwzu
 gTsAY7ZASKGMC/uZETNNkfrSkxtXddeOL3xkummdAWWJ9d+bwYAkjDQNS5Mgn8jrHpZF
 rsJgCuT2qJUcjAEqwMXN0A4fj0cr1f/qW+gt/x3ZWF3K7MlsiU5M1L36/wTFtYdZ53+1 Hg== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2p2jf0kbnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 06:00:17 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAU60GIk015761
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Nov 2018 06:00:16 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAU60E1g024734;
        Fri, 30 Nov 2018 06:00:14 GMT
Received: from [192.168.0.120] (/202.156.140.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Nov 2018 22:00:14 -0800
Subject: Re: invalid opcode in close_fs_devices
To:     dsterba@suse.com, josef@toxicpanda.com
References: <0000000000005852b8057bc8b123@google.com>
From:   Anand Jain <anand.jain@oracle.com>
Cc:     syzbot <syzbot+cabf977d00d3db1fdc37@syzkaller.appspotmail.com>,
        clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Message-ID: <5704d945-a862-fa2a-8447-138c242cd357@oracle.com>
Date:   Fri, 30 Nov 2018 13:59:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <0000000000005852b8057bc8b123@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9092 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811300050
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/29/2018 03:33 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    ef78e5ec9214 ia64: export node_distance function
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1514f733400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c94f9f0c0363db4b
> dashboard link: 
> https://syzkaller.appspot.com/bug?extid=cabf977d00d3db1fdc37
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+cabf977d00d3db1fdc37@syzkaller.appspotmail.com
> 
> invalid opcode: 0000 [#1] PREEMPT SMP KASAN
> CPU: 0 PID: 6312 Comm: syz-executor4 Not tainted 4.20.0-rc4+ #132
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
> Google 01/01/2011
> RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1039 [inline]


1037         new_device = btrfs_alloc_device(NULL, &device->devid,
1038                                         device->uuid);
1039         BUG_ON(IS_ERR(new_device)); /* -ENOMEM */


As part of close operations (lets say for unmount). We alloc a new
struct btrfs_device, copy few items and free the original struct
btrfs_device. This comes from the original design, this approach
has been bothering me and few others. We don't know for sure what
is the motivation to design like this, but I guess to satisfy the
RCUs.

To fix- one idea is to selectively reset the struct btrfs_device
members, avoid allocating a new btrfS_device and thus no need to
fail the unmount due to ENOMEM here.

-Anand


> RIP: 0010:close_fs_devices.part.44+0x7be/0xa20 fs/btrfs/volumes.c:1063
> Code: 48 8d 7b 30 49 89 44 24 18 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 
> 85 bd 01 00 00 48 83 6b 30 01 e9 7a fa ff ff e8 82 85 8c fe <0f> 0b e8 
> 7b 85 8c fe 0f 0b e8 74 85 8c fe 0f 0b e9 6f fd ff ff e8
> RSP: 0018:ffff8881b7b771d8 EFLAGS: 00010212
> RAX: 0000000000040000 RBX: ffff8881cdebb300 RCX: ffffc9000dea2000
> RDX: 0000000000022db4 RSI: ffffffff82f3057e RDI: 0000000000000007
> RBP: ffff8881b7b77380 R08: ffff8881b50d0000 R09: 0000000000000006
> R10: 0000000000000000 R11: ffff8881b50d0000 R12: ffff8881bad2b200
> R13: dffffc0000000000 R14: fffffffffffffff4 R15: 0000000000000000
> FS:  00007fc6d31a2700(0000) GS:ffff8881dae00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000400200 CR3: 00000001d3b95000 CR4: 00000000001406f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   close_fs_devices fs/btrfs/volumes.c:1095 [inline]
>   btrfs_close_devices+0xa1/0x210 fs/btrfs/volumes.c:1081
>   btrfs_mount_root+0x13d2/0x1d70 fs/btrfs/super.c:1619
>   mount_fs+0xae/0x31d fs/super.c:1261
>   vfs_kern_mount.part.35+0xdc/0x4f0 fs/namespace.c:961
>   vfs_kern_mount+0x40/0x60 fs/namespace.c:951
>   btrfs_mount+0x4a3/0x2136 fs/btrfs/super.c:1670
>   mount_fs+0xae/0x31d fs/super.c:1261
>   vfs_kern_mount.part.35+0xdc/0x4f0 fs/namespace.c:961
>   vfs_kern_mount fs/namespace.c:951 [inline]
>   do_new_mount fs/namespace.c:2469 [inline]
>   do_mount+0x581/0x31f0 fs/namespace.c:2801
>   ksys_mount+0x12d/0x140 fs/namespace.c:3017
>   __do_sys_mount fs/namespace.c:3031 [inline]
>   __se_sys_mount fs/namespace.c:3028 [inline]
>   __x64_sys_mount+0xbe/0x150 fs/namespace.c:3028
>   do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x459fda
> Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 7d 89 fb ff c3 66 2e 
> 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 
> f0 ff ff 0f 83 5a 89 fb ff c3 66 0f 1f 84 00 00 00 00 00
> RSP: 002b:00007fc6d31a1a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fc6d31a1b30 RCX: 0000000000459fda
> RDX: 00007fc6d31a1ad0 RSI: 0000000020000740 RDI: 00007fc6d31a1af0
> RBP: 0000000020000740 R08: 00007fc6d31a1b30 R09: 00007fc6d31a1ad0
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
> R13: 0000000000000000 R14: 00000000004d8ef0 R15: 0000000000000003
> Modules linked in:
> kobject: 'loop1' (0000000014e46057): kobject_uevent_env
> kobject: 'loop1' (0000000014e46057): fill_kobj_path: path = 
> '/devices/virtual/block/loop1'
> kobject: 'loop1' (0000000014e46057): kobject_uevent_env
> kobject: 'loop1' (0000000014e46057): fill_kobj_path: path = 
> '/devices/virtual/block/loop1'
> kobject: 'loop1' (0000000014e46057): kobject_uevent_env
> kobject: 'loop1' (0000000014e46057): fill_kobj_path: path = 
> '/devices/virtual/block/loop1'
> kobject: 'loop1' (0000000014e46057): kobject_uevent_env
> kobject: 'loop1' (0000000014e46057): fill_kobj_path: path = 
> '/devices/virtual/block/loop1'
> ---[ end trace 260d74aed8afc1e0 ]---
> RIP: 0010:btrfs_close_one_device fs/btrfs/volumes.c:1039 [inline]
> RIP: 0010:close_fs_devices.part.44+0x7be/0xa20 fs/btrfs/volumes.c:1063
> Code: 48 8d 7b 30 49 89 44 24 18 48 89 f8 48 c1 e8 03 42 80 3c 28 00 0f 
> 85 bd 01 00 00 48 83 6b 30 01 e9 7a fa ff ff e8 82 85 8c fe <0f> 0b e8 
> 7b 85 8c fe 0f 0b e8 74 85 8c fe 0f 0b e9 6f fd ff ff e8
> RSP: 0018:ffff8881b7b771d8 EFLAGS: 00010212
> RAX: 0000000000040000 RBX: ffff8881cdebb300 RCX: ffffc9000dea2000
> RDX: 0000000000022db4 RSI: ffffffff82f3057e RDI: 0000000000000007
> RBP: ffff8881b7b77380 R08: ffff8881b50d0000 R09: 0000000000000006
> R10: 0000000000000000 R11: ffff8881b50d0000 R12: ffff8881bad2b200
> R13: dffffc0000000000 R14: fffffffffffffff4 R15: 0000000000000000
> FS:  00007fc6d31a2700(0000) GS:ffff8881daf00000(0000) 
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000004dc418 CR3: 00000001d3b95000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with 
> syzbot.
