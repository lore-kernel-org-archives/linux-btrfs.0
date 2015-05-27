Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37683 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbE0UZb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 May 2015 16:25:31 -0400
Received: by wifw1 with SMTP id w1so36760719wif.0
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2015 13:25:30 -0700 (PDT)
Received: from Arch-1 (p3E9EE884.dip0.t-ipconnect.de. [62.158.232.132])
        by mx.google.com with ESMTPSA id b10sm5317659wic.1.2015.05.27.13.25.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 May 2015 13:25:29 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Message-ID: <1432758326.4187.135.camel@googlemail.com>
Subject: Re: Got 10 csum errors according to dmesg but 0 errors according to
 dev stats
To: linux-btrfs@vger.kernel.org
Date: Wed, 27 May 2015 22:25:26 +0200
In-Reply-To: <pan$9da5d$8559e11b$1dc0dccb$67ad3c9d@cox.net>
References: <554F6D43.2060806@googlemail.com>
	 <554F7232.9080804@googlemail.com> <5557F490.5000606@googlemail.com>
	 <pan$f32b4$a31b2df$ac4903ed$b7bd68b4@cox.net>
	 <1432385390.4187.15.camel@googlemail.com>
	 <pan$9da5d$8559e11b$1dc0dccb$67ad3c9d@cox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2015-05-23 at 16:52 +0000, Duncan wrote:
> Philip Seeger posted on Sat, 23 May 2015 14:49:50 +0200 as excerpted:
> 
> > Is this a known side effect, that files could get corrupted if no
> > balance is run (not counting the balance with 4.0 which doesn't 
> > work due
> > to that commit) after an ext4 conversion?
> 
> I'm not sure.
> 
> What I am sure of is that I'd not trust a btrfs converted from ext* 
> until 
> the saved subvol is deleted, and a defrag and balance run.  Even 


I agree. I did delete the saved subvolume right away, but given that I
effectively did not run a balance (due to this bug, the balance had no
effect) and then had new files corrupted (repeatedly) as a consequence
makes this pretty clear.

Maybe there should be a warning in the wiki ("run a complete balance
before you start using the converted fs, otherwise your files might get
corrupted.")?

Though I'd be more interested in some details as to how this might have
happened. It seems wrong that corruption occurs after a successful
conversion (before a proper balance). Is there anyone else who has had
this issue? Maybe someone who's converted to btrfs, using a btrfs
version with the balance bug?



Philip
