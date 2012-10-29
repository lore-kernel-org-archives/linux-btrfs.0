Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:35459 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab2J2GV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Oct 2012 02:21:56 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: warnings for silly/pointless raid levels
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <k6kb3g$ae4$1@ger.gmane.org>
Date: Mon, 29 Oct 2012 00:21:53 -0600
Message-Id: <5A9E1AAA-4DD3-4D4A-9AC4-520BEEF129CE@colorremedies.com>
References: <k6kb3g$ae4$1@ger.gmane.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 28, 2012, at 4:20 PM, sam tygier <samtygier@yahoo.co.uk> wrote:

> Hi,
> I recently got into a stick situation because i had a btrfs volume with data in raid1 but metadata as dup. when i removed one of the drives i could not mount as degraded. This was my error as i did not convert the metadata when i converted it from a single/dup volume.
> 
> But i wonder if there should be a warning for raid combinations that are probably mistakes. raid1/dup, provides no protection against a failed disk, but uses as much space as if it did. so maybe the tools could have refused to allow it without a --force.

I think the argument I've read recently, is that an automatic "upgrade" of metadata to raid1 in this case is desired. I'd like to see metadata upgraded to raid1 when a 2nd disk is added in any case, by default. In data raid0 or single, I'm probably hosed with one drive failures, but maybe I can get some fragments off the drive if I have metadata. Is there a downside? I don't think so because the default metadata profile for multiple device mkfs is raid1 in any case.


Chris Murphy