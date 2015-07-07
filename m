Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43250 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbbGGM2T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jul 2015 08:28:19 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZCRyu-0007jy-RZ
	for linux-btrfs@vger.kernel.org; Tue, 07 Jul 2015 14:28:12 +0200
Received: from HSI-KBW-217-008-058-175.hsi.kabelbw.de ([217.8.58.175])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 14:28:12 +0200
Received: from wb by HSI-KBW-217-008-058-175.hsi.kabelbw.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jul 2015 14:28:12 +0200
To: linux-btrfs@vger.kernel.org
From: David Weber <wb@munzinger.de>
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029 =?utf-8?b?YnRyZnNfZnJlZV9yZXNlcnZlZF9kYXRhX3NwYWNl?=
Date: Tue, 7 Jul 2015 12:28:07 +0000 (UTC)
Message-ID: <loom.20150707T142359-534@post.gmane.org>
References: <6617728.KSCQs1dauk@o3-3> <mmr75d$vbi$1@ger.gmane.org> <loom.20150630T110709-722@post.gmane.org> <mn0mqd$7pu$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lutz Vieweg <lvml <at> 5t9.de> writes:

> 
> On 06/30/2015 11:10 AM, David Weber wrote:
> > I use Btrfs with regular snapshots on my workstation with Virtualbox 
since
> > years. Running filefrag on the image doesn't complete after hours but the
> > IO of the VM is still "fast enough". But the definition of "fast enough"
> > can vary heavily.
> 
> How do you backup the VM images? If filefrag takes hours to complete,
> I'd assume that attempting a sequential read of the whole file (from a
> backup software) takes just as long.

I use send/receive. With an SSD it doesn't take that long.

> 
> > If it becomes to slow I will try a btrfs fi deframent or just recreate 
the
> > image with a no reflink copy.
> 
> Chances are this will also take hours.

A sequential read (dd if=Windows7.vdi of=/dev/zero bs=1M) gives nearly raw 
SSD Speed. But CPU consumption is indeed quite high...
> 
> Regards,
> 
> Lutz Vieweg


