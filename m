Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moltke.seatribe.se ([178.63.100.209]:42833 "EHLO
	moltke.seatribe.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab3BOD5J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Feb 2013 22:57:09 -0500
Date: Fri, 15 Feb 2013 04:56:55 +0100 (CET)
From: Fredrik Tolf <fredrik@dolda2000.com>
To: Chris Murphy <lists@colorremedies.com>
cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Rebalancing RAID1
In-Reply-To: <0716DBBF-5B83-4211-A038-81C84621FCD5@colorremedies.com>
Message-ID: <alpine.DEB.2.02.1302150455570.8810@shack.dolda2000.com>
References: <alpine.DEB.2.02.1302122348460.8810@shack.dolda2000.com> <C8ECD52F-F362-49CD-A3E3-627AF13CF180@colorremedies.com> <alpine.DEB.2.02.1302130711400.8810@shack.dolda2000.com> <5EEA9264-5DCA-4A3F-B305-F3E64E9A3CC5@colorremedies.com>
 <alpine.DEB.2.02.1302140733070.8810@shack.dolda2000.com> <17E4F30E-2945-44FE-A87F-0F475DFD794F@colorremedies.com> <alpine.DEB.2.02.1302140830310.8810@shack.dolda2000.com> <2D5AAB44-9DA8-460D-9141-3544DE6C45D7@colorremedies.com> <20130214085925.GD28997@carfax.org.uk>
 <19ABBC76-F774-4225-87A4-73A4D546F53F@colorremedies.com> <alpine.DEB.2.02.1302150447540.8810@shack.dolda2000.com> <0716DBBF-5B83-4211-A038-81C84621FCD5@colorremedies.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 14 Feb 2013, Chris Murphy wrote:
> On Feb 14, 2013, at 8:50 PM, Fredrik Tolf <fredrik@dolda2000.com> wrote:
>
>>
>> So it's either from btrfs, or from the buffer cache, and seeing as how it appears with other btrfs messages, I'd be willing to bet on the former. :)
>
> Unclear. Google searches reveal this identical error comes up in non-btrfs contexts. I'd like to think that if it's kernel-btrfs related that it would get tagged as kerne: blah btrfs: lost page blah.

It appears to me that the bulk of the containing function has been 
copy-pasted from buffer.c, so that's probably why the messages are 
identical.

As you could see from the source code I quoted, the message was, in fact, 
not prepended with "btrfs: ".

--

Fredrik Tolf
