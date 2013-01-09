Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail6.webfaction.com ([74.55.86.74]:51206 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3AIKgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Jan 2013 05:36:42 -0500
Received: from [192.168.2.123] (unknown [149.241.151.248])
	by smtp.webfaction.com (Postfix) with ESMTP id 347D966EDD54
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Jan 2013 04:36:40 -0600 (CST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1085)
Subject: Re: btrfsck: extent-tree.c:2549: btrfs_reserve_extent: Assertion `!(ret)' failed.
From: Richard Cooper <richard@richardcooper.net>
In-Reply-To: <042190A6-9365-4ACB-AB89-B277F687E09D@richardcooper.net>
Date: Wed, 9 Jan 2013 10:36:39 +0000
Message-Id: <5FB61159-1696-455C-AEE6-E9F64FDFA034@richardcooper.net>
References: <0400867D-6E5E-4D0F-8A06-B5AD3E58DEE6@richardcooper.net> <20130103150606.GC2389@localhost.localdomain> <042190A6-9365-4ACB-AB89-B277F687E09D@richardcooper.net>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 3 Jan 2013, at 16:43, Richard Cooper wrote:

> On 3 Jan 2013, at 15:06, Josef Bacik wrote:
> 
>> On Thu, Jan 03, 2013 at 05:26:38AM -0700, Richard Cooper wrote:
>>> Hi All,
>>> 
>>> I'm trying to repair a broken fs using btrfsck and am hitting a failed assertion. I'd appreciate any suggestions for what to do next. Is there anything I can do to help fix this bug? Any other information from my FS which would help? If the FS could be salvaged that would be a bonus, but I'm more interested in providing a useful bug report before wiping the disk.
>>> 
>> 
>> Well good news is that its the allocator failing to find space for a new block,
>> and the allocator in btrfs-progs is under-tested, so it's likely just an
>> internal bug and something we can fix.  Can you do btrfs fi show /dev/md4 (not
>> mounted) and post that so we can be sure there's actually enough space. 
> 
> # ./btrfs fi show /dev/md4 
> Label: none  uuid: 5be10dea-64c1-474e-b640-987b25af3c27
> 	Total devices 1 FS bytes used 606.79GB
> 	devid    1 size 16.36TB used 627.04GB path /dev/md4

Is this all the information you need? Is there a bug tracker I should report this to, to stop it getting lost in the mailing list archives?

