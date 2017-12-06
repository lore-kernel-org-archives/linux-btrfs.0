Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0097.outbound.protection.outlook.com ([104.47.41.97]:29748
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753818AbdLFBxo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Dec 2017 20:53:44 -0500
From: Matthew Wilcox <mawilcox@microsoft.com>
To: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>
CC: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
        Rehas Sachdeva <aquannie@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net"
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 00/73] XArray version 4
Date: Wed, 6 Dec 2017 01:53:41 +0000
Message-ID: <MWHPR21MB0845A83B9E89E4A9499AEC2FCB320@MWHPR21MB0845.namprd21.prod.outlook.com>
References: <20171206004159.3755-1-willy@infradead.org>
 <20171206014536.GA4094@dastard> <20171206015108.GB4094@dastard>
In-Reply-To: <20171206015108.GB4094@dastard>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Huh, you've caught a couple of problems that 0day hasn't sent me yet.  Try turning on DAX or TRANSPARENT_HUGEPAGE.  Thanks!

> -----Original Message-----
> From: Dave Chinner [mailto:david@fromorbit.com]
> Sent: Tuesday, December 5, 2017 8:51 PM
> To: Matthew Wilcox <willy@infradead.org>
> Cc: Matthew Wilcox <mawilcox@microsoft.com>; Ross Zwisler
> <ross.zwisler@linux.intel.com>; Jens Axboe <axboe@kernel.dk>; Rehas
> Sachdeva <aquannie@gmail.com>; linux-mm@kvack.org; linux-
> fsdevel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; linux-
> nilfs@vger.kernel.org; linux-btrfs@vger.kernel.org; linux-xfs@vger.kernel.org;
> linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4 00/73] XArray version 4
> 
> On Wed, Dec 06, 2017 at 12:45:49PM +1100, Dave Chinner wrote:
> > On Tue, Dec 05, 2017 at 04:40:46PM -0800, Matthew Wilcox wrote:
> > > From: Matthew Wilcox <mawilcox@microsoft.com>
> > >
> > > I looked through some notes and decided this was version 4 of the XArray.
> > > Last posted two weeks ago, this version includes a *lot* of changes.
> > > I'd like to thank Dave Chinner for his feedback, encouragement and
> > > distracting ideas for improvement, which I'll get to once this is merged.
> >
> > BTW, you need to fix the "To:" line on your patchbombs:
> >
> > > To: unlisted-recipients: ;, no To-header on input <@gmail-
> pop.l.google.com>
> >
> > This bad email address getting quoted to the cc line makes some MTAs
> > very unhappy.
> >
> > >
> > > Highlights:
> > >  - Over 2000 words of documentation in patch 8!  And lots more kernel-doc.
> > >  - The page cache is now fully converted to the XArray.
> > >  - Many more tests in the test-suite.
> > >
> > > This patch set is not for applying.  0day is still reporting problems,
> > > and I'd feel bad for eating someone's data.  These patches apply on top
> > > of a set of prepatory patches which just aren't interesting.  If you
> > > want to see the patches applied to a tree, I suggest pulling my git tree:
> > >
> https://na01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fgit.infrade
> ad.org%2Fusers%2Fwilly%2Flinux-
> dax.git%2Fshortlog%2Frefs%2Fheads%2Fxarray-2017-12-
> 04&data=02%7C01%7Cmawilcox%40microsoft.com%7Ca3e721545f8b4b9dff1
> 608d53c4bd42f%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6364
> 81218740341312&sdata=IXNZXXLTf964OQ0eLDpJt2LCv%2BGGWFW%2FQd4Kc
> KYu6zo%3D&reserved=0
> > > I also left out the idr_preload removals.  They're still in the git tree,
> > > but I'm not looking for feedback on them.
> >
> > I'll give this a quick burn this afternoon and see what catches fire...
> 
> Build warnings/errors:
> 
> .....
> lib/radix-tree.c:700:13: warning: Â¿radix_tree_free_nodesÂ¿ defined but not used
> [-Wunused-function]
>  static void radix_tree_free_nodes(struct radix_tree_node *node)
> .....
> lib/xarray.c: In function Â¿xas_maxÂ¿:
> lib/xarray.c:291:16: warning: unused variable Â¿maskÂ¿
> [-Wunused-variable]
>   unsigned long mask, max = xas->xa_index;
>                   ^~~~
> ......
> fs/dax.c: In function Â¿grab_mapping_entryÂ¿:
> fs/dax.c:305:2: error: implicit declaration of function Â¿xas_set_orderÂ¿; did you
> mean Â¿xas_set_errÂ¿?  [-Werror=implicit-function-declaration]
>   xas_set_order(&xas, index, size_flag ? PMD_ORDER : 0);
>     ^~~~~~~~~~~~~
> scripts/Makefile.build:310: recipe for target 'fs/dax.o' failed
> make[1]: *** [fs/dax.o] Error 1
> 
> -Dave.
> --
> Dave Chinner
> david@fromorbit.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
