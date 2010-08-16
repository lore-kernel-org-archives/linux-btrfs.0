From: Chris Ball <cjb@laptop.org>
Subject: Re: 2.6.36-rc1 btrfs still unstable
Date: Mon, 16 Aug 2010 12:32:47 -0400
Message-ID: <m3aaom4ixc.fsf_-_@pullcord.laptop.org>
References: <1281948382.1888.7.camel@chotu> <20100816121658.GT3315@think>
	<7222A6B8ACA37D4AA1AC37810C43E8A80F5FC5BC@mail.corp.imt-systems.com>
	<m3iq3a4l46.fsf@pullcord.laptop.org>
	<AANLkTin-q4N9g3=ymsiJy051xts3b2vioNdqku6DMEzQ@mail.gmail.com>
	<AANLkTi=7BKfWhuRE2pQjQxM5cCVEW_L0ySUXSZnoELuo@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Evert Vorster <evorster@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=7BKfWhuRE2pQjQxM5cCVEW_L0ySUXSZnoELuo@mail.gmail.com>
	(Evert Vorster's message of "Mon, 16 Aug 2010 16:11:15 +0000")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > I don't think the signboards are big enough.

Sure; that's why I tried to make one of them larger.

   > Most people assume that there is some way of fixing a broken file
   > system, and finding out the btrfs does not have one usually is
   > quite surprising and just a little too late.

Agreed, that's my experience from the IRC channel.

   > I was under the impression that with atomic writes it's
   > impossible to mess up a file system?

Yes, we're not seeing data corruption, we're correctly reporting
that the transid of the data block doesn't match the transid in the
parent node's pointer, which means that some writes went missing.
Then we're hitting a BUG() as a result, which hangs.

I don't know what the right way of dealing with this is going to be,
but answers like "pretend the lost writes never happened and sync the
transids", or "do something other than BUG() on verify_parent_transid()
failure" sound plausible.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
