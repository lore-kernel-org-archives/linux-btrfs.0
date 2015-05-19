Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:35113 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbbESPSf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 May 2015 11:18:35 -0400
Received: by iesa3 with SMTP id a3so16332942ies.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 May 2015 08:18:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21672.5626.768161.965976@localhost.localdomain>
References: <3979684.puYLD8DjTq@merkaba>
	<21672.2859.468940.450115@localhost.localdomain>
	<2085969.4UDoZBNBiV@merkaba>
	<21672.5626.768161.965976@localhost.localdomain>
Date: Tue, 19 May 2015 11:18:34 -0400
Message-ID: <CAGfcS_kNLT0k=h6+Vpu7JO_3HQkE4Gn9vdSXM2rMsmczWGQjUw@mail.gmail.com>
Subject: Re: fstrim not working on one of three BTRFS filesystems
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Lutz Euler <lutz.euler@freenet.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 3, 2015 at 11:16 AM, Lutz Euler <lutz.euler@freenet.de> wrote:
> Martin Steigerwald wrote:
>
>> I have a 3.19-rc2 with a patch and a working fstrim now:
> [...]
>> I leave it to the patch author to come up with it on the mailing list :)
>
> That would be me. I have just sent in the patch; please see
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg40618.html
>
> For a discussion about the issue that goes into more detail than the
> commit message and the code comments please see this thread:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/15597
> At that time I had sent in a first version of this patch but it has not
> been applied so far. I made the new version as the old one did not apply
> any more since about kernel 3.9., and had a flaw (range->minlen was
> being ignored).
>
> I am using this patch on my system since two years without problems with
> kernel versions ranging from 3.3 to 3.16.
>
> Looking forward to a review,
>

Did this go anywhere?  I don't see this in 3.18.13 unless I'm missing
it, and I also have been unable to fstrim my ssd btrfs volume for as
long as I've had it on an SSD.

--
Rich
