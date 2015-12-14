Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34325 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbLNSLU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 13:11:20 -0500
Received: by lfcy184 with SMTP id y184so53771063lfc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Dec 2015 10:11:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZ1jVer4SF1fG6bD2c-723VXb6GfG__01NUOqG5gVqdWQ@mail.gmail.com>
References: <16063727.bYixifcRQC@merkaba>
	<1475910.a5YfPuWqAN@merkaba>
	<4738187.k1WenrURk2@merkaba>
	<2196957.diBSeBoUhe@merkaba>
	<CAPmG0jZ1jVer4SF1fG6bD2c-723VXb6GfG__01NUOqG5gVqdWQ@mail.gmail.com>
Date: Mon, 14 Dec 2015 19:11:19 +0100
Message-ID: <CAPmG0jYyPZRheVbTLTHdNhJfbRGTehPziCgeLeHayf__Opis1g@mail.gmail.com>
Subject: Re: [4.3-rc4] scrubbing aborts before finishing
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 6:31 PM, Henk Slager <eye1tm@gmail.com> wrote:
> [...]
>>> > merkaba:~> btrfs fi sh /daten
>>> > Label: 'daten'  uuid: […]
>>> >
>>> >         Total devices 1 FS bytes used 227.23GiB
>>> >         devid    1 size 230.00GiB used 230.00GiB path
> [...]
>>> > merkaba:~> btrfs fi df /daten
>>> > Data, single: total=228.99GiB, used=226.79GiB
>>> > System, single: total=4.00MiB, used=48.00KiB
>>> > Metadata, single: total=1.01GiB, used=449.50MiB
>>> > GlobalReserve, single: total=160.00MiB, used=0.00B
>
> If this is still the fill-level of the storage device, then also with
> 4.4-rcX and new enough tools it will fail I think.
> AFAIK, scrub does writes (in metadata?) so I think a non-read-only
> scrub command can't allocate space. See all other comments/threads
> w.r.t. allocated / free space.
> Especially an fs of this size, I would keep ~10% free on
> 'device-level' ( 227.23GiB would need to be 207.00GiB ) and also ~10%
> on 'chunk-level' ( 226.79GiB would need to be 186.30GiB ).
>
> Assuming you don't have snapshots, a   btrfs fi defrag -r /daten
> might give some more room short-term, after you just (re)moved files
> off the fs first.
# btrfs fi defrag -r -clzo /daten
I meant.
