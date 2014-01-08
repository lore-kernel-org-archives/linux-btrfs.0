Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23762 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbaAHTlX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 14:41:23 -0500
From: Chris Mason <clm@fb.com>
To: "muthu.lkml@gmail.com" <muthu.lkml@gmail.com>
CC: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Date: Wed, 8 Jan 2014 19:41:14 +0000
Message-ID: <1389210102.23310.31.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	 <20140106221036.GE9037@kmo>
	 <CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	 <20140107055318.GA19016@localhost>
	 <CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	 <1389126617.23310.19.camel@ret.masoncoding.com>
	 <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
In-Reply-To: <CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
Content-Type: text/plain; charset="utf-7"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2014-01-07 at 13:23 -0800, Muthu Kumar wrote:
+AD4- Chris,
+AD4- This is based off of Jens block tree, for-3.14/core branch...
+AD4- 

Ok, Kent did pull in one of my hunks, one was a comment and the third
was effectively the same as your patch.  I tried to test the end result
today, but get these on boot with ext4:

+AFs-    8.336061+AF0- WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio+AF8-endio+-0xbe/0x100()
+AFs-    8.336062+AF0- bio+AF8-endio: bio for (unknown) without endio
+AFs-    8.336063+AF0- Modules linked in: megaraid+AF8-sas(+-)
+AFs-    8.336065+AF0- CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc7-mason+- +ACM-1
+AFs-    8.336066+AF0- Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
+AFs-    8.336069+AF0-  00000000000006f2 ffff88087fc03c28 ffffffff815cb8c6 00000000000006f2
+AFs-    8.336071+AF0-  ffff88087fc03c78 ffff88087fc03c68 ffffffff81047497 ffff88085561a8e8
+AFs-    8.336073+AF0-  ffff8808582b6d80 00000000000000fe 00000000fffffffb ffff8808582b6d80
+AFs-    8.336073+AF0- Call Trace:
+AFs-    8.336078+AF0-  +ADw-IRQ+AD4-  +AFsAPA-ffffffff815cb8c6+AD4AXQ- dump+AF8-stack+-0x49/0x5b
+AFs-    8.336082+AF0-  +AFsAPA-ffffffff81047497+AD4AXQ- warn+AF8-slowpath+AF8-common+-0x87/0xb0
+AFs-    8.336084+AF0-  +AFsAPA-ffffffff81047561+AD4AXQ- warn+AF8-slowpath+AF8-fmt+-0x41/0x50
+AFs-    8.336086+AF0-  +AFsAPA-ffffffff813aa6b8+AD4AXQ- ? scsi+AF8-request+AF8-fn+-0xc8/0x6a0
+AFs-    8.336087+AF0-  +AFsAPA-ffffffff8119bc8e+AD4AXQ- bio+AF8-endio+-0xbe/0x100
+AFs-    8.336091+AF0-  +AFsAPA-ffffffff8128c1d3+AD4AXQ- blk+AF8-update+AF8-request+-0x243/0x3a0
+AFs-    8.336092+AF0-  +AFsAPA-ffffffff8128c352+AD4AXQ- blk+AF8-update+AF8-bidi+AF8-request+-0x22/0xa0
+AFs-    8.336094+AF0-  +AFsAPA-ffffffff8128ceca+AD4AXQ- blk+AF8-end+AF8-bidi+AF8-request+-0x2a/0x80
+AFs-    8.336096+AF0-  +AFsAPA-ffffffff8128cf5b+AD4AXQ- blk+AF8-end+AF8-request+-0xb/0x10
+AFs-    8.336098+AF0-  +AFsAPA-ffffffff813ab916+AD4AXQ- scsi+AF8-io+AF8-completion+-0xa6/0x700
+AFs-    8.336100+AF0-  +AFsAPA-ffffffff813a2b68+AD4AXQ- scsi+AF8-finish+AF8-command+-0xc8/0x130
+AFs-    8.336101+AF0-  +AFsAPA-ffffffff813ac0bf+AD4AXQ- scsi+AF8-softirq+AF8-done+-0x13f/0x160
+AFs-    8.336104+AF0-  +AFsAPA-ffffffff812937ad+AD4AXQ- blk+AF8-done+AF8-softirq+-0x6d/0x80
+AFs-    8.336106+AF0-  +AFsAPA-ffffffff8104c26b+AD4AXQ- +AF8AXw-do+AF8-softirq+-0xdb/0x290
+AFs-    8.336108+AF0-  +AFsAPA-ffffffff8104c51d+AD4AXQ- irq+AF8-exit+-0xbd/0xd0
+AFs-    8.336110+AF0-  +AFsAPA-ffffffff81003db1+AD4AXQ- do+AF8-IRQ+-0x61/0xe0
+AFs-    8.336112+AF0-  +AFsAPA-ffffffff815d012a+AD4AXQ- common+AF8-interrupt+-0x6a/0x6a
+AFs-    8.336117+AF0-  +ADw-EOI+AD4-  +AFsAPA-ffffffff814e213a+AD4AXQ- ? cpuidle+AF8-enter+AF8-state+-0x4a/0xc0
+AFs-    8.336119+AF0-  +AFsAPA-ffffffff814e2136+AD4AXQ- ? cpuidle+AF8-enter+AF8-state+-0x46/0xc0
+AFs-    8.336121+AF0-  +AFsAPA-ffffffff814e2277+AD4AXQ- cpuidle+AF8-idle+AF8-call+-0xc7/0x160
+AFs-    8.336123+AF0-  +AFsAPA-ffffffff8100b2c9+AD4AXQ- arch+AF8-cpu+AF8-idle+-0x9/0x20
+AFs-    8.336126+AF0-  +AFsAPA-ffffffff8108fd8a+AD4AXQ- cpu+AF8-startup+AF8-entry+-0x9a/0x250
+AFs-    8.336128+AF0-  +AFsAPA-ffffffff815c3702+AD4AXQ- rest+AF8-init+-0x72/0x80
+AFs-    8.336131+AF0-  +AFsAPA-ffffffff81ac2047+AD4AXQ- start+AF8-kernel+-0x3fd/0x40a
+AFs-    8.336133+AF0-  +AFsAPA-ffffffff81ac1a78+AD4AXQ- ? repair+AF8-env+AF8-string+-0x5b/0x5b
+AFs-    8.336134+AF0-  +AFsAPA-ffffffff81ac159d+AD4AXQ- x86+AF8-64+AF8-start+AF8-reservations+-0x2a/0x2c
+AFs-    8.336136+AF0-  +AFsAPA-ffffffff81ac16df+AD4AXQ- x86+AF8-64+AF8-start+AF8-kernel+-0x140/0x147
+AFs-    8.336137+AF0- ---+AFs- end trace d0966e2430ea53b4 +AF0----
+AFs-    8.336146+AF0- ------------+AFs- cut here +AF0-------------
+AFs-    8.336146+AF0- kernel BUG at fs/bio.c:523+ACE-
+AFs-    8.336148+AF0- invalid opcode: 0000 +AFsAIw-1+AF0- SMP
+AFs-    8.336148+AF0- Modules linked in: megaraid+AF8-sas(+-)
+AFs-    8.336150+AF0- CPU: 0 PID: 2911 Comm: scsi+AF8-id Tainted: G        W    3.13.0-rc7-mason+- +ACM-1
+AFs-    8.336150+AF0- Hardware name: ZTSYSTEMS Echo Ridge T4  /A9DRPF-10D, BIOS 1.07 05/10/2012
+AFs-    8.336151+AF0- task: ffff8808556b4150 ti: ffff8808556b6000 task.ti: ffff8808556b6000
+AFs-    8.336153+AF0- RIP: 0010:+AFsAPA-ffffffff8119bbba+AD4AXQ-  +AFsAPA-ffffffff8119bbba+AD4AXQ- bio+AF8-put+-0x8a/0xa0
+AFs-    8.336153+AF0- RSP: 0018:ffff8808556b7b68  EFLAGS: 00010246
+AFs-    8.336154+AF0- RAX: 0000000000000000 RBX: ffff8808582b6d80 RCX: 0000000000000000
+AFs-    8.336155+AF0- RDX: ffff8808582b6dec RSI: 0000000000000003 RDI: ffff8808582b6d80
+AFs-    8.336155+AF0- RBP: ffff8808556b7b78 R08: 0000000000000004 R09: 0000000000000000
+AFs-    8.336156+AF0- R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
+AFs-    8.336156+AF0- R13: 0000000000000000 R14: ffff8808567ebe28 R15: ffff8808582b6d80
+AFs-    8.336157+AF0- FS:  00007f16056bd700(0000) GS:ffff88087fc00000(0000) knlGS:0000000000000000
+AFs-    8.336158+AF0- CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
+AFs-    8.336159+AF0- CR2: ffffe8f7ffc00000 CR3: 0000000856303000 CR4: 00000000000407f0
+AFs-    8.336159+AF0- Stack:
+AFs-    8.336164+AF0-  ffff8808582b6d80 0000000000000000 ffff8808556b7ba8 ffffffff81291b37
+AFs-    8.336168+AF0-  ffff8808556b7b88 ffff8808556b7cf8 ffff88085561a8e8 ffff880855685400
+AFs-    8.336172+AF0-  ffff8808556b7c78 ffffffff8129b42d ffff8808556b7be8 ffffffff8119e09b
+AFs-    8.336172+AF0- Call Trace:
+AFs-    8.336174+AF0-  +AFsAPA-ffffffff81291b37+AD4AXQ- blk+AF8-rq+AF8-unmap+AF8-user+-0x47/0x60
+AFs-    8.336177+AF0-  +AFsAPA-ffffffff8129b42d+AD4AXQ- sg+AF8-io+-0x26d/0x370
+AFs-    8.336179+AF0-  +AFsAPA-ffffffff8119e09b+AD4AXQ- ? bdget+-0x11b/0x130
+AFs-    8.336183+AF0-  +AFsAPA-ffffffff811068c9+AD4AXQ- ? find+AF8-get+AF8-page+-0x19/0xa0
+AFs-    8.336185+AF0-  +AFsAPA-ffffffff8129bc79+AD4AXQ- scsi+AF8-cmd+AF8-ioctl+-0x409/0x480
+AFs-    8.336186+AF0-  +AFsAPA-ffffffff81106af2+AD4AXQ- ? unlock+AF8-page+-0x22/0x30
+AFs-    8.336189+AF0-  +AFsAPA-ffffffff81130949+AD4AXQ- ? +AF8AXw-do+AF8-fault+-0x439/0x560
+AFs-    8.336191+AF0-  +AFsAPA-ffffffff8129bd3c+AD4AXQ- scsi+AF8-cmd+AF8-blk+AF8-ioctl+-0x4c/0x70
+AFs-    8.336194+AF0-  +AFsAPA-ffffffff81437d6f+AD4AXQ- sd+AF8-ioctl+-0xcf/0x160
+AFs-    8.336196+AF0-  +AFsAPA-ffffffff81298003+AD4AXQ- +AF8AXw-blkdev+AF8-driver+AF8-ioctl+-0x23/0x30
+AFs-    8.336198+AF0-  +AFsAPA-ffffffff81298638+AD4AXQ- blkdev+AF8-ioctl+-0x1f8/0x790
+AFs-    8.336199+AF0-  +AFsAPA-ffffffff8119d717+AD4AXQ- block+AF8-ioctl+-0x37/0x40
+AFs-    8.336201+AF0-  +AFsAPA-ffffffff811790c7+AD4AXQ- do+AF8-vfs+AF8-ioctl+-0x87/0x4f0
+AFs-    8.336204+AF0-  +AFsAPA-ffffffff8126374a+AD4AXQ- ? file+AF8-has+AF8-perm+-0x8a/0xa0
+AFs-    8.336205+AF0-  +AFsAPA-ffffffff811795c1+AD4AXQ- SyS+AF8-ioctl+-0x91/0xa0
+AFs-    8.336207+AF0-  +AFsAPA-ffffffff815d77e2+AD4AXQ- system+AF8-call+AF8-fastpath+-0x16/0x1b
+AFs-    8.336218+AF0- Code: 8b 74 24 10 48 29 fb 48 89 df e8 a2 d2 f6 ff 48 8b 1c 24 4c 8b 64 24 08 c9 c3 0f 1f 80 00 00 00 00 48 89 df e8 38 60 fb ff eb 9a +ADw-0f+AD4- 0b 0f 1f 40 00 eb f
a 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
+AFs-    8.336220+AF0- RIP  +AFsAPA-ffffffff8119bbba+AD4AXQ- bio+AF8-put+-0x8a/0xa0
+AFs-    8.336220+AF0-  RSP +ADw-ffff8808556b7b68+AD4-
+AFs-    8.336221+AF0- ---+AFs- end trace d0966e2430ea53b5 +AF0----

Trying to track it down.

-chris
