Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:57448 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaLANiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 08:38:17 -0500
Received: by mail-vc0-f180.google.com with SMTP id im6so4659514vcb.11
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 05:38:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <547C6922.6030206@gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org>
	<547C6922.6030206@gmail.com>
Date: Mon, 1 Dec 2014 14:38:16 +0100
Message-ID: <CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
Subject: Re: Possible to undo subvol delete?
From: MegaBrutal <megabrutal@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Marc MERLIN <marc@merlins.org>, Shriramana Sharma <samjnaa@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2014-12-01 14:12 GMT+01:00 Austin S Hemmelgarn <ahferroin7@gmail.com>:
>
> We might want to consider adding an option to btrfs subvol del to ask for
> confirmation (or make it do so by default and add an option to disable
> asking for confirmation).
>

I've also noticed, a subvolume can just be deleted with an "rm -r",
just like an ordinary directory. I'd consider to only allow subvolume
deletions with exact "btrfs subvolume delete" commands, and they
should be protected against an ordinary "rm". There also could be a
tunable FS feature to allow or disable ordinary subvolume deletions,
which could be set or unset by btrfstune. I think a subvolume really
deserves to be treated specially over an ordinary directory.

As for undeletion, while I have no idea how to do that, I noticed they
don't get deleted immediately. With older btrfs tools (3.12), I
noticed, if I delete a subvolume and then immediately issue a "btrfs
subvolume list", my deleted subvolume is still listed with a "DELETED"
caption, and allocated space doesn't immediately gets freed if I check
with "df -m". It takes a few seconds for the DELETED entry to
disappear and the allocated space to be freed.
