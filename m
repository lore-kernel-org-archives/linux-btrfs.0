Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51913 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGKX0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 05:23:26 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so171612eek.5
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Mar 2013 02:23:24 -0800 (PST)
Message-ID: <51386A98.90302@gmail.com>
Date: Thu, 07 Mar 2013 11:23:20 +0100
From: Michael Schmitt <tcwardrobe@gmail.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: weird kernel-oopses while deleting files on btrfs
References: <513356D5.5030301@gmail.com> <20130303235243.GA26002@shiny.masoncoding.com>
In-Reply-To: <20130303235243.GA26002@shiny.masoncoding.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 04.03.2013 00:52, schrieb Chris Mason:
> On Sun, Mar 03, 2013 at 06:57:41AM -0700, Michael Schmitt wrote:
>> Hi list,
>>
>> some rather unexpected btrfs-oopses for my taste. I use btrfs for some
>> time now (mostly on external harddisks) and these "oopses" happened
>> during some simple file and folder deletion operation on that device. It
>> is a luks-encrypted 80GB drive. Anything like that known? And the fs was
>> created just yesterday, how come there is a message like...
>>
>> [91491.919358] btrfs: mismatching generation and generation_v2 found in root item. This root was probably mounted with an older kernel. Resetting all new fields.
> This may be from first mount after mkfs.  It depends on your tools.
During mkfs, mount and that message the same kernel and tools were used. 
At least I am quite sure about that (but I wouldn't swear on my life).

>> ... but the kernel used (3.7.3 from Debian experimental on Debian sid)
>> was installed several days ago. What kind of oopses are these? As of now
>> there is no real data on that device. But if there were, would I need to
>> be concerned about the integrity of those files?
>>
>> [93283.762006] WARNING: at /build/buildd-linux_3.7.3-1~experimental.1-i386-eX5kUQ/linux-3.7.3/fs/btrfs/extent-tree.c:6297 btrfs_alloc_free_block+0xcd/0x2a4 [btrfs]()
> These are not oopsen but warnings.  It's an ENOSPC warning as we try to
> delete the extents.  It did happen sometimes in this kernel, but it is
> only a warning.
Ah, 3.7.x had issues there? Do you have by any chance the bug-# or URL 
at hand? Or could you elaborate a bit what issues a user might have 
there and if he should be concerned? I just wonder how important a 
kernel up- or downgrade might be. But as it is only a "warning" (sorry 
that I did get that wrong), I suppose nothing "bad" could happen? ENOSPC 
on an almost empty filesystem would be at least somewhat "bad". :) But 
fs was almost full and I deleted it completely as the message appeared 
the first time. I copied another batch of files to it (only a few GB, 
maybe 10% of drivespace used) and deleted them again and got the next 
"warning"-message.

regards
Michael
