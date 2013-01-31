Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:54001
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab3AaTYh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jan 2013 14:24:37 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: /home on BTRFS on SSD, now highly fragmenting virtuoso database - use autodefrag?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <201301311444.12314.Martin@lichtvoll.de>
Date: Thu, 31 Jan 2013 12:24:34 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <4BD3FFAC-89E7-4DFA-827B-1E5180AC26CE@colorremedies.com>
References: <201301311444.12314.Martin@lichtvoll.de>
To: Martin Steigerwald <Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 31, 2013, at 6:44 AM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
> Works well so far and I see no issues.

A fragmented ssd doesn't come with the penalty of head seek latency or rotational latency, both of which increase with fragmentation on rotating media. I'm not sure what the equivalent is for SSD. Different SSD's are doing many different things behind the scene; even when not read or written to by the file system. This is one reason why TRIM is questionable. It helps for some devices and workloads, and not others.

If you check mount, if btrfs detected from the kernel that this is non-rotating media, it should have mounted it with the ssd option. The other mount option possible, which is manually set (and unsets ssd) is ssd_spread.

https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_difference_between_mount_-o_ssd_and_mount_-o_ssd_spread.3F

Chris Murphy