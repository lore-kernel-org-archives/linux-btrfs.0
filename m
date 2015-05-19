Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49602 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbbESNQb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 09:16:31 -0400
Message-ID: <555B37AC.6090307@gmx.de>
Date: Tue, 19 May 2015 15:16:28 +0200
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: linux-btrfs@vger.kernel.org
Subject: Re: shall I use BTRFS sub-volumes for top-level directories ?
References: <55535C12.3010807@gmx.de> <1431539167.9076.9.camel@kepstin.ca>
In-Reply-To: <1431539167.9076.9.camel@kepstin.ca>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/13/2015 07:46 PM, Calvin Walton wrote:
> As with all things, it's probably best if you just try it and see!

After the a week both the iowait spikes and the mean value of iowait cycles are decreased - so it was worth here to switch to btrfs subvolumes.

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
--
"; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
