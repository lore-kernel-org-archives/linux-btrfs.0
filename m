Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55709 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279Ab3BJN10 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Feb 2013 08:27:26 -0500
Received: by mail-ea0-f178.google.com with SMTP id a14so2328834eaa.23
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 05:27:25 -0800 (PST)
Message-ID: <5117A071.8060607@gmail.com>
Date: Sun, 10 Feb 2013 14:28:17 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs and LVM snapshots (Re: kernel BUG at fs/btrfs/extent-tree.c:1772)
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl> <20130204165825.GC2275@localhost.localdomain> <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl> <20130205135147.GD2275@localhost.localdomain> <5116EAA1.1030901@siedziba.pl>
In-Reply-To: <5116EAA1.1030901@siedziba.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2013 01:32 AM, Piotr Pawłow wrote:
> Hello,
>> Yeah you can't mount images, we clear out the chunk tree so
>> nothing works. Let me know if you run into any problems in the
>> future.  Thanks,
> 
> That's surprising, I haven't seen it mentioned anywhere.
> 
> With any other filesystem I could use an LVM snapshot to save the 
> original state, but with a multi-device btrfs it would be very
> risky. Origin and snapshot volumes could easily get mixed up by
> kernel and tools.
> 
> I tried that in qemu, and I've seen btrfs happily mount 1 origin and
> 1 snapshot device as a single FS. And then I've seen it mount both
> origin devices, even though one of them had old content. Naturally
> it complained a lot about bad checksums.

I can confirm that, even with a single-device btrfs filesystem. However
I am curious why you want to use the lvm snapshot capability instead of
the btrfs one.
> 
> Is there any way to avoid such mix-ups? To somehow mark devices so
> that btrfs would know these devices belong together?

Btrfs assume that every device has an "unique" uuid. However when a
device is snapshotted it uuid is copied too, so it is not unique any
more. This is the reason of the btrfs confusing.


> Regards -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
ss
