Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:53029 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933010Ab2KAPs1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Nov 2012 11:48:27 -0400
Message-ID: <509299C9.7050509@jan-o-sch.net>
Date: Thu, 01 Nov 2012 16:48:25 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "ablock84@googlemail.com" <ablock84@googlemail.com>,
        "sensille@gmx.net" <sensille@gmx.net>
Subject: Re: [PATCH 0/2] Btrfs-progs: urgent fixes for btrfs send
References: <1351782086-23435-1-git-send-email-list.btrfs@jan-o-sch.net> <20121101150710.GA21281@shiny>
In-Reply-To: <20121101150710.GA21281@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, November 01, 2012 at 16:07 (+0100), Chris Mason wrote:
> On Thu, Nov 01, 2012 at 09:01:24AM -0600, Jan Schmidt wrote:
>> Hi everybody,
>>
>> We made a bad mistake with "btrfs send" command line arguments and we'd
>> better fix it before it's being widely used (read: *now*).
> 
> Ok, I do agree that -i was confusing.  I didn't end up using it in my
> backup scripts here.

Good we agree here :-)

> How about:
> 
> Make -p and -i mean the same thing.  Add -r for what -i should have
> done.  
> 
> This has the advantage of not breaking the people that did get working
> btrfs send setups ;)

I'd carefully argue that we're still in the position to break things, because
the 3.7 kernel isn't released and you cannot use "btrfs send" without it. The
number of users should be really small.

I prefer having a clean and painful cut over suffering from bad decisions
forever. That may not be the most popular opinion in the world. In the end, I
could live with -p and -i doing the same thing.

-Jan
