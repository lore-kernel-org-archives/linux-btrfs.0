From: jim owens <jowens@hp.com>
Subject: Re: experimental branch rebased
Date: Tue, 03 Mar 2009 17:07:22 -0500
Message-ID: <49ADAA1A.6050709@hp.com>
References: <1235663145.4631.11.camel@think.oraclecorp.com> <20090226190527.GA13057@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090226190527.GA13057@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

Lee,

The 02/26/2009 version is missing some of the patches that
were in the 02/20/2009 version so it will not compile on 26.

I found the bug in the patch that breaks on 26:

+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 27)
  			if (!trylock_page(page))
+#else
+			if(!TestSetPageLocked(page))
+#endif

It should be

	if (TestSetPageLocked(page))

because pass/fail is reversed on those functions.

While I was testing, I ported back to 24 on
ubuntu and made it work with 2.6.24-23-generic
with the experimental tree from feb 25.

I will give you the 24 patches to include in your
patch as soon as you have a version that I can
rebase against the current experimental on 24/26.

jim
