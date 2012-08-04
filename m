Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51102 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2HDJ0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 Aug 2012 05:26:14 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: no space left on device
Date: Sat, 4 Aug 2012 11:26:12 +0200
Cc: Mark Marshall <markmarshall8@gmail.com>
References: <CAEuwOw4sABKXS3oJpFZPq9xpbbuNxZeTRN7UUQBjcGkiHCAqeQ@mail.gmail.com> (sfid-20120803_140824_410862_9CFBCC8B)
In-Reply-To: <CAEuwOw4sABKXS3oJpFZPq9xpbbuNxZeTRN7UUQBjcGkiHCAqeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201208041126.12533.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 3. August 2012 schrieb Mark Marshall:
> Hi,

Hi Mark,

> I am new to btrfs, and just installed a new system with SLED 11 SP2 a
> few days ago.

Now you have a nice SLED 11 SP 2 with official BTRFS support from SUSE. 
Did you consider to ask SUSE support? ;)

> However the system seems to be in a real sad state now, saying there
> is no free space left on the device even though there is about 8GB
> left on the / filesystem.
> 
> A defragment works sometimes but then it goes back to the original
> state a day or two later. Other times the command just won't respond.
> 
> I've had this happen with 2-3 systems now, is there a solution? I
> can't keep going around to users machines and defragmenting all the
> time !

First read and understand

https://btrfs.wiki.kernel.org/index.php/FAQ#Aaargh.21_My_filesystem_is_full.2C_and_I.27ve_put_almost_nothing_into_it.21

plus the following FAQs in there.

Then come back with more information.

Possible a btrfs balance will work to make some trees smaller, but this 
depends on the current state of your BTRFS. The information you provided 
is not nearly enough for an exact diagnosis. A defragment likely won´t 
help tough.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
