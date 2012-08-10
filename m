Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:50694 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754345Ab2HJKi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Aug 2012 06:38:59 -0400
Message-ID: <5024E496.4040702@cn.fujitsu.com>
Date: Fri, 10 Aug 2012 18:38:14 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting shared
 block reference
References: <50232A19.2010704@cn.fujitsu.com> <20120809064802.GB17430@twin.jikos.cz> <20120809072129.GC17430@twin.jikos.cz>
In-Reply-To: <20120809072129.GC17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 9 Aug 2012 09:21:29 +0200, David Sterba wrote:
> On Thu, Aug 09, 2012 at 08:48:02AM +0200, David Sterba wrote:
>> and down, no problems so far, and the "wikipedia" test-subvol stresstest
>> that caused trouble to one of your patches is also ok. I'll do some more
>> testing on other machines and will report problems eventually.
> 
> So it won't be so easy :)
> 
> The test generated 15+ G of data, ~500 snapshots, then umount and fsck:
> 
> lots of
> 
> ref mismatch on [9655283712 4096] extent item 1, found 0
> Incorrect local backref count on 9655283712 root 5 owner 589776 offset 110592 found 0 wanted 1 back 0x86badf0
> backpointer mismatch on [9655283712 4096]
> owner ref check failed [9655283712 4096]
> 
> and then
> 
> checking fs roots
> root 2854 inode 233882 errors 2500
> root 2880 inode 271639 errors 2200
> 
> and it's not finished yet, other types of error may pop up.


Could you try Arne's patch?

[PATCH v2] Btrfs: fix race in run_clustered_refs
http://marc.info/?l=linux-btrfs&m=134449329717830&w=2

I run test for several times with this patch, and the problem didn't happen.
So it seems this patch can fix the above problem.

Regards
Miao

