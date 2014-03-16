Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:40924 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755790AbaCPXML convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:12:11 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to handle a RAID5 arrawy with a failing drive? 
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>
Date: Sun, 16 Mar 2014 17:12:10 -0600
Message-Id: <C66D07BC-E0E7-4F3D-8ACD-C3E9E575C629@colorremedies.com>
To: Btrfs <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20140316222026.GU16946@merlins.org>
 <F8E88232-C43A-4BFD-B2A6-411576299531@colorremedies.com>


On Mar 16, 2014, at 4:55 PM, Chris Murphy <lists@colorremedies.com> wrote:

> Then use btrfs replace start.

Looks like in 3.14rc6 replace isn't yet supported. I get "dev_replace cannot yet handle RAID5/RAID6".

When I do:
btrfs device add <new> <mp>

The command hangs, no kernel messages.

Chris Murphy

