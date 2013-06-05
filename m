Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:42280 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3FEMyn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 08:54:43 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 31EE27C0445
	for <linux-btrfs@vger.kernel.org>; Wed,  5 Jun 2013 06:54:43 -0600 (MDT)
Date: Wed, 5 Jun 2013 08:54:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Sage Weil <sage@inktank.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: v3.9 bug at /fs/btrfs/free-space-cache.c:1567 after powercycle
Message-ID: <20130605125440.GA29248@localhost.localdomain>
References: <alpine.DEB.2.00.1306042056350.19491@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <alpine.DEB.2.00.1306042056350.19491@cobra.newdream.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 04, 2013 at 09:59:05PM -0600, Sage Weil wrote:
> Hi-
> 
> I'm pretty reliably triggering the following bug after powercycling an 
> active btrfs + ceph workload and then trying to remount.  Is this a known 
> issue?
> 

Yeah sorry it's fixed in 3.10, I really need to send the patch back to stable.
Thanks,

Josef
