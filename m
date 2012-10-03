Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab2JCVBh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 17:01:37 -0400
Date: Wed, 3 Oct 2012 14:01:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Johannes Stezenbach <js@sig21.net>
Subject: Re: [GIT PULL v2] Update LZO compression
Message-Id: <20121003140136.f2b071df.akpm@linux-foundation.org>
In-Reply-To: <CAFLxGvw3OqOb0UVhjtwC+CD+wtubH-O1FM7=fYFT8ztWPVPd6w@mail.gmail.com>
References: <5033A78E.3080703@oberhumer.com>
	<506C14BA.70006@oberhumer.com>
	<CAFLxGvw3OqOb0UVhjtwC+CD+wtubH-O1FM7=fYFT8ztWPVPd6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 3 Oct 2012 12:48:46 +0200
richard -rw- weinberger <richard.weinberger@gmail.com> wrote:

> CC'in akpm.

Thanks.

> >>> Hi all,
> >>>
> >>> I finally have prepared a small package that updates the LZO version
> >>> in the Linux kernel. Please get it from:
> >>>
> >>> http://www.oberhumer.com/opensource/lzo/download/Testing/linux-kernel-lzo-20120716.tar.gz
> >>>
> >>> As stated in the README this version is significantly faster (typically more
> >>> than 2 times faster!) than the current version, has been thoroughly tested on
> >>> x86_64/i386/powerpc platforms and is intended to get included into the
> >>> official Linux 3.6 or 3.7 release.
> >>>
> >>> I encourage all compression users to test and benchmark this new version,
> >>> and I also would ask some official LZO maintainer to convert the updated
> >>> source files into a GIT commit and possibly push it to Linus or linux-next.

No, lib/lzo has no identifiable maintainer.  I suggest you proceed as
follows:

- Post the entire patch series to lkml for review (I'd like a cc please)

- After that process has played out, ask Stephen to add this git tree
  to linux-next.

- After that process has played out, ask Linus to pull the tree
  during a merge window.

I haven't actually looked at the patches yet, but if they are as
extensive as they sound, it would be appropriate for you become the
formal maintainer of lib/lzo.

