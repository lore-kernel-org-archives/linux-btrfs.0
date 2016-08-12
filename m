Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:45461 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbcHLIqr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Aug 2016 04:46:47 -0400
Date: Fri, 12 Aug 2016 10:14:26 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Dave T <davestechshop@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: checksum error in metadata node - best way to move root fs to
 new drive?
Message-ID: <20160812081426.GA27746@angband.pl>
References: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGdWbB5LX5KprZYQeUiyedoaN=ggPKesw9iXqFBWTuRKFn9cZQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 11, 2016 at 04:23:45PM -0400, Dave T wrote:
> 1. Can one discontinue using the compress mount option if it has been
> used previously?

The mount option applies only to newly written blocks, and even then only to
files that don't say otherwise (via chattr +c or +C, btrfs property, etc).
You can change it on the fly (mount -o remount,...), etc.

> What happens to existing data if the compress mount option is 1) added
> when it wasn't used before, or 2) dropped when it had been used.

That data stays compressed or uncompressed, as when it was written.  You can
defrag them to change that; balance moves extents without changing their
compression.

> 2. I understand that the compress option generally improves btrfs
> performance (via Phoronix article I read in the past; I don't find the
> link). Since encryption has some characteristics in common with
> compression, would one expect any decrease in performance from
> dropping compression when using btrfs on dm-crypt? (For more context,
> with an i7 6700K which has aes-ni, CPU performance should not be a
> bottleneck on my computer.)

As said elsewhere, compression can drastically help or reduce performance,
this depends on your CPU-to-IO ratio, and to whether you do small random
writes inside files (compress has to rewrite a whole 128KB block).

An extreme data point: Odroid-U2 on eMMC doing Debian archive rebuilds,
compression improves overall throughput by a factor of around two!  On the
other hand, this same task on typical machines tends to be CPU bound.

-- 
An imaginary friend squared is a real enemy.
