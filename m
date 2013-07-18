Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:6076 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965081Ab3GRUFf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 16:05:35 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Questions about multi-device behavior
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130718173337.GN24343@twin.jikos.cz>
Date: Thu, 18 Jul 2013 14:05:31 -0600
Cc: Florian Lindner <mailinglists@xgm.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
References: <1860433.azE0Vf7tMy@horus> <20130718173337.GN24343@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 18, 2013, at 11:33 AM, David Sterba <dsterba@suse.cz> wrote:

> 
> The missing data blocks return IO error and the valid data can be read.

Sounds like if I have a degraded 'single' volume, I can simply cp or rsync everything from that volume to another, and I'll end up with a successful copy of the surviving data. True?


Chris Murphy