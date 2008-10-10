From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] btrfs-progs: autotoolized and splitup into
	{libbtrfs,tools,tests}
Date: Fri, 10 Oct 2008 07:38:30 +0100
Message-ID: <1223620710.28324.95.camel@macbook.infradead.org>
References: <200810090420.49767.trapni@gentoo.org>
	 <1223589129.7861.61.camel@telesto>
	 <1223590043.28324.83.camel@macbook.infradead.org>
	 <200810100301.52995.trapni@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Eric Anopolsky <erpo41@gmail.com>, linux-btrfs@vger.kernel.org
To: Christian Parpart <trapni@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810100301.52995.trapni@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-10 at 03:01 +0200, Christian Parpart wrote:
> whether  btrfs to be using autotools or not, the other kind this patch 
> addressed seems to be more important to me: project modularization.

That makes a certain amount of sense, but should definitely be submitted
as a separate patch. And it would probably be best to generate it with
'git-diff -M' so that renamed files are shown as such. rather than
deletion and addition. That'll make your patch far more reviewable.

I'm still not convinced that third party code should be linking against
a libbtrfs just yet, but that doesn't mean it shouldn't be set up to
allow that to happen in future.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

