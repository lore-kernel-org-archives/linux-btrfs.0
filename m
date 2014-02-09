Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51819 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751290AbaBIC3g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Feb 2014 21:29:36 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Provide a better free space estimate on RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <38386895-51E4-4A9E-AA3D-4D941DDCC793@colorremedies.com>
Date: Sat, 8 Feb 2014 19:29:35 -0700
Cc: Kai Krakow <hurikhan77+btrfs@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <BDBE5EE5-E9B8-42A7-A440-9C4997EADDF7@colorremedies.com>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com> <agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu> <9hqisa-46c.ln1@hurikhan77.spdns.de> <20140209075533.26b4b730@natsu> <38386895-51E4-4A9E-AA3D-4D941DDCC793@colorremedies.com>
To: Roman Mamedov <rm@romanrm.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 8, 2014, at 7:21 PM, Chris Murphy <lists@colorremedies.com> wrote:

> we don't have a top level switch for variable raid on a volume yet

This isn't good wording. We don't have a controllable way to set variable raid levels. The interrupted convert model I'd consider not controllable.


Chris Murphy