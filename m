Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54769 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2JIT0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 15:26:16 -0400
Date: Tue, 9 Oct 2012 12:26:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 0/3] Update LZO compression
Message-Id: <20121009122614.569b9535.akpm@linux-foundation.org>
In-Reply-To: <cover.1349621096.git.markus@oberhumer.com>
References: <cover.1349621096.git.markus@oberhumer.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 7 Oct 2012 17:07:55 +0200
"Markus F.X.J. Oberhumer" <markus@oberhumer.com> wrote:

> As requested by akpm I am sending my "lzo-update" branch at
> 
>   git://github.com/markus-oberhumer/linux.git lzo-update
> 
> to lkml as a patch series created by "git format-patch -M v3.5..lzo-update".
> 
> You can also browse the branch at
> 
>   https://github.com/markus-oberhumer/linux/compare/lzo-update
> 
> and review the three patches at
> 
>   https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b734c12665a6824d219c20
>   https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c8c733131915e5ae057826
>   https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075cfa97e5c21f52275057f1

The changes look OK to me.  Please ask Stephen to include the tree in
linux-next, for a 3.7 merge.



The changelog for patch 2/3 says:

: This commit updates the kernel LZO code to the current upsteam version
: which features a significant speed improvement - benchmarking the Calgary
: and Silesia test corpora typically shows a doubled performance in
: both compression and decompression on modern i386/x86_64/powerpc machines.


There are significant clients of the LZO library - crypto, btrfs,
jffs2, ubifs, squashfs and zcache.  So let's give all those people a cc
and ask that they test the LZO changes once they land in linux-next. 
For correctness and performance, please.


