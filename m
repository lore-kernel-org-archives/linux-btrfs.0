Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48809 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2FYHOZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 03:14:25 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chester <somethingsome2000@gmail.com>
Subject: Re: kernel got struck while scrubbing BTRFS with node- and leafsize 32768
Date: Mon, 25 Jun 2012 09:14:20 +0200
Cc: linux-btrfs@vger.kernel.org
References: <201206162223.20392.Martin@lichtvoll.de> <CAAE6i0hruv7t-cXCbGwCvqsVW2AfBnvEbrZUf4=YraHBgsgYVQ@mail.gmail.com> (sfid-20120625_091233_203498_B6B3A7EE)
In-Reply-To: <CAAE6i0hruv7t-cXCbGwCvqsVW2AfBnvEbrZUf4=YraHBgsgYVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206250914.21256.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 25. Juni 2012 schrieb Chester:
> On Sat, Jun 16, 2012 at 3:23 PM, Martin Steigerwald 
<Martin@lichtvoll.de> wrote:
> > [251818.022631] ------------[ cut here ]------------
> > [251818.022714] WARNING: at
> > 
> > /media/data/mattems/src/linux-2.6-3.4.1/debian/build/source_amd64_non
> > e/fs/btrfs/extent_io.c:4522 read_extent_buffer+0x43/0xf0 [btrfs]()
> > [251818.022723] Hardware name: 42433WG
> > [251818.022727] Modules linked in: rose usb_storage uas rfcomm bnep
> > btusb
> 
> I don't think btrfs supported big blocks until recently. Something
> like 3.3 or 3.4.. Anything from 2.6 would definitely not cut it.

As I reported I was using 3.4.

AFAIK it needs 3.4 for big metadata blocks.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
