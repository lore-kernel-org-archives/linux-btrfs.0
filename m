Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:47609 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932384AbbJNVQu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 17:16:50 -0400
Subject: Re: RAID6 stable enough for production?
To: Donald Pearson <donaldwhpearson@gmail.com>
References: <2402569.dCkKzGyGNU@hoefnix>
 <CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
 <561EBC3D.8060004@bouton.name>
 <CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
Cc: Sjoerd <sjoerd@sjomar.eu>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <561EC640.1060106@bouton.name>
Date: Wed, 14 Oct 2015 23:16:48 +0200
MIME-Version: 1.0
In-Reply-To: <CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14/10/2015 22:53, Donald Pearson a écrit :
> I've used it from 3.8 something to current, it does not handle drive
> failure well at all, which is the point of parity raid. I had a 10disk
> Raid6 array on 4.1.1 and a drive failure put the filesystem in an
> irrecoverable state.  Scrub speeds are also an order of magnitude or
> more slower in my own experience.  The issue isn't filesystem
> read/write performance, it's maintenance and operation.

Thanks, I'll proceed with caution...
When 3.19 got out I tried various tests with loopback devices in RAID6
(dd if=/dev/random in the middle of one loopback device guaranteed to
have file data while using the filesystem for example) and didn't manage
to break it but it was arguably simple situations (either missing device
or corrupted data on device, not something behaving really erratically
like failing hardware).

Lionel
