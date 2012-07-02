Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55596 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2GBR6U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2012 13:58:20 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Strange directories in /
Date: Mon, 2 Jul 2012 19:58:19 +0200
Cc: Markus Rothe <markus@unixforces.net>
References: <CALi3HZrwGO9=X3RG5FfN_04jW0F7T=405pVy4BXZg_6hE4W6XQ@mail.gmail.com> (sfid-20120701_192155_286893_F48D3B0F)
In-Reply-To: <CALi3HZrwGO9=X3RG5FfN_04jW0F7T=405pVy4BXZg_6hE4W6XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201207021958.19387.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 1. Juli 2012 schrieb Markus Rothe:
> Hello,

Hi!

> I am running btrfs for a few months now. I just realized that I have a
> few strange directories in /
> 
> % ls / -1
> ?
> ???J??
>  QӇ??
> PL????
> PR????

This might be a corrupted filesystem.

Can you show ls -l /

If size is ? or permissions then its pretty clear that it is.

> Is this a known problem? I have absolutely no idea where these
> directories come from.

Anything in dmesg when you try to access any of these?

Then standard question: Which kernel?

Or try to btrfsck the fs using newest btrfs-tools. Do this with a copy of 
the device or make sure that your backup is good before.

Thats so far from a users view. A developer might have some more tricks 
for you.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
