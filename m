Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:52530 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3KTBXm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 20:23:42 -0500
MIME-Version: 1.0
In-Reply-To: <7668D159-6B70-4DE9-A381-EFC15A77E0CC@colorremedies.com>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<528B3A6F.2010304@hesbynett.no>
	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>
	<CACJz6QtP9TXKX9ZB2J5nfLCCn0yfNExwZ-VYm-xiN53aA9vfLw@mail.gmail.com>
	<7668D159-6B70-4DE9-A381-EFC15A77E0CC@colorremedies.com>
Date: Tue, 19 Nov 2013 17:23:41 -0800
Message-ID: <CAJBj3ve+k2FUrvYJhLTGt9cJmNp7djUDQDZiYSNYzjJZ8_JLVg@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: John Williams <jwilliams4200@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 19, 2013 at 4:54 PM, Chris Murphy <lists@colorremedies.com>
wrote:
> If anything, I'd like to see two implementations of RAID 6 dual
> parity. The existing implementation in the md driver and btrfs could
> remain the default, but users could opt into Cauchy matrix based dual
> parity which would then enable them an easy (and live) migration path
> to triple parity and beyond.

Actually, my understanding is that Andrea's Cauchy matrix technique
(call it C) is compatible with existing md RAID5 and RAID6 (call these
A). It is only the non-SSSE3 triple-parity algorithm 2^-1 (call it B)
that is incompatible with his Cauchy matrix technique.

So, you can have:

1) A+B

or

2) A+C

But you cannot have A+B+C
