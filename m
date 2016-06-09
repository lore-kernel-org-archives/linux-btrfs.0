Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:45278 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbcFIIwS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Jun 2016 04:52:18 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1bAvhJ-0002UU-4r
	for linux-btrfs@vger.kernel.org; Thu, 09 Jun 2016 10:52:17 +0200
Date: Thu, 9 Jun 2016 10:52:17 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
Message-ID: <20160609085217.GL5171@torres.zugschlus.de>
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5758A5F6.4060400@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5758A5F6.4060400@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 09, 2016 at 01:10:46AM +0200, Hans van Kranenburg wrote:
> So, instead of being the cause, apt-get update causing a new chunk to be
> allocated might as well be the result of existing ones already filled up
> with too many fragments.
> 
> The next question is what files these extents belong to. To find out, I need
> to open up the extent items I get back and follow a backreference to an
> inode object. Might do that tomorrow, fun.

Does your apt use pdiffs to update the packages lists? If yes, I'd try
turning it off just for the fun of it and to see whether this changes
btrfs' allocation behavior. I have never looked at apt's pdiff stuff
in detail, but I guess that it creates many tiny temporary files.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
