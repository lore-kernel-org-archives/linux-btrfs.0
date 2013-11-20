Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asav21.altibox.net ([109.247.116.8]:53235 "EHLO
	asav21.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3KTKml (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 05:42:41 -0500
Message-ID: <528C9083.5040200@hesbynett.no>
Date: Wed, 20 Nov 2013 11:35:47 +0100
From: David Brown <david.brown@hesbynett.no>
MIME-Version: 1.0
To: John Williams <jwilliams4200@gmail.com>,
        Chris Murphy <lists@colorremedies.com>
CC: Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Triple parity and beyond
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>	<528A90B7.5010905@zytor.com>	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>	<528AA1EB.3010909@zytor.com>	<528B3A6F.2010304@hesbynett.no>	<CAGKKSfX6xx2SoDeMy7QOcGgLx5ApfbOF1pvhwixwnvEktWAWUw@mail.gmail.com>	<CACJz6QtP9TXKX9ZB2J5nfLCCn0yfNExwZ-VYm-xiN53aA9vfLw@mail.gmail.com>	<7668D159-6B70-4DE9-A381-EFC15A77E0CC@colorremedies.com> <CAJBj3ve+k2FUrvYJhLTGt9cJmNp7djUDQDZiYSNYzjJZ8_JLVg@mail.gmail.com>
In-Reply-To: <CAJBj3ve+k2FUrvYJhLTGt9cJmNp7djUDQDZiYSNYzjJZ8_JLVg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/11/13 02:23, John Williams wrote:
> On Tue, Nov 19, 2013 at 4:54 PM, Chris Murphy <lists@colorremedies.com>
> wrote:
>> If anything, I'd like to see two implementations of RAID 6 dual
>> parity. The existing implementation in the md driver and btrfs could
>> remain the default, but users could opt into Cauchy matrix based dual
>> parity which would then enable them an easy (and live) migration path
>> to triple parity and beyond.

Andrea's Cauchy matrix is compatible with the existing Raid6, so there
is no problem there.

I believe it would be a terrible idea to have an incompatible extension
- that would mean you could not have temporary extra parity drives with
asymmetrical layouts, which is something I see as a very useful feature.

> 
> Actually, my understanding is that Andrea's Cauchy matrix technique
> (call it C) is compatible with existing md RAID5 and RAID6 (call these
> A). It is only the non-SSSE3 triple-parity algorithm 2^-1 (call it B)
> that is incompatible with his Cauchy matrix technique.
> 
> So, you can have:
> 
> 1) A+B
> 
> or
> 
> 2) A+C
> 
> But you cannot have A+B+C

Yes, that's right.


