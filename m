Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39323 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab3BVFz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 00:55:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1U8lcF-0000Y4-8I
	for linux-btrfs@vger.kernel.org; Fri, 22 Feb 2013 06:56:15 +0100
Received: from h59ec0710.dkvnvan.sta.perspektivbredband.net ([89.236.7.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 06:56:15 +0100
Received: from spam by h59ec0710.dkvnvan.sta.perspektivbredband.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Feb 2013 06:56:15 +0100
To: linux-btrfs@vger.kernel.org
From: Bardur Arantsson <spam@scientician.net>
Subject: Re: Another defrag question
Date: Fri, 22 Feb 2013 06:55:45 +0100
Message-ID: <kg718u$6of$1@ger.gmane.org>
References: <51264146.3070504@petaramesh.org> <1361462073.18057.23.camel@cwalton-XPS-8300> <512644DA.3050409@petaramesh.org> <20130221163844.GD14283@carfax.org.uk> <51265355.1020409@petaramesh.org> <20130221172502.GF14283@carfax.org.uk> <51265DB0.2060407@petaramesh.org> <kg61p4$jsi$1@ger.gmane.org> <20130221215602.GH27541@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20130221215602.GH27541@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/21/2013 10:56 PM, David Sterba wrote:
> On Thu, Feb 21, 2013 at 09:58:16PM +0100, Bardur Arantsson wrote:
>> On 02/21/2013 06:47 PM, Swâmi Petaramesh wrote:
>>> Le 21/02/2013 18:25, Hugo Mills a écrit :
>>>> Correct. But btrfs isn't at that stage yet. It's getting visibly
>>>> closer, but it's not quite there. Hence the very strong recommendation
>>>> to keep up with the latest code. Hugo. 
>>>
>>> The matter is that BTRFS had many early adopters just because it is -
>>> and has been for long now - in the mainline Linux kernel, so supposed
>>> stable and good choice for the future.
>>>
>>> To be honest (and not wanting to troll, promised) this is the only
>>> single reason for which I use BTRFS on 5 of my 6 machines at home - just
>>> because I thought that "Just upgrade the distro every 6 months and it
>>> will become better and better over time, no hassle, make my life easy".
>>>
>>
>> Unfortunately many distros don't make it obvious, but Btrfs is still
>> hidden behind a giant EXPERIMENTAL label in the kernel configuration.
> 
> Removed in 3.9-rc1 as a part of a broad Kconfig cleanup
> 
[--snip--]
> 
> is it still experimental then?

Interesting, but IMO having the experimental label taken off is a
necessary, but not sufficient condition for $X to be considered stable :).

Regards,

