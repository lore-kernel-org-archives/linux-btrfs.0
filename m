Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34811 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934695AbcCOMPu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 08:15:50 -0400
Received: by mail-lb0-f175.google.com with SMTP id k12so19896020lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 05:15:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160315071611.GL2334@torres.zugschlus.de>
References: <CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<20160314120703.GD2334@torres.zugschlus.de>
	<CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
	<20160314200546.GG2334@torres.zugschlus.de>
	<CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
	<CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
	<CAPmG0jaf7TaU2Nt3ULRm3651ByiwW-2PdYart318ceLDN7JqbQ@mail.gmail.com>
	<20160315071611.GL2334@torres.zugschlus.de>
Date: Tue, 15 Mar 2016 13:15:33 +0100
Message-ID: <CAPmG0jb1QMCqG9HdouzTntgwzKbcLmZtNmRSAN876x5-kT9Chg@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 15, 2016 at 8:16 AM, Marc Haber <mh+linux-btrfs@zugschlus.de> wrote:
> On Tue, Mar 15, 2016 at 12:22:00AM +0100, Henk Slager wrote:
>> The other question is: What is mounted on /media/tempdisk/  ?
>
> The "old" btrfs filesystem "ofanbtr", formerly 417 GB in size, now
> resized to 300 GB. Does it need to be umounted to be checked?

Yes, that's the whole point

>> At least I think a check of the current 200GiB fs is needed. As it is
>> a rootfs and encrypted, some work is needed to make that happen.
>
> You suggested a btrfs check after looking at the image of "ofanbtr".
> Do you want me to check the new "fanbtr" also?

I was not sure if 'ofanbtr' is an image created by btrfs-image or a
extra dd created image you might have locally. Both 'ofanbtr' and
'fanbtr' have the same balance issue, but 'fanbtr' is created with
newer and known kernel+tools version I assume, so that's why the
suggestion.
