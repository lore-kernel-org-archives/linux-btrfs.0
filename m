Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56560 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab3JEOoi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 10:44:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VST5w-0002ds-Db
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 16:44:36 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 16:44:36 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 16:44:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
Date: Sat, 5 Oct 2013 14:44:17 +0000 (UTC)
Message-ID: <pan$2eb11$bbed6571$fb7d3108$4fff2a35@cox.net>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
	<pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
	<CAOMFOmWuEhqg4L18h+0BXo-=T7ur2dJF--FU8-=O6-zWAeDXhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anatol Pomozov posted on Sat, 05 Oct 2013 04:51:52 -0700 as excerpted:

> Hi
> 
> On Fri, Oct 4, 2013 at 9:42 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Anatol Pomozov posted on Fri, 04 Oct 2013 21:03:11 -0700 as excerpted:
>>
>>> Hi,
>>>
>>> I have a home server on Linux Arch (kernel 3.11.2) that uses
>>> multi-device btrfs on root filesystem.
>>>
>>> Until recently it worked completely fine. And yesterday I rebooted it
>>> and the machine did not wake up.
>>>
>>> I booted from a USB (kernel 3.10) and tried to mount the filesystem.
>>> Here is OOPs I see
>>
>>> ------------[ cut here ]------------
>>> [   68.126138] kernel BUG at fs/btrfs/inode.c:873!
>>> [   68.126164] invalid opcode: 0000 [#1] PREEMPT SMP
>>
>>> The only thing that I did recently is defrag /var/log/journal files
>>> (journalctl is very slow because of btrfs COW). Something like this
>>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24878.html

I forgot I was going to mention this in the previous reply...

You can try setting the NOCOW attribute for that file or directory.  
There's instructions on the wiki (btrfs.wiki.kernel.org).  Virtual 
machine images also often work better with NOCOW.

Meanwhile, thinking about systemd journal files there's also another 
patch that is too new to be in the mainline kernel, I think.  That bug 
was found on systemd journal files specifically, because systemd was 
allocating and then writing into them and btrfs wasn't doing the right 
thing with that.  There's a current thread about it.  Since I don't use 
systemd, however, I've not followed it that closely.

>> I'm not a dev just a btrfs user and list regular myself, so the traces
>> don't mean much to me.  However, the bit I retained in the quote above
>> (especially the 0000 opcode) looks very much like a bug that should be
>> fixed in kernel 3.12

>> So the first thing I'd try is either cherrypicking the btrfs patches
>> from 3.12 back to 3.11-stable, or wait for 3.11.5 and check for btrfs
>> patches there, or try 3.12-rcX (rc3 is out and I guess rc4 should be
>> out shortly now as I think it has been nearly a week).
> 
> Could you please give me the patch SHA1 you are talking about?

Sorry, I've not tracked it /that/ closely, as I'm not a dev so the real 
technical stuff is over my head, and I run rc kernels from about rc2 
anyway, so I have the fixes reasonably fast already.  I simply try to 
keep up with the general gist of things well enough to search the list 
for that thread I remembered if I need to, and you should be able to do 
that as well as I, now that you know the threads and patches are there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

