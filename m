Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:54328 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754869Ab2JVGCK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 02:02:10 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: device delete, error removing device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
Date: Mon, 22 Oct 2012 00:02:08 -0600
Message-Id: <4D1258FC-36CB-4C7B-AE7F-AFCC73E6AEC4@colorremedies.com>
References: <D297D796-B7E9-4A65-AD72-EC394AD32D4C@colorremedies.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 21, 2012, at 10:32 PM, Chris Murphy <lists@colorremedies.com> wrote:

> This is stock Fedora 18 beta kernel, 3.6.1-1.fc18.x86_64 #1 SMP Mon Oct 8 17:19:09 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

Probably not a good idea to omit this is a beta *test candidate* not a beta. 

Two things that make this possibly not realistic:

1. The virtual disks are obviously very small, 3GB each with the 4th one only 12GB.

2. The original 3 device volume was ~97% full with a single large file prior to adding the 4th device. Approximately 313MB free space remained on the volume.


Chris Murphy

