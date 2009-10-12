From: Zhang Jingwang <yyalone@gmail.com>
Subject: soft lockup when leaf and node bigger than 4KB
Date: Mon, 12 Oct 2009 17:55:47 +0800
Message-ID: <4486336c0910120255p6388cc5dl3bf7154a418d068e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I make a btrfs use 'mkfs.btrfs -m single -l 16384 -n 16384 /dev/xxx'.
After mount it, I run a test script to create lots of files, then soft
lockup occurs.

After digging into the source code, I think there is a problem with
bio->bi_end_io.

when a bio is done, end_io function is called, it does following things:
1: put the bio into async thread waiting for checksum. (end_workqueue_bio)
2: check whether the bio can be checksum-ed. If not, put it back to
wait queue.(end_workqueue_fn)
3: If it can be checksum-ed, call end_bio_extent_readpage().
4: checksum the extent, set_extent_uptodate() and set uptodate flag of
the pages belong to the bio.(end_bio_extent_readpage)

But when checking whether the bio can be checksum-ed in step 2, it
examine the extent_range_uptodate() and uptodate flag of these pages
which is set in step 4. So I think there will be a endless loop here.

When we say a page is uptodate, we means its checksum is correct, but
we must ensure that all of the pages belongs to a btree node is
uptodate in order to calculate its checksum. So it's a logical
paradox.

I am new to btrfs and there may be some mistake about this problem.
Any comment is welcome and thanks for your time!

-- 
Zhang Jingwang
National Research Centre for High Performance Computers
Institute of Computing Technology, Chinese Academy of Sciences
No. 6, South Kexueyuan Road, Haidian District
Beijing, China
