Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:41003 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab3BJAcj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Feb 2013 19:32:39 -0500
Received: from [85.222.100.130] (zlom.siedziba.pl [85.222.100.130])
	by zlom.siedziba.pl (Postfix) with ESMTPSA id D02628887CB
	for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 01:32:33 +0100 (CET)
Message-ID: <5116EAA1.1030901@siedziba.pl>
Date: Sun, 10 Feb 2013 01:32:33 +0100
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs and LVM snapshots (Re: kernel BUG at fs/btrfs/extent-tree.c:1772)
References: <55e4fbbdada4ee37bdccac2537683d83.squirrel@lampka.siedziba.pl> <20130204165825.GC2275@localhost.localdomain> <c70388910a26ddb79b9f358e0ccb78f5.squirrel@lampka.siedziba.pl> <20130205135147.GD2275@localhost.localdomain>
In-Reply-To: <20130205135147.GD2275@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
> Yeah you can't mount images, we clear out the chunk tree so nothing works.
> Let me know if you run into any problems in the future.  Thanks,

That's surprising, I haven't seen it mentioned anywhere.

With any other filesystem I could use an LVM snapshot to save the 
original state, but with a multi-device btrfs it would be very risky. 
Origin and snapshot volumes could easily get mixed up by kernel and tools.

I tried that in qemu, and I've seen btrfs happily mount 1 origin and 1 
snapshot device as a single FS. And then I've seen it mount both origin 
devices, even though one of them had old content. Naturally it 
complained a lot about bad checksums.

Is there any way to avoid such mix-ups? To somehow mark devices so that 
btrfs would know these devices belong together?

Regards
