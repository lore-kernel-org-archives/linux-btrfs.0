Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:34237 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758499AbcDESPc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 14:15:32 -0400
Received: by mail-qg0-f41.google.com with SMTP id c6so17112086qga.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 11:15:31 -0700 (PDT)
Subject: Re: good documentation on btrfs internals and on disk layout
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>,
        linux-btrfs@vger.kernel.org
References: <loom.20160330T155403-473@post.gmane.org>
 <20160330184327.GO29474@carfax.org.uk>
 <CAKWEGV5tsEJHmb_Y0aQD0fsc4v3Un4rWBzS5QUUGhFz2HyTGKg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <570400A4.4090609@gmail.com>
Date: Tue, 5 Apr 2016 14:15:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKWEGV5tsEJHmb_Y0aQD0fsc4v3Un4rWBzS5QUUGhFz2HyTGKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-05 13:53, Yauhen Kharuzhy wrote:
> Hello,
>
> I try to understand btrfs logic in mounting of multi-device filesystem
> when device generations are different. All my questions are related to
> RAID5/6 for system, metadata, and data case.
>
> Kernel can mount FS with different device generations (if drive was
> physically removed before last unmount and returned back after, for
> example) now but scrub will report uncorrectable errors after this
> (but second run doesn't show any errors). Does any documentation about
> algorithm of multiple device handling in such case exist? Does the
> case with different device generations is allowed in general and what
> worst cases can be here?
In general, it isn't allowed, but we don't explicitly disallow it 
either.  The worst case here is that the devices both get written two 
separately, and you end up with data not matching for correlated 
generation ID's.  The second scrub in this case shows no errors because 
the first one corrects them (even though they are reported as 
uncorrectable, which is a bug as far as I can tell), and from what I can 
tell from reading the code, it does this by just picking the highest 
generation ID and dropping the data from the lower generation.
>
> What should happen if device was removed and returned back after some
> time when filesystem is online? Should some kind of device
> reopening be possible or one possible way to guarantee FS consistensy
> is  to mark such device as missing and to replace it?
In this case, the device being removed (or some component between the 
device and the processor failing, or the device itself erroneously 
reporting failure) will force the FS read-only.  If the device reappears 
while the FS is still online, it may just start working again (this is 
_really_ rare, and requires that the device appear with the same device 
node as it had previously, and this usually only happens when the device 
disappears for only a very short period of time), or it may not work 
until the FS gets remounted (this is usually the case), or the system 
may crash (thankfully this almost never happens, and it's usually not 
because of BTRFS when it does).  Regardless of what happens, you may 
still have to run a scrub to make sure everything is consistent.
