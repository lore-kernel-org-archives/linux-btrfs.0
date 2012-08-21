Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:57255 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2HUPV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Aug 2012 11:21:58 -0400
Message-ID: <5033A78E.3080703@oberhumer.com>
Date: Tue, 21 Aug 2012 17:21:50 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <andi@firstfloor.org>, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Johannes Stezenbach <js@sig21.net>
Subject: [GIT PULL v2] Update LZO compression
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

as suggested on the mailing list I have converted the updated LZO
code into git, so please pull my "lzo-update" branch from

  git://github.com/markus-oberhumer/linux.git lzo-update

You can browse the branch at

  https://github.com/markus-oberhumer/linux/compare/lzo-update

I'd ask some official kernel maintainer for review and to push this into
linux-next so that it will hopefully land in the 3.7 release.

Share and enjoy,
Markus

Signed-off-by: Markus F.X.J. Oberhumer <markus@oberhumer.com>


[ Changes in v2: Optimize code for CPUs with inefficient unaligned
  access => significant speed increase on ARM ]


On 2012-07-16 20:30, Markus F.X.J. Oberhumer wrote:
> Hi all,
>
> I finally have prepared a small package that updates the LZO version
> in the Linux kernel. Please get it from:
>
> http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-20120716.tar.gz
>
> As stated in the README this version is significantly faster (typically more
> than 2 times faster!) than the current version, has been thoroughly tested on
> x86_64/i386/powerpc platforms and is intended to get included into the
> official Linux 3.6 or 3.7 release.
>
> I encourage all compression users to test and benchmark this new version,
> and I also would ask some official LZO maintainer to convert the updated
> source files into a GIT commit and possibly push it to Linus or linux-next.
>
> Share and enjoy,
> Markus
>
> Signed-off-by: Markus F.X.J. Oberhumer" <markus@oberhumer.com>

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
