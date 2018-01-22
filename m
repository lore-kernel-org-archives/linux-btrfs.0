Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:51548 "EHLO
        postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbeAVVRK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Jan 2018 16:17:10 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Chris Mason <clm@fb.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, nborisov@suse.com
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
 <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
 <c276765c-ab66-29a9-c3d6-209ef039a8be@cs.uni-bonn.de>
 <fb757d69-add3-703f-1132-a8b97ac47d56@fb.com>
From: Sebastian Ochmann <ochmann@cs.uni-bonn.de>
Message-ID: <837ffe27-e9df-33c4-a8e8-6f7b67944eae@cs.uni-bonn.de>
Date: Mon, 22 Jan 2018 22:17:06 +0100
MIME-Version: 1.0
In-Reply-To: <fb757d69-add3-703f-1132-a8b97ac47d56@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I attached to the ffmpeg-mux process for a little while and pasted the 
result here:

https://pastebin.com/XHaMLX8z

Can you help me with interpreting this result? If you'd like me to run 
strace with specific options, please let me know. This is a level of 
debugging I'm not dealing with on a daily basis. :)

Best regards
Sebastian


On 22.01.2018 20:08, Chris Mason wrote:
> On 01/22/2018 01:33 PM, Sebastian Ochmann wrote:
> 
> [ skipping to the traces ;) ]
> 
>> 2866 ffmpeg-mux D
>> [<ffffffffc06251b1>] btrfs_start_ordered_extent+0x101/0x130 [btrfs]
>> [<ffffffffc061b0b0>] lock_and_cleanup_extent_if_need+0x340/0x380 [btrfs]
>> [<ffffffffc061c3c1>] __btrfs_buffered_write+0x261/0x740 [btrfs]
>> [<ffffffffc06202bf>] btrfs_file_write_iter+0x20f/0x650 [btrfs]
>> [<ffffffff9b235309>] __vfs_write+0xf9/0x170
>> [<ffffffff9b23551d>] vfs_write+0xad/0x1a0
>> [<ffffffff9b235762>] SyS_write+0x52/0xc0
>> [<ffffffff9b800083>] entry_SYSCALL_64_fastpath+0x1a/0x7d
>> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> This is where we wait for writes that are already in flight before we're 
> allowed to redirty those pages in the file.  It'll happen when we either 
> overwrite a page in the file that we've already written, or when we're 
> trickling down writes slowly in non-4K aligned writes.
> 
> You can probably figure out pretty quickly which is the case by stracing 
> ffmpeg-mux.  Since lower dirty ratios made it happen more often for you, 
> my guess is the app is sending down unaligned writes.
> 
> -chris
> 
> 
