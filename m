Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35522 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbbKYSwq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 13:52:46 -0500
Received: by lfdl133 with SMTP id l133so71382170lfd.2
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Nov 2015 10:52:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
References: <AF79907D-A36B-4806-B31A-3E327F2E5642@up4.com>
	<5654C86C.9080800@gmail.com>
	<20151124203210.GR24333@carfax.org.uk>
	<B369C8E5-3E5E-4008-BD99-C174D7ABFB36@up4.com>
Date: Wed, 25 Nov 2015 19:52:45 +0100
Message-ID: <CAPmG0jYtBFDKtQmjo=PMbrfmUb7213bu+mcWyYrxtkjwPj70+g@mail.gmail.com>
Subject: Re: btrfs check help
From: Henk Slager <eye1tm@gmail.com>
To: Vincent Olivier <vincent@up4.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[...]
> Ca I get a strong confirmation that I should run with the “—repair” option on each device? Thanks.
>
> Vincent
>
>
> Checking filesystem on /dev/sdk
> UUID: 6a742786-070d-4557-9e67-c73b84967bf5
> checking extents [o]
> checking free space cache [.]
> root 5 inode 1341670 errors 400, nbytes wrong
> root 11406 inode 1341670 errors 400, nbytes wrong
[...]

I just remember that I have seen this kind of error before; luckily, I
found the btrfs check output (august 2015) on some backup of an old
snapshot; In my case it was on a raid5 fs from november 2013, 7 small
txt files (all several 100 bytes) and the 7 errors are repeated for
about 10 snapshots. I did   # find . -inum <inode number>    to find
the files. 2 of the 7 were still in the latest/actual subvol and I
just recreated them.

The errors from the older snapshots are still there as far as I
remember from the last btrfs check I did (with kernel 4.3.0 tools
4.3.x). The fs is converted to raid10 since 3 months. As I also got
other fake errors (as in this
https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg48325.html
), I won't run a repair until I see proof that this 'errors 400,
nbytes wrong' is a risk for file-server stability.
I just see that on an archive clone fs with this 10 old snapshots
(created via send|receive), there is no error.

In your case, it is likely just 1 small file in rootvol (5) and the
same allocation in other subvol (11406), so maybe you can fix this
like I did and don't run a '--repair'
