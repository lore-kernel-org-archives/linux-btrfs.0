Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3CKR0B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Mar 2013 13:26:01 -0400
Date: Mon, 11 Mar 2013 18:25:59 +0100
From: David Sterba <dsterba@suse.cz>
To: Clemens Eisserer <linuxhippy@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Creating zero-filled file aborts after 20GB in a 4GB volume with
 compress=lzo
Message-ID: <20130311172559.GE7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAFvQSYSONvdw7U+UZ_fxe-6=OALvWmaZiF=7+JE=vV0A6_z3uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFvQSYSONvdw7U+UZ_fxe-6=OALvWmaZiF=7+JE=vV0A6_z3uw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 04:16:34PM +0100, Clemens Eisserer wrote:
> When running ...
> 
> > dd if=/dev/zero of=testfile bs=1M
> 
> on a compressed btrfs volume of 4GB mounted with compress=lzo, dd
> aborts after about 20GB written.

# mkfs 4g
# dd if=/dev/zero of=testfile bs=1M
dd: writing `testfile': No space left on device
58623787008 bytes (59 GB) copied, 154.548 s, 379 MB/s
# btrfs fi df .
Data: total=2.04GB, used=1.71GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=204.75MB, used=77.56MB
Metadata: total=8.00MB, used=0.00
# pretty $(filesize testfile)
58,623,787,008 bytes (54.6 GiB)

I'm not sure why the enospc came so early (never seen that before *cough*),
maybe the other tests running in parallel, so a usuall

# cat /dev/zero > zerofill
cat: write error: No space left on device
# pretty $(filesize zerofill)
47648243712 bytes (44.4 GiB)

# btrfs fi df .
Data: total=3.32GB, used=3.10GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=332.75MB, used=144.19MB
Metadata: total=8.00MB, used=0.00

Now that looks like a full fs, with ~100GB worth of compressed zeros.

> As I don't think this can be attributed to metadata consumed ... Any
> ideas why lzo achieves such a poor ratio for even highly compressible
> data?

What does your 'fi df' report before and after the test?

david
