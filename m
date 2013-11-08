Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:29333 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750786Ab3KHF4j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 00:56:39 -0500
Received: from c-68-35-125-242.hsd1.nm.comcast.net ([68.35.125.242]:49293 helo=[192.168.1.140])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1Vef3T-000GkF-Sr
	for linux-btrfs@vger.kernel.org; Thu, 07 Nov 2013 22:56:33 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to fix/remove "csum failed ino" error
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
Date: Thu, 7 Nov 2013 22:56:10 -0700
Message-Id: <151A7826-2EA1-45F5-8FAD-EC79FA7F08CE@colorremedies.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com> <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com> <CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com> <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com> <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What's the kernel and btrfs progs version?

I wish the dmesg errors were more explicit about the nature of checksum errors: do the two metadata checksums mismatch each other (one of them matches with data), or the metadata checksums match each other but mismatch with data?

Hopefully I'm mistaken, but it looks in this case that the data is actually corrupt, not the metadata. In which case repair would only be possible for raid1 or raid10 data profiles.

Why the corruption occurred depends on kernel and btrfs-progs versions, and what you were doing prior to the corruption so dmesg prior to the corruption would be needed and also when trying to mount with the recovery option so it might be worth:

dmesg
[note the last time entry]
dmesg -n7
btrfs mount -o recovery <dev> <mp>
dmesg

report results since the previously noted last time entry


Chris Murphy