Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45879 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755792Ab2HNM66 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 08:58:58 -0400
Date: Tue, 14 Aug 2012 14:39:37 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] Update LZO compression
Message-ID: <20120814123937.GA14756@sig21.net>
References: <50299142.2030504@oberhumer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50299142.2030504@oberhumer.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 01:44:02AM +0200, Markus F.X.J. Oberhumer wrote:
> On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
> >
> > As stated in the README this version is significantly faster (typically more
> > than 2 times faster!) than the current version, has been thoroughly tested on
> > x86_64/i386/powerpc platforms and is intended to get included into the
> > official Linux 3.6 or 3.7 release.
> >
> > I encourage all compression users to test and benchmark this new version,
> > and I also would ask some official LZO maintainer to convert the updated
> > source files into a GIT commit and possibly push it to Linus or linux-next.

Sorry for not reporting earlier, but I didn't have time to do real
benchmarks, just a quick test on ARM926EJ-S using barebox,
and found in the new version decompression is slower:
http://lists.infradead.org/pipermail/barebox/2012-July/008268.html

BTW, do you have userspace code matching the old and new
lzo versions?  It would be easier to benchmark.

Unfortunately I cannot claim high confidence in my benchmark results
due to missing time to do it properly, it would be useful if
someone else could do some benchmarks on ARM before merging this.


Johannes
