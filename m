Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35036 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557AbcCNXWD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 19:22:03 -0400
Received: by mail-lb0-f170.google.com with SMTP id bc4so352204lbc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 16:22:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
References: <20160227211450.GS26042@torres.zugschlus.de>
	<CAOE4rSyPvkzjKDVoQ-7U8ay5t7Pp2qeaCqh-tFg-etmgHGEOJQ@mail.gmail.com>
	<20160305143934.GE1902@torres.zugschlus.de>
	<CAJCQCtTw1+E=X1bbGgSB-fPHDtEPUO5amFUEs4fyPmTfK4QaGw@mail.gmail.com>
	<20160313115809.GQ2334@torres.zugschlus.de>
	<20160314120703.GD2334@torres.zugschlus.de>
	<CAPmG0jbwDjf6L1-9VPCwwzqj44Th9ZHaGVcY-PhoQF=eHo5hnA@mail.gmail.com>
	<20160314200546.GG2334@torres.zugschlus.de>
	<CAPmG0jYfEnvLEHskv8uy+FjnRtv4yY8HA7bqMqZ8ScqVuAHatA@mail.gmail.com>
	<CAJCQCtQHZsvQyAfWO4HGY7Jr+PGdW5L=LUTqM+5E=ys0+Ypzqw@mail.gmail.com>
Date: Tue, 15 Mar 2016 00:22:00 +0100
Message-ID: <CAPmG0jaf7TaU2Nt3ULRm3651ByiwW-2PdYart318ceLDN7JqbQ@mail.gmail.com>
Subject: Re: New file system with same issue (was: Again, no space left on
 device while rebalancing and recipe doesnt work)
From: Henk Slager <eye1tm@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 14, 2016 at 10:59 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I'm a little mystified how btrfs check reports a problem with the
> superblock, and yet this filesystem can still be mounted and used? If
> it mounts rw then resize is possible but why would it be wrong in the
> first place?

Yes you are right. I just focussed on the 'Superblock bytenr is larger
than device size' part.
btrfs check  will actually output that text on a mounted filesystem anyhow.
The other question is: What is mounted on /media/tempdisk/  ?

At least I think a check of the current 200GiB fs is needed. As it is
a rootfs and encrypted, some work is needed to make that happen.
