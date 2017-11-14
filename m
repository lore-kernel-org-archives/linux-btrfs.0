Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-me1aus01on0079.outbound.protection.outlook.com ([104.47.116.79]:36896
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750714AbdKNFIF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 00:08:05 -0500
From: Ben Hooper <ben@ayrton.com.au>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs check fails with: btrfs_alloc_chunk: BUG_ON `ret`
 triggered, value -28
Date: Tue, 14 Nov 2017 05:07:59 +0000
Message-ID: <B10019A7-007D-41FF-9953-E47C8207F7ED@ayrton.com.au>
References: <SY3PR01MB1465C3E1A99997C75685BE0FF9280@SY3PR01MB1465.ausprd01.prod.outlook.com>
 <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
In-Reply-To: <CAJCQCtTKNL9bjpeZFKU0r99R0kkMB4NQ_UE16CYX=9dDyWaXWA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On 14 Nov 2017, at 11:45 am, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Mon, Nov 13, 2017 at 8:08 PM, Ben Hooper <ben@ayrton.com.au> wrote:
> 
>> [28205.454029] Code: 79 ff ff ff 49 8b 7c 24 60 89 da 48 c7 c6 68 c7 be a0 31 c0 e8 12 4e fe ff eb 9b 89 de 48 c7 c7 38 c7 be a0 31 c0 e8 53 11 5a e0 <0f> ff eb 87 66 90 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90
>> [28205.456407] ---[ end trace 77358f42ce65a0d0 ]---
>> [28205.457579] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
>> [28206.172366] BTRFS: error (device sdl) in btrfs_create_pending_block_groups:10254: errno=-27 unknown
>> [28206.178599] BTRFS warning (device sdl): Skipping commit of aborted transaction.
>> [28206.179840] BTRFS: error (device sdl) in cleanup_transaction:1873: errno=-5 IO failure
>> [28206.256720] BTRFS error (device sdl): pending csums is 1368064
> 
> The mysterious -27. But then also IO failure. Are there any other
> storage related kernel messages in the ~2 to 5 minutes prior to this
> trace? I'm wondering if there's something misbehaving: cable,
> controller, drive, other.

Good question. I thought the IO error here was a response to the filesystem being remounted RO. 

Unfortunately I cannot see any other IO errors in the dmesg, and the mpt2sas driver is not reporting any errors. I do see a few blocked tasks:

        [15238.872017] INFO: task kworker/u50:21:12403 blocked for more than 120 seconds.
        [15238.873173]       Not tainted 4.14.0-rc7+ #1
        [15238.874251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
        [15238.875773] kworker/u50:21  D    0 12403      2 0x80000080
        [15238.877313] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]

Complete dmesg here if interested - https://pastebin.com/raw/wFasQrWs (long)

Cheers,

Ben

