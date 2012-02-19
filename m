From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sun, 19 Feb 2012 01:53:37 +0100
Message-ID: <CAFvQSYTthK8AxAKGeU8aP1cm5nYpQ4pr3i3a2X4iArRZbK_QYg@mail.gmail.com>
References: <20120130003754.GD4380@merlins.org>
	<4F384FAA.5060506@redhat.com>
	<20120213001400.GD31989@merlins.org>
	<201202181349.23385.Martin@lichtvoll.de>
	<201202181339.24502.Martin@lichtvoll.de>
	<20120218160702.GB32373@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120218160702.GB32373@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

> "-o discard" is supported, but can have some negative consequences on
> performance on some SSDs or at least whether it adds worthwhile performance
> is up for debate ....

The problem is, that TRIM can't be benchmarked in a traditional way -
by running one run with TRIM and another one without and later
comparing numbers.
Sure, enabling TRIM causes your benchmarks to run a bit slower in the
first place (as the TRIM commands need to be generated and interpreted
by the SSD, which is not free) - however without TRIM the SSD won't
have any clue what data is "dead" and what needs to be rescued until
you overwrite it.

On my SandForce SSD I had disabled TRIM (because those drives are
known for the good recovery without TRIM), and for now the SSD is in
the following state:

dd oflag=sync if=/some_large_file_in_page_cache of=testfile bs=4M
567558236 bytes (568 MB) copied, 23.7798 s, 23.9 MB/s

233 SandForce_Internal      0x0000   000   000   000    Old_age
Offline      -       3968
241 Lifetime_Writes_GiB     0x0032   000   000   000    Old_age
Always       -       1280


So that drive is writing at 24mb/s and has a write amplification of
3.1 - usually you see values between one and two.
Completly "normal" desktop useage.

- Clemens
