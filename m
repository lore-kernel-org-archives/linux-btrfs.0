Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36518 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbcD1Le1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 07:34:27 -0400
Received: by mail-io0-f169.google.com with SMTP id u185so85568394iod.3
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 04:34:27 -0700 (PDT)
Subject: Re: ...in the matter of partition size
To: Juan Alberto Cirez <jacirez@rdcsafety.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <83e5e576-7ed6-ab5b-342f-f4bce6251633@gmail.com>
Date: Thu, 28 Apr 2016 07:33:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAHaPQf1sJpO6bDWUQFp=XEEwuV8P8-qY7bT0UgZEdbazUUWNTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-27 16:18, Juan Alberto Cirez wrote:
> Quick question: Supposed I have n-number of storage pods (physical
> servers with n-number of physical hhds). The end deployment will be
> btrfs at the brick/block level with a distributed file system on top.
> Keeping in mind that my overriding goal is to have high availability
> and the mechanism whereby the lost of a drive or multiple drives in a
> single pod will not jeopardize data.
>>>>>> Question<<<<<
> Does partitioning the physical drives and creating btrfs filesystem on
> each partition, then configuring each partition as individual
> bricks/blocks offer ANY added benefits over grouping the entire pod
> into a drive pool and using that pool as a single block/brick to
> expose to the distributed filesystem?
This overall depends on a number of factors.  From a data safety issue, 
I'd say grouping drives pair-wise in each server with BTRFS raid1 would 
be the best option if you absolutely want to use BTRFS.

I somewhat agree with Chris Murphy's statement that you may not want to 
use BTRFS because it's still relatively new, but I'm more of the opinion 
that as long as you're following the usual sysadmin rules (do proper 
research, test thoroughly, keep backups, and don't upgrade everything at 
once if at all possible) and are using stuff that's been around for a 
while (like raid1 mode inst4ead of one of the parity modes), you should 
generally be fine.  If you do go with BTRFS, I'd suggest subscribing to 
the mailing list and ideally practicing fixing broken filesystems.

