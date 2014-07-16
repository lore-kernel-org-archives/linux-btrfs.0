Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:38474 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754292AbaGPXS4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 19:18:56 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Is it safe to mount subvolumes of already-mounted volumes (even with different options)?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53C6FA3D.9010803@informatik.uni-bonn.de>
Date: Wed, 16 Jul 2014 17:18:53 -0600
Message-Id: <E49EC0AC-DD96-4D7F-9B36-9E28CEC0CD2A@colorremedies.com>
References: <53C6FA3D.9010803@informatik.uni-bonn.de>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 16, 2014, at 4:18 PM, Sebastian Ochmann <ochmann@informatik.uni-bonn.de> wrote:

> Hello,
> 
> I'm sharing a btrfs-formatted drive between multiple computers and each of the machines has a separate home directory on that drive.

2+ computers writing to the same block device? I don't see how this is safe. Seems possibly a bug that the 1st mount event isn't setting some metadata so that another kernel instance knows not to allow another mount.


Chris Murphy