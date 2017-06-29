Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-co1nam03on0135.outbound.protection.outlook.com ([104.47.40.135]:58272
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752689AbdF2SV4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Jun 2017 14:21:56 -0400
From: Matthew Wilcox <mawilcox@microsoft.com>
To: Jeff Layton <jlayton@poochiereds.net>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Jan Kara <jack@suse.cz>,
        "tytso@mit.edu" <tytso@mit.edu>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Carlos Maiolino <cmaiolino@redhat.com>, Eryu Guan <eguan@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Liu Bo <bo.li.liu@oracle.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: RE: [PATCH v8 12/18] Documentation: flesh out the section in vfs.txt
 on storing and reporting writeback errors
Date: Thu, 29 Jun 2017 18:21:50 +0000
Message-ID: <BY2PR21MB003653755FD85FCE2C49393ECBD20@BY2PR21MB0036.namprd21.prod.outlook.com>
References: <20170629131954.28733-1-jlayton@kernel.org>
         <20170629131954.28733-13-jlayton@kernel.org>
         <20170629171137.GE5874@birch.djwong.org>
 <1498760014.22569.13.camel@poochiereds.net>
In-Reply-To: <1498760014.22569.13.camel@poochiereds.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Jeff Layton [mailto:jlayton@poochiereds.net]
> On Thu, 2017-06-29 at 10:11 -0700, Darrick J. Wong wrote:
> > On Thu, Jun 29, 2017 at 09:19:48AM -0400, jlayton@kernel.org wrote:
> > > +Handling errors during writeback
> > > +--------------------------------
> > > +Most applications that utilize the pagecache will periodically call
> > > +fsync to ensure that data written has made it to the backing store.
> >
> > /me wonders if this sentence ought to be worded more strongly, e.g.
> >
> > "Applications that utilize the pagecache must call a data
> > synchronization syscall such as fsync, fdatasync, or msync to ensure
> > that data written has made it to the backing store."
> 
> Well...only if they care about the data. There are some that don't. :)

Also, applications don't "utilize the pagecache"; filesystems use the pagecache.
Applications may or may not use cached I/O.  How about this:

Applications which care about data integrity and use cached I/O will
periodically call fsync(), msync() or fdatasync() to ensure that their
data is durable.

> What should we do about sync_file_range here? It doesn't currently call
> any filesystem operations directly, so we don't have a good way to make
> it selectively use errseq_t handling there.
> 
> I could resurrect the FS_* flag for that, though I don't really like
> that. Should I just go ahead and convert it over to use errseq_t under
> the theory that most callers will eventually want that anyway?

I think so.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
