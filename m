From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can't write much data on a degraded mirror
Date: Sat, 10 Mar 2012 19:24:27 +0000 (UTC)
Message-ID: <pan.2012.03.10.19.24.27@cox.net>
References: <20268.13021.256682.485482@localhost.localdomain>
	<4F5B9B0C.3010504@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Philipp posted on Sat, 10 Mar 2012 19:18:52 +0100 as excerpted:

> Is there any way to willingly write more data to a degraded array? There
> are other use cases for such a possibility as well. Just think of
> migrating from software raid (and lvm) based setup.

It's probably a bug in the current code.  Given that btrfs is 
experimental, only fit for test data at this time, that's not 
surprising.  I'd expect it to work properly by the time the experimental 
label comes off, and probably some time before that, just not now, at 
least in the cases you two are hitting.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

