Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:62328 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaHDNRo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Aug 2014 09:17:44 -0400
Received: by mail-we0-f179.google.com with SMTP id u57so7810396wes.10
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 06:17:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140804113231.GD31950@carfax.org.uk>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com>
 <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
 <17833067.mzxAL4oqZq@quad> <CAFChkqs3LOM4HmDzpXgs6YTeoXvyNPbsNWCPf74=_MnPneJ+HQ@mail.gmail.com>
 <20140804102206.GA31950@carfax.org.uk> <CAFvQSYRDz1EW4CiKbRNEp0HKhciHPM+b_63CrOOko+D6aYPnvw@mail.gmail.com>
 <20140804113231.GD31950@carfax.org.uk>
From: Peter Waller <peter@scraperwiki.com>
Date: Mon, 4 Aug 2014 14:17:02 +0100
Message-ID: <CAFChkqv3N27jWxL=URgkZ1G86BFBo+-Cmg9emOO3G80OKY2n4g@mail.gmail.com>
Subject: Re: ENOSPC with mkdir and rename
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For anyone else having this problem, this article is fairly useful for
understanding disk full problems and rebalance:

http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html

It actually covers the problem that I had, which is that a rebalance
can't take place because it is full.

I still am unsure what is really wrong with this whole situation. Is
it that I wasn't careful to do a rebalance when I should have been
doing? Is it that BTRFS doesn't do a rebalance automatically when it
could in principle?

It's pretty bad to end up in a situation (with spare space) where the
only way out is to add more storage, which may be impractical,
difficult or expensive.

The other thing that I still don't understand I've seen repeated in a
few places, from the above article:

"because the filesystem is only 55% full, I can ask balance to rewrite
all chunks that are more than 55% full"

Then he uses `btrfs balance start -dusage=55 /mnt/btrfs_pool1`. I
don't understand the relationship between "the FS is 55% full" and
"chunks more than 55% full". What's going on here?

I conclude that now since I have added more storage, the rebalance
won't fail and if I keep rebalancing from a cron job I won't hit this
problem again (unless the filesystem fills up very fast! what then?).
I don't know however what value to assign to `-dusage` in general for
the cron rebalance. Any hints?
