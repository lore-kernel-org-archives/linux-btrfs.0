Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52669 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757042AbbGGOp1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jul 2015 10:45:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCU7h-0001TC-KS
	for linux-btrfs@vger.kernel.org; Tue, 07 Jul 2015 16:45:25 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 16:45:25 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 16:45:25 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029 btrfs_free_reserved_data_space
Date: Tue, 07 Jul 2015 16:45:10 +0200
Message-ID: <mngolm$9q$1@ger.gmane.org>
References: <6617728.KSCQs1dauk@o3-3> <mmr75d$vbi$1@ger.gmane.org> <loom.20150630T110709-722@post.gmane.org> <mn0mqd$7pu$1@ger.gmane.org> <loom.20150707T142359-534@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <loom.20150707T142359-534@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/07/2015 02:28 PM, David Weber wrote:
>> How do you backup the VM images? If filefrag takes hours to complete,
>> I'd assume that attempting a sequential read of the whole file (from a
>> backup software) takes just as long.
>
> I use send/receive. With an SSD it doesn't take that long.

Hmmm. The kind of backup you can restore only as a whole,
not individual files... plus you have to hope there are never
systematic bugs in btrfs that would make an individual file
as unreadable from the backup (undetected by send/receive)
as it is from the original. :-)

I for one prefer backups to read/write individual files and
to use a different format for storage.

> A sequential read (dd if=Windows7.vdi of=/dev/zero bs=1M) gives nearly raw
> SSD Speed. But CPU consumption is indeed quite high...

Ok, if all the VM image data is on SSDs, the high fragmentation
might be less of an issue to you.

Regards,

Lutz Vieweg

