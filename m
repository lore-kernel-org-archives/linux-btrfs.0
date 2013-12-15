Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:46168 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750821Ab3LOUmI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 15:42:08 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: moving a subvol
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52ADE972.4000303@gmail.com>
Date: Sun, 15 Dec 2013 13:42:03 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <7213A6E1-3601-48A1-96F9-E02A03FF42D2@colorremedies.com>
References: <52AB30D4.7050408@czarc.net> <6EDC30B8-CF2C-42FA-9E30-D9F4B0804152@colorremedies.com> <52AB5F2E.8020209@czarc.net> <1663965.RJ0nqNbRyM@quad> <52AC2B90.909@czarc.net> <772D6056-AD90-4B98-AAC8-E0C866E6F714@colorremedies.com> <52ADE972.4000303@gmail.com>
To: Gene Czarcinski <gczarcinski@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 15, 2013, at 10:40 AM, Gene Czarcinski <gczarcinski@gmail.com> wrote:

> On 12/14/2013 01:43 PM, Chris Murphy wrote:
>> On Dec 14, 2013, at 2:57 AM, Gene Czarcinski <gczarcinski@gmail.com> wrote:
>>>  Since I run Fedora with anaconda I use kickstart installs and can easily repeat an install since it included almost everything I want installed.  And then I have a post-install script I run to pickup additional stuff.
>> This is a bit of a hijack question, but does kickstart offer a way to mount Btrfs with compression option?
>> 
>> 
>> Chris Murphy
> Interesting; it does not "currently" but that sounds like it should be (RFE time) an added option so that it would be in fstab from the start.  It may not be that simple since if you specify compression for a subvolume, that means that everything anaconda installs on the subvolume should be subjected to compression and not just stuff written post-install.

It needs to be mounted with the option prior to installation, and also needs to be added to the fstab.
> 
> I do not currently use compression but I should give it a try.
> 
> Chris, since I know kickstart and you do not, I will BZ the RFE. BTW, is this an option on the regular GUI install?

No, and I'm not finding it in any of the code for kickstart or anaconda GUI. My recollection is that if it was brought into the GUI it wasn't going to offer any choice of compression algorithm, it would use the Btrfs default. Currently that's zlib, which I think maybe isn't the best default choice because while it offers higher compression ratio over lzo, it's slower to compress and decompress. HDD space is cheap, the benefit of compression isn't so much saving space as it is to make r/w faster. In all of my tests LZO does this better. I *think* Snappy is better still than LZO, but that's not yet an option.

Chris Murphy