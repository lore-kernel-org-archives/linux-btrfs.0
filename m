Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44924 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaJMV1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 17:27:47 -0400
Message-ID: <543C4343.30903@prnet.org>
Date: Mon, 13 Oct 2014 23:25:23 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: john terragon <jterragon@gmail.com>,
        Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
References: <543450DC.90504@prnet.org>	<1412714780.2374.0@mail.thefacebook.com>	<543A61EE.7070200@prnet.org>	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>	<543C35C3.9070002@prnet.org>	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com> <CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
In-Reply-To: <CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm also using no compression.

On 10/13/2014 11:22 PM, john terragon wrote:
> I'm using "compress=no" so compression doesn't seem to be related, at
> least in my case. Just read-only snapshots on 3.17 (although I haven't
> tried 3.16).
>
> John

