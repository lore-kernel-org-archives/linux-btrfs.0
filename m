Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48028 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753614Ab3HWA6J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 Aug 2013 20:58:09 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: Question: How can I recover this partition? (unable to find logical $hugenum len 4096)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
Date: Thu, 22 Aug 2013 18:58:05 -0600
Message-Id: <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com>
References: <79471CD1-CDDD-4EDD-B255-40568B8446E2@nickle.es> <CAKcLGm_QXTjN3e-HtogM+XXygymG+1kjhuOAMNfj=ngSHx5T5Q@mail.gmail.com> <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es> <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es> <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>, Nicholas Lee <email@nickle.es>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 22, 2013, at 4:58 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 1
> 2
> 3
> 4
> 5

6. What was the mkfs.btrfs command used? In particular are you certain the metadata profile is default (DUP)?

7. If you have a very recent btrfs-progs (few months at most), or better if you can build from btrfs-next, it may be worth running btrfsck *without* the repair option, to see what it has to say about the situation.

Chris Murphy