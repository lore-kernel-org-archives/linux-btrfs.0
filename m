Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.servus.at ([193.170.194.20]:36604 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2JITzQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 15:55:16 -0400
Message-ID: <50748113.80408@oberhumer.com>
Date: Tue, 09 Oct 2012 21:54:59 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Johannes Stezenbach <js@sig21.net>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/3] Update LZO compression
References: <cover.1349621096.git.markus@oberhumer.com> <20121009122614.569b9535.akpm@linux-foundation.org>
In-Reply-To: <20121009122614.569b9535.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Stephen,

On 2012-10-09 21:26, Andrew Morton wrote:
> On Sun, 7 Oct 2012 17:07:55 +0200
> "Markus F.X.J. Oberhumer" <markus@oberhumer.com> wrote:
> 
>> As requested by akpm I am sending my "lzo-update" branch at
>>
>>   git://github.com/markus-oberhumer/linux.git lzo-update
>>
>> to lkml as a patch series created by "git format-patch -M v3.5..lzo-update".
>>
>> You can also browse the branch at
>>
>>   https://github.com/markus-oberhumer/linux/compare/lzo-update
>>
>> and review the three patches at
>>
>>   https://github.com/markus-oberhumer/linux/commit/7c979cebc0f93dc692b734c12665a6824d219c20
>>   https://github.com/markus-oberhumer/linux/commit/10f6781c8591fe5fe4c8c733131915e5ae057826
>>   https://github.com/markus-oberhumer/linux/commit/5f702781f158cb59075cfa97e5c21f52275057f1
> 
> The changes look OK to me.  Please ask Stephen to include the tree in
> linux-next, for a 3.7 merge.

I'd ask you to include my "lzo-update" branch in linux-next:

  git://github.com/markus-oberhumer/linux.git lzo-update

> The changelog for patch 2/3 says:
> 
> : This commit updates the kernel LZO code to the current upsteam version
> : which features a significant speed improvement - benchmarking the Calgary
> : and Silesia test corpora typically shows a doubled performance in
> : both compression and decompression on modern i386/x86_64/powerpc machines.
> 
> There are significant clients of the LZO library - crypto, btrfs,
> jffs2, ubifs, squashfs and zcache.  So let's give all those people a cc
> and ask that they test the LZO changes once they land in linux-next. 
> For correctness and performance, please.

The core compression and decompression code has been thoroughly tested, so I
do not expect major problems.

Good testing after the merge and feedback about build or performance issues
(and improvements!) is highly appreciated.

Many thanks,
Markus

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
