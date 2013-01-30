Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46884 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab3A3TKJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 14:10:09 -0500
Received: by mail-lb0-f171.google.com with SMTP id gg13so2517840lbb.16
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 11:10:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <keatr3$65q$1@ger.gmane.org>
References: <keap27$oqb$1@ger.gmane.org>
	<20130130100201.GN16285@carfax.org.uk>
	<keatr3$65q$1@ger.gmane.org>
Date: Wed, 30 Jan 2013 11:10:07 -0800
Message-ID: <CADU+-uCCGhCgUQ3yc+XCpdiU-8gTJeqs2LDxOu5g8HyiFC-7DA@mail.gmail.com>
Subject: Re: RAID 0 across SSD and HDD
From: Filipe Brandenburger <filbranden@google.com>
To: Roger Binns <rogerb@rogerbinns.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, Jan 30, 2013 at 2:49 AM, Roger Binns <rogerb@rogerbinns.com> wrote:
> It looks like my choices are:
>
> * RAID 0 and getting 500GB of usable space, with performance 50% of the
> accesses at HDD levels and 50% at SSD levels
>
> * Single and getting 750GB of usable space with performance and usage
> mostly on the HDD

You could try something like "-l=linear" on md-raid or something
similar on LVM to build a 750GB volume where the first 250GB are the
SSD and the last 500GB are the HDD. But that would probably work best
(as in, use more blocks from the beginning of the disk before moving
to the end) with a non-COW filesystem like ext4 instead of Btrfs
(although I can be wrong about that, I never really tried something
similar.)

Cheers,
Filipe
