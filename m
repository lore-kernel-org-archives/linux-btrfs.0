Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:42570 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933552AbaD3QAp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Apr 2014 12:00:45 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: File capabilities are lost when sending/receiving a btrfs subvolume
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2199169.56ItP7JcO9@xenon.miceliux.com>
Date: Wed, 30 Apr 2014 10:00:29 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <3DF68968-CAEC-483B-9217-0464520404BF@colorremedies.com>
References: <2199169.56ItP7JcO9@xenon.miceliux.com>
To: Juan Orti Alcaine <juan.orti@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 29, 2014, at 1:21 PM, Juan Orti Alcaine <juan.orti@miceliux.com> wrote:

> Hello, I noticed that file capabilites are lost on received subvolumes, so I 
> opened the bug report #68891 [1]. I don't know if other xattrs are affected by 
> this problem.

I can reproduce the reported problem with kernel 3.15rc3 and btrfs-progs 3.14. I don't know if these xattr are being dropped by the send (kernel), or the receive (progs). SELinux labels are preserved, so those xattr aren't affected by this problem.

I'm not sure if there's a single library/command that fully handles all xattr. So far I'm finding three distinct commands that leverage xattr but are mutually exclusive in that they don't list/remove other xattr.


Chris Murphy

