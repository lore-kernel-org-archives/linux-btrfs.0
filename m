Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:49867 "EHLO
        postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbeAVSdm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:33:42 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
        nborisov@suse.com, clm@fb.com
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
 <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
From: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Message-ID: <c276765c-ab66-29a9-c3d6-209ef039a8be@cs.uni-bonn.de>
Date: Mon, 22 Jan 2018 19:33:38 +0100
MIME-Version: 1.0
In-Reply-To: <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

First off, thank you for all the responses! Let me reply to multiple 
suggestions at once in this mail.

On 22.01.2018 01:39, Qu Wenruo wrote:
> Either such mount option has a bug, or some unrelated problem.
> 
> As you mentioned the output is about 10~50MiB/s, 30s means 300~1500MiBs.
> Maybe it's related to the dirty data amount?
> 
> Would you please verify if a lower or higher profile (resulting much
> larger or smaller data stream) would affect?

A much lower rate seems to mitigate the problem somewhat, however I'm 
talking about low single-digit MB/s when the problem seems to vanish. 
But even with low, but more realistic, amounts of data the drops still 
happen.

> Despite that, I'll dig to see if commit= option has any bug.
> 
> And you could also try the nospace_cache mount option provided by Chris
> Murphy, which may also help.

I tried the nospace_cache option but it doesn't seem to make a 
difference to me.

On 22.01.2018 15:27, Chris Mason wrote:
 > This could be a few different things, trying without the space cache was
 > already suggested, and that's a top suspect.
 >
 > How does the application do the writes?  Are they always 4K aligned or
 > does it send them out in odd sizes?
 >
 > The easiest way to nail it down is to use offcputime from the iovisor
 > project:
 >
 >
 > https://github.com/iovisor/bcc/blob/master/tools/offcputime.py
 >
 > If you haven't already configured this it may take a little while, but
 > it's the perfect tool for this problem.
 >
 > Otherwise, if the stalls are long enough you can try to catch it with
 > /proc/<pid>/stack.  I've attached a helper script I often use to dump
 > the stack trace of all the tasks in D state.
 >
 > Just run walker.py and it should give you something useful.  You can use
 > walker.py -a to see all the tasks instead of just D state.  This just
 > walks /proc/<pid>/stack, so you'll need to run it as someone with
 > permissions to see the stack traces of the procs you care about.
 >
 > -chris

I tried the walker.py script and was able to catch stack traces when the 
lag happens. I'm pasting two traces at the end of this mail - one when 
it happened using a USB-connected HDD and one when it happened on a SATA 
SSD. The latter is encrypted, hence the dmcrypt_write process. Note 
however that my original problem appeared on a SSD that was not encrypted.

In reply to the mail by Duncan:
> 64 GB RAM...
> 
> Do you know about the /proc/sys/vm/dirty_* files and how to use/tweak 
> them?  If not, read $KERNDIR/Documentation/sysctl/vm.txt, focusing on 
> these files.

At least I have never tweaked those settings yet. I certainly didn't 
know about the foreground/background distinction, that is really 
interesting. Thank you for the very extensive info and guide btw!

> So try setting something a bit more reasonable and see if it helps.  That 
> 1% ratio at 16 GiB RAM for ~160 MB was fine for me, but I'm not doing 
> critical streaming, and at 64 GiB you're looking at ~640 MB per 1%, as I 
> said, too chunky.  For streaming, I'd suggest something approaching the 
> value of your per-second IO bandwidth, we're assuming 100 MB/sec here so 
> 100 MiB but let's round that up to a nice binary 128 MiB, for the 
> background value, perhaps half a GiB or 5 seconds worth of writeback time 
> for foreground, 4 times the background value.  So:
> 
> vm.dirty_background_bytes = 134217728   # 128*1024*1024, 128 MiB
> vm.dirty_bytes = 536870912              # 512*1024*1024, 512 MiB

Now I have good and bad news. The good news is that setting these 
tunables to different values does change something. The bad news is that 
lowering these values only seems to let the lag and frame drops happen 
quicker/more frequently. I have also tried lowering the background bytes 
to, say, 128 MB but the non-background bytes to 1 or 2 GB, but even the 
background task seems to already have a bad enough effect to start 
dropping frames. :( When writing to the SSD, the effect seems to be 
mitigated a little bit, but still frame drops are quickly occurring 
which is unacceptable given that the system is generally able to do better.

By the way, as you can see from the stack traces, in the SSD case blk_mq 
is in use.

> But I know less about that stuff and it's googlable, should you decide to 
> try playing with it too.  I know what the dirty_* stuff does from 
> personal experience. =:^)

"I know what the dirty_* stuff does from personal experience. =:^)" 
sounds quite interesting... :D


Best regards and thanks again
Sebastian


First stack trace:

690 usb-storage D
[<ffffffffc03f4404>] usb_sg_wait+0xf4/0x150 [usbcore]
[<ffffffffc0bd53a3>] usb_stor_bulk_transfer_sglist.part.1+0x63/0xb0 
[usb_storage]
[<ffffffffc0bd5439>] usb_stor_bulk_srb+0x49/0x80 [usb_storage]
[<ffffffffc0bd55d3>] usb_stor_Bulk_transport+0x163/0x3d0 [usb_storage]
[<ffffffffc0bd5f07>] usb_stor_invoke_transport+0x37/0x4c0 [usb_storage]
[<ffffffffc0bd7518>] usb_stor_control_thread+0x1d8/0x2c0 [usb_storage]
[<ffffffff9b09f038>] kthread+0x118/0x130
[<ffffffff9b8002cf>] ret_from_fork+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

2505 kworker/u16:2 D
[<ffffffff9b0ac182>] io_schedule+0x12/0x40
[<ffffffff9b347f48>] wbt_wait+0x1b8/0x340
[<ffffffff9b318536>] blk_mq_make_request+0xe6/0x6e0
[<ffffffff9b30c85e>] generic_make_request+0x11e/0x310
[<ffffffff9b30cabc>] submit_bio+0x6c/0x130
[<ffffffffc062fd77>] run_scheduled_bios+0x197/0x580 [btrfs]
[<ffffffffc063b0d0>] btrfs_worker_helper+0x70/0x330 [btrfs]
[<ffffffff9b0990eb>] process_one_work+0x1db/0x410
[<ffffffff9b09934b>] worker_thread+0x2b/0x3d0
[<ffffffff9b09f038>] kthread+0x118/0x130
[<ffffffff9b8002cf>] ret_from_fork+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

Second stack trace:

618 dmcrypt_write D
[<ffffffff9b0ac182>] io_schedule+0x12/0x40
[<ffffffff9b347f48>] wbt_wait+0x1b8/0x340
[<ffffffff9b318536>] blk_mq_make_request+0xe6/0x6e0
[<ffffffff9b30c85e>] generic_make_request+0x11e/0x310
[<ffffffffc0351b6e>] dmcrypt_write+0x21e/0x240 [dm_crypt]
[<ffffffff9b09f038>] kthread+0x118/0x130
[<ffffffff9b8002cf>] ret_from_fork+0x1f/0x30
[<ffffffffffffffff>] 0xffffffffffffffff

2866 ffmpeg-mux D
[<ffffffffc06251b1>] btrfs_start_ordered_extent+0x101/0x130 [btrfs]
[<ffffffffc061b0b0>] lock_and_cleanup_extent_if_need+0x340/0x380 [btrfs]
[<ffffffffc061c3c1>] __btrfs_buffered_write+0x261/0x740 [btrfs]
[<ffffffffc06202bf>] btrfs_file_write_iter+0x20f/0x650 [btrfs]
[<ffffffff9b235309>] __vfs_write+0xf9/0x170
[<ffffffff9b23551d>] vfs_write+0xad/0x1a0
[<ffffffff9b235762>] SyS_write+0x52/0xc0
[<ffffffff9b800083>] entry_SYSCALL_64_fastpath+0x1a/0x7d
[<ffffffffffffffff>] 0xffffffffffffffff

