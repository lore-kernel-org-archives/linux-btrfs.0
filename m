Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56516 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500AbbGAMfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jul 2015 08:35:37 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZAHEh-0003mE-Ai
	for linux-btrfs@vger.kernel.org; Wed, 01 Jul 2015 14:35:31 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 14:35:31 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2015 14:35:31 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029 btrfs_free_reserved_data_space
Date: Wed, 01 Jul 2015 14:35:24 +0200
Message-ID: <mn0mqd$7pu$1@ger.gmane.org>
References: <6617728.KSCQs1dauk@o3-3> <mmr75d$vbi$1@ger.gmane.org> <loom.20150630T110709-722@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <loom.20150630T110709-722@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/30/2015 11:10 AM, David Weber wrote:
> I use Btrfs with regular snapshots on my workstation with Virtualbox since
> years. Running filefrag on the image doesn't complete after hours but the
> IO of the VM is still "fast enough". But the definition of "fast enough"
> can vary heavily.

How do you backup the VM images? If filefrag takes hours to complete,
I'd assume that attempting a sequential read of the whole file (from a
backup software) takes just as long.

> If it becomes to slow I will try a btrfs fi deframent or just recreate the
> image with a no reflink copy.

Chances are this will also take hours.

Regards,

Lutz Vieweg

