Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v002983.home.net.pl ([212.85.107.189]:52480 "HELO
	v002983.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752125Ab2LQNTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 08:19:30 -0500
From: Hubert Kario <hka@qbs.com.pl>
To: Martin =?utf-8?B?S8WZw63FvmVr?= <martin.krizek@gmail.com>
Cc: linux-btrfs@vger.kernel.org, lczerner@redhat.com
Subject: Re: Online Deduplication for Btrfs (Master's thesis)
Date: Mon, 17 Dec 2012 14:12:38 +0100
Message-ID: <5848153.J4MMzXfUGd@bursa22>
In-Reply-To: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
References: <CAMiUzp95BXF8fcNb9EQQsrz1NpDtX9qr=FdC9C=+r3KYkYxgzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 17 of December 2012 13:05:01 Martin Křížek wrote:
> * Limitations
> Not really limitations, but this is a list of situations when dedup will
> not be triggered:
> - compression - basically, dedup is kind of compression, might be worth to
> into it in the future though

I don't see why it would be incompatible, compressed blocks are data like 
any other. COW and subvolume snapshots work with compressed nodes just as 
well as with regular ones...

> - data across subvolumes

Wasn't the "cp --reflink" across subvolumes merged to mainline quite a bit 
ago? Under 3.6.9 it works fine for me... Also, the blocks are shared between 
subvolumes if the other subvolume is a snapshot of the first one.

Besides, I think that doing a rsync from remote server and snapshotting the 
subvolume dedicated for server will be the standard approach.

Regards,
-- 
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawerów 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
