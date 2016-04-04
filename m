Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:36063 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbcDDAvI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Apr 2016 20:51:08 -0400
Received: by mail-ig0-f171.google.com with SMTP id f1so51692072igr.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Apr 2016 17:51:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160404001925.2abc2649@jupiter.sol.kaishome.de>
References: <20160331224452.0753d5c7@jupiter.sol.kaishome.de>
	<CAPmG0jZ6hs4TA_0ozNEP4x6ucn971Nj-6+uempGi1VwTWAdCYQ@mail.gmail.com>
	<20160402110001.0ec354b5@jupiter.sol.kaishome.de>
	<CAPmG0jaJdS26ABbC3Rz_D_FDfCKq8mYMHhmFwqhWYpDRdyFQhw@mail.gmail.com>
	<20160402221634.2e3dc71c@jupiter.sol.kaishome.de>
	<CAJCQCtQ+RnQqghDs060hrLJ850e0n=FiKNn9W8UuUP3DQV9u5g@mail.gmail.com>
	<20160403060202.03e67651@jupiter.sol.kaishome.de>
	<pan$2593b$f74bb320$4b6df891$663eb0b@cox.net>
	<20160404001925.2abc2649@jupiter.sol.kaishome.de>
Date: Sun, 3 Apr 2016 18:51:07 -0600
Message-ID: <CAJCQCtTjoQ93wiMRgzHJ+3D_GPwygK1EzGPCFyKdoi1=Mjip_w@mail.gmail.com>
Subject: Re: btrfsck: backpointer mismatch (and multiple other errors)
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 3, 2016 at 4:19 PM, Kai Krakow <hurikhan77@gmail.com> wrote:

> BTW: Is it possible to use my backup drive (it's btrfs single-data
> dup-metadata, single device) as a seed device for my newly created
> btrfs pool (raid0-data, raid1-metadata, three devices)?

Yes.

I just tried doing the conversion to raid1 before and after seed
removal, but with the small amount of data (4GiB) I can't tell a
difference. It seems like -dconvert=raid with seed still connected
makes two rw copies (i.e. there's a ro copy which is the original, and
then two rw copies on 2 of the 3 devices I added all at the same time
to the seed), and the 'btrfs dev remove' command to remove the seed
happened immediately, suggested the prior balances had already
migrated copies off the seed. This may or may not be optimal for your
case.

Two gotchas.

I ran into this bug:
btrfs fi usage crash when volume contains seed device
https://bugzilla.kernel.org/show_bug.cgi?id=115851

And there is a phantom single chunk on one of the new rw devices that was added.
Data,single: Size:1.00GiB, Used:0.00B
   /dev/dm-8       1.00GiB

It's still there after the -dconvert=raid1 and separate -mconvert=raid
and after seed device removal. A balance start without filters removes
it, chances are had I used -dconvert=raid1,soft it would have vanished
also but I didn't retest for that.


> I guess the
> seed source cannot be mounted or modified...

?



-- 
Chris Murphy
