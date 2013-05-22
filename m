Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57574 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755039Ab3EVCX2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 22:23:28 -0400
Received: from [50.12.106.86] (port=53413 helo=ming.local.tld)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80)
	(envelope-from <lists@colorremedies.com>)
	id 1Ueyi7-002Xhu-Ct
	for linux-btrfs@vger.kernel.org; Tue, 21 May 2013 20:23:27 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Virtual Device Support
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <knfnv7$k9h$1@ger.gmane.org>
Date: Tue, 21 May 2013 22:23:24 -0400
Message-Id: <35EFD5CE-80A2-481B-82DD-EFC6C6D91405@colorremedies.com>
References: <518CFE3A.3080900@chinilu.com> <20130519171510.54897415@natsu> <262CC063-0DB4-45BD-A776-9FD1E8650E7C@colorremedies.com> <pan$d75cf$ec7daeb9$c2cc055b$98b478d0@cox.net> <9BA35EA6-D116-4223-B2C0-CE4FEA3D4010@colorremedies.com> <knfnv7$k9h$1@ger.gmane.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On May 21, 2013, at 8:06 AM, Martin <m_btrfs@ml1.co.uk> wrote:

> On 21/05/13 04:37, Chris Murphy wrote:
>> 
>> I'm going to contradict myself and point out that mount with label or
>> UUID is made unambiguous via either the default subvolume being
>> mounted, or the -o subvol= option being specified. The volume label
>> and UUID doesn't apply to umount because it's an ambiguous command.
>> You'd have to umount a mountpoint, or possibly a subvolume specific
>> UUID.
> 
> I guess the ideas of labels and UUID and multiple devices came out a few
> years later?... For btrfs, umount needs to operate on the default subvol
> but with the means for also specifying a specific subvol if needed.

Yeah and I think specifying -o for umount isn't what devs are interested in doing, and I think that's understandable. But I'm pretty sure there are btrfs subvolume UUIDs now? So even if umount doesn't support -o, it should still support /dev/disk/by-uuid/xxxxxxxxxxx just as it does /dev/sda1 or whatever.


Chris Murphy

