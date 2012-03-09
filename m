From: David Sterba <dave@jikos.cz>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 9 Mar 2012 11:55:37 +0100
Message-ID: <20120309105537.GG4334@twin.jikos.cz>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com> <20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com> <4F595D6D.6080809@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jacek Luczak <difrost.kernel@gmail.com>, dave@jikos.cz,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F595D6D.6080809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 09, 2012 at 09:31:25AM +0800, Liu Bo wrote:
> > There were quite many things happening in the system at that time.
> > Can't really tell what could trigger this.
> > 
> > Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz
> > 
> So are these warnings based on the latest upstream of btrfs?

No, from the log it's 3.2.7, so it does not conain the patch

"increase the global block reserve estimates"

the log shows lots of messages

Mar  8 13:36:37 kernel: use_block_rsv: 7 callbacks suppressed
Mar  8 13:36:37 kernel: ------------[ cut here ]------------
Mar  8 13:36:37 kernel: WARNING: at fs/btrfs/extent-tree.c:5985 btrfs_alloc_free_block+0xc5/0x292 [btrfs]()
...
Mar  8 13:36:37 kernel:  [<ffffffffa031161f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
Mar  8 13:36:37 kernel:  [<ffffffff8106901d>] ? warn_slowpath_common+0x78/0x8d
Mar  8 13:36:37 kernel:  [<ffffffffa031161f>] ? btrfs_alloc_free_block+0xc5/0x292 [btrfs]
Mar  8 13:36:37 kernel:  [<ffffffffa032bbad>] ? btrfs_item_offset+0x2c/0x61 [btrfs]
Mar  8 13:36:37 kernel:  [<ffffffffa03007dc>] ? leaf_space_used+0x86/0xb5 [btrfs]
Mar  8 13:36:39 kernel:  [<ffffffffa0304a7a>] ? split_leaf+0x2d9/0x632 [btrfs]
Mar  8 13:36:39 kernel:  [<ffffffffa0306261>] ? btrfs_search_slot+0x6c1/0x75a [btrfs]
Mar  8 13:36:40 kernel:  [<ffffffffa0306e6e>] ? btrfs_insert_empty_items+0x61/0xab [btrfs]
Mar  8 13:36:41 kernel:  [<ffffffffa032207c>] ? insert_inline_extent+0xea/0x2d4 [btrfs]
Mar  8 13:36:41 kernel:  [<ffffffffa0322389>] ? cow_file_range_inline+0x123/0x163 [btrfs]
...


so there is probably other problem in reservations and it just blew up during
the unlink call.


david
