Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:1315 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757445Ab3KHRWX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Nov 2013 12:22:23 -0500
Received: from 105-34-agavebb-nm.abq.nm.agavebb.net ([199.21.105.34]:56249 helo=[10.1.8.1])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VeplE-000MYc-Ey
	for linux-btrfs@vger.kernel.org; Fri, 08 Nov 2013 10:22:20 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How to fix/remove "csum failed ino" error
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131108081307.GQ14405@carfax.org.uk>
Date: Fri, 8 Nov 2013 10:22:20 -0700
Message-Id: <3BAA20A8-9BCC-43AB-A1B9-4E79D3221EE5@colorremedies.com>
References: <CAOMFOmUDd0jS=R+MAVwfwmNj7Bt9VUM46b8zYmC59BA65qhUfA@mail.gmail.com> <CAC4gV=7FgL=wixYf6w-yfuZNbz8QCt5t9T8_jStjpkKgTBc+Vw@mail.gmail.com> <CAOMFOmXj=-8g6hYs_qcj417OUmgLEGdms2kMzUdorCuxJ7292w@mail.gmail.com> <CAOMFOmWee0NX=ZmcdG2FpkKyu-XLC5druy-Cn5+6ZAZa34WdZg@mail.gmail.com> <CAC4gV=6yDhYHfWHOer_uVYZ8dgCQ5C=7JXkN3rpkXs=tH_jPZQ@mail.gmail.com> <151A7826-2EA1-45F5-8FAD-EC79FA7F08CE@colorremedies.com> <20131108081307.GQ14405@carfax.org.uk>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 8, 2013, at 1:13 AM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Thu, Nov 07, 2013 at 10:56:10PM -0700, Chris Murphy wrote:
>> What's the kernel and btrfs progs version?
>> 
>> I wish the dmesg errors were more explicit about the nature of checksum errors: do the two metadata checksums mismatch each other (one of them matches with data), or the metadata checksums match each other but mismatch with data?
> 
>   If there's two copies, and one fails the checksum and the other
> passes, then there will be a note following the failure that it
> read the other checksum and succeeded, and repaired the problem.

OK I guess that's fairly explicit. And a more explicit message that data is corrupt in the current case, is maybe the wrong thing to do because all we know is data checksum doesn't match what's stored in metadata. We don't actually know the significance of the data corruption.

A bigger problem that was brought up a while ago is if we still have a way to read data that fails checksum, so we can attempt application level reconstruction. I'm also not seeing in the original report, any kernel messages that show what files (by path) have been affected which also makes understanding of the error messages less than clear.

Chris Murphy