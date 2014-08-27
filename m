Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54779 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbaH0WFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Aug 2014 18:05:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XMlKx-0007ao-BE
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 00:05:03 +0200
Received: from cable-192.222.157.175.electronicbox.net ([192.222.157.175])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 00:05:03 +0200
Received: from ngrigoriev by cable-192.222.157.175.electronicbox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 00:05:03 +0200
To: linux-btrfs@vger.kernel.org
From: Nikolai Grigoriev <ngrigoriev@gmail.com>
Subject: Re: ext4 vs btrfs performance on SSD array
Date: Wed, 27 Aug 2014 21:59:50 +0000 (UTC)
Message-ID: <loom.20140827T235422-162@post.gmane.org>
References: <CAEp=YLgzsLbmEfGB5YKVcHP4CQ-_z1yxnZ0tpo7gjKZ2e1ma5g@mail.gmail.com> <pan$646f5$964a0f2f$c0fb64a3$d18066b7@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> Nikolai Grigoriev posted on Tue, 26 Aug 2014 19:39:08 -0400 as excerpted:
> 
> > Kernel: 3.8.13-35.3.5.el6uek.x86_64 #2 SMP Fri Aug 8 21:58:11 PDT 2014
> > x86_64 x86_64 x86_64 GNU/Linux
> 
> > Btrfs v0.20-rc1
> 
> I've no answer for your question, but you know how old both your kernel 
> and btrfs-progs versions are, for a filesystem under as heavy development 
> as btrfs is, right?

Yes. As much as I'd like to run latest & greatest the company sticks to OEL
6.5 so I have to play within the limits. The primary reason why I asked the
question is because I have noticed that "btrfs does it much better :)" and
wanted to understand why. Either to understand ext4 limitations vs btrfs or
to understand the issues with my ext4 configuration.

Actually, I have found the answer later last night. I have found that btrfs
has its own readahead implementation. So I've got an idea to disable it and
see if it makes it slower. And, indeed, I can confirm that in my specific
test scenario the readahead with 4Mb (default) buffer was making lots of
difference. I think it was mostly due to RAID-0 with 2 SSDs. But even on a
single filesystem it does make a difference.

Then I have also realized that since it was due to readahead, it won't be a
big game changer for Cassandra as it does lots of random reads.

But thanks anyway for the detailed explanation of BTRFS status. I'll surely
use it as soon as I can.


