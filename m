Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55947 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbbF3JPG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 05:15:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z9rdA-0004md-ML
	for linux-btrfs@vger.kernel.org; Tue, 30 Jun 2015 11:15:04 +0200
Received: from HSI-KBW-217-008-058-175.hsi.kabelbw.de ([217.8.58.175])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 11:15:04 +0200
Received: from wb by HSI-KBW-217-008-058-175.hsi.kabelbw.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Jun 2015 11:15:04 +0200
To: linux-btrfs@vger.kernel.org
From: David Weber <wb@munzinger.de>
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029 =?utf-8?b?YnRyZnNfZnJlZV9yZXNlcnZlZF9kYXRhX3NwYWNl?=
Date: Tue, 30 Jun 2015 09:10:53 +0000 (UTC)
Message-ID: <loom.20150630T110709-722@post.gmane.org>
References: <6617728.KSCQs1dauk@o3-3> <mmr75d$vbi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lutz Vieweg <lvml <at> 5t9.de> writes:

> 
> On 06/29/2015 11:35 AM, David Weber wrote:
> > we are testing Btrfs as a kvm storage system with
> > "defaults,space_cache,nodatacow" mount options and regular snapshots.
> 
> That sounds brave - even with "nodatacow" it appeared to me
> that using btrfs with often partially overwritten files like
> VM images results in excessively fragmented files.
> And taking snapshots kind of counteracts "nodatacow".
> 
> What does "filefrag" tell about your VM images on btrfs?
> 
> (As much as I like btrfs for other purposes, I currently stay
> with XFS for VM images, database files and alike.)

Fragmentation can create a performance hit and you have to ponder if the 
features are worth it.
I use Btrfs with regular snapshots on my workstation with Virtualbox since 
years. Running filefrag on the image doesn't complete after hours but the 
IO of the VM is still "fast enough". But the definition of "fast enough" 
can vary heavily.
If it becomes to slow I will try a btrfs fi deframent or just recreate the 
image with a no reflink copy.

Cheers,
David




