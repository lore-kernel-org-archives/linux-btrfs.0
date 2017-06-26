Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54508 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751960AbdFZQyi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 12:54:38 -0400
From: Nick Terrell <terrelln@fb.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Adam Borowski <kilobyte@angband.pl>
CC: Kernel Team <Kernel-team@fb.com>, Chris Mason <clm@fb.com>,
        Yann Collet <cyan@fb.com>,
        "squashfs-devel@lists.sourceforge.net"
        <squashfs-devel@lists.sourceforge.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: Add zstd support
Date: Mon, 26 Jun 2017 16:54:17 +0000
Message-ID: <75E6EA5F-65F2-4218-A519-FB9377818FF0@fb.com>
References: <20170622220139.2328978-3-terrelln@fb.com>
 <201706260238.qmaHlUAv%fengguang.wu@intel.com>
 <20170625213022.7kaa7agzmzdyw3n4@angband.pl>
 <20170626121230.GF2866@twin.jikos.cz>
In-Reply-To: <20170626121230.GF2866@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the clarification! I will fix the divisions.

On 6/26/17, 5:12 AM, "David Sterba" <dsterba@suse.cz> wrote:

    On Sun, Jun 25, 2017 at 11:30:22PM +0200, Adam Borowski wrote:
    > On Mon, Jun 26, 2017 at 03:03:17AM +0800, kbuild test robot wrote:
    > > Hi Nick,
    > > 
    > > url:    https://github.com/0day-ci/linux/commits/Nick-Terrell/lib-Add-xxhash-module/20170625-214344
    > > config: i386-allmodconfig (attached as .config)
    > > compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
    > > reproduce:
    > >         # save the attached .config to linux build tree
    > >         make ARCH=i386 
    > > 
    > > All errors (new ones prefixed by >>):
    > > 
    > > >> ERROR: "__udivdi3" [lib/zstd/zstd_compress.ko] undefined!
    > >    ERROR: "__udivdi3" [fs/ufs/ufs.ko] undefined!
    > 
    > Just to save you time to figure it out:
    > for division when one or both arguments are longer than the architecture's
    > word, gcc uses helper functions that are included when compiling in a hosted
    > environment -- but not in freestanding.
    > 
    > Thus, you want do_div() instead of /; do check widths and signedness of
    > arguments.
    
    No do_div please, div_u64 or div64_u64.
    


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
