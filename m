Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:65380 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMVWR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Oct 2014 17:22:17 -0400
Received: by mail-lb0-f182.google.com with SMTP id z11so7167050lbi.27
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 14:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
References: <543450DC.90504@prnet.org>
	<1412714780.2374.0@mail.thefacebook.com>
	<543A61EE.7070200@prnet.org>
	<CAGfcS_k7Y2-j3moyFw3j0gzb6Xuj-AutfjvZzEnpMem-z0KPRA@mail.gmail.com>
	<543C35C3.9070002@prnet.org>
	<CANg_oxytS04xrVLfWzgz7sJZBArJ-HM8nGADF+ujjRy8heYjqQ@mail.gmail.com>
	<CAGfcS_mtYg6OSggo+t5ksxafOn0hxhtsO86k924RA55XqxzGQQ@mail.gmail.com>
Date: Mon, 13 Oct 2014 23:22:15 +0200
Message-ID: <CANg_oxz7Kpp8ppTn0jg8aeHcrpoakO6mAcHkv9Nnn9ms4M-2rQ@mail.gmail.com>
Subject: Re: btrfs random filesystem corruption in kernel 3.17
From: john terragon <jterragon@gmail.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>
Cc: David Arendt <admin@prnet.org>, Chris Mason <clm@fb.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using "compress=no" so compression doesn't seem to be related, at
least in my case. Just read-only snapshots on 3.17 (although I haven't
tried 3.16).

John
