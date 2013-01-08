Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756346Ab3AHR0a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 12:26:30 -0500
Date: Tue, 8 Jan 2013 18:26:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130108172627.GP20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
 <20130108024637.GA1916@liubo>
 <20130108083053.GD3763@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130108083053.GD3763@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 08, 2013 at 09:30:54AM +0100, David Sterba wrote:
> On Tue, Jan 08, 2013 at 10:46:38AM +0800, Liu Bo wrote:
> > Hmm, not always here, lockend = inode->i_size - 1, so lockend % 2 == 1 may not
> > be true.
> 
> Yeah, that's the case that must be handled,
> 
> > But this check can worked in those places where we've rounded the range up to
> > PAGE_SIZE :)
> 
> context:
> 2233         u64 lockend = i_size_read(inode);
> ...
> 2236         u64 len = i_size_read(inode);
> ...
> 2240         lockend = max_t(u64, root->sectorsize, lockend);
> ^^^^
> 
> lockend will be always at least root->sectorsize == PAGE_SIZE, so the simple
> % 2 == 1 test should work generally. Am I missing something? Do we really lock
> sub-PAGE_SIZE ranges?

Of course this only works for files smaller than PAGE_SIZE, a larger
file is locked up to it's i_size. In that case the value of lockend that
arrives at eg. __set_extent_bit can be of any value.
We can access the inode->i_size via extent_io_tree::mapping->host, so
it's possible to do the exact check.

with this simple check:

void check_range(const char *caller, struct inode *inode, u64 start, u64 end)
{
       u64 isize = i_size_read(inode);

       if (end >= PAGE_SIZE && (end % 2) == 0 && end != isize - 1) {
               printk_ratelimited(KERN_DEBUG
                       "D: %s isize = %llu odd range [%llu,%llu)\n",
                               caller,
                               (unsigned long long)isize,
                               (unsigned long long)start,
                               (unsigned long long)end);
       }

}

called as:

	check_range(__func__, tree->mapping->host, start, end);

from clear_extent_bit, wait_extent_bit, __set_extent_bit,
convert_extent_bit and your "lockend--" fix I can't reproduce the
off-by-one error.

$ cat seektest.c
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/fcntl.h>

#ifndef SEEK_DATA
#define SEEK_DATA 3
#endif

static char buf[16*1024];

void do_test(const char *fname, loff_t data_start, loff_t len) {
        int fd;
        loff_t lret;

        fd = open(fname, O_RDWR|O_CREAT, 0644);
        if (fd == -1) {
                perror("open()");
                exit(1);
        }
        printf("[0,%llu] hole\n", data_start - 1);
        llseek(fd, data_start, SEEK_SET);
        write(fd, buf, len);
        printf("[%llu,%llu] data\n", data_start, len - 1);
        fsync(fd);
        llseek(fd, 0, SEEK_SET);
        lret = llseek(fd, 0, SEEK_DATA);
        printf("seek to data returned: %llu\n",
                        (unsigned long long)lret);
        close(fd);
}

int main() {
        do_test("seektest-small-even", 3072, 512);
        do_test("seektest-small-odd", 3072, 511);
        do_test("seektest-big-even", 8192, 512);
        do_test("seektest-big-odd", 8192, 511);
        do_test("seektest-big-aligned", 8192, 4096);
        do_test("seektest-big-aligned-1", 8192, 4095);
        do_test("seektest-big-aligned+1", 8192, 4097);

        return 0;
}
---

However, I'm running xfstests with this debugging patch and I cant'
explain such messages:

[20177.655732] D: __set_extent_bit isize = 0 odd range [352256,8740681790172090368)
[20177.664485] D: clear_extent_bit isize = 0 odd range [352256,8740681790172090368)
[20182.399257] D: __set_extent_bit isize = 944560 odd range [229376,7504638559450173440)
[20182.408465] D: clear_extent_bit isize = 944560 odd range [229376,7504638559450173440)
[20183.543186] D: __set_extent_bit isize = 396355 odd range [692224,2301956497953013760)
[20183.552170] D: clear_extent_bit isize = 396355 odd range [692224,2301956497953013760)
[20187.018092] D: __set_extent_bit isize = 0 odd range [401408,306555945915797504)
[20187.026532] D: clear_extent_bit isize = 0 odd range [401408,306555945915797504)
[20189.941615] D: __set_extent_bit isize = 1936258 odd range [2457600,6817576374066888704)
[20189.950751] D: clear_extent_bit isize = 1936258 odd range [2457600,6817576374066888704)
[20190.642796] D: __set_extent_bit isize = 0 odd range [274432,8022548162794254336)
[20190.651380] D: clear_extent_bit isize = 0 odd range [274432,8022548162794254336)
[20191.244458] D: __set_extent_bit isize = 845491 odd range [1671168,5821247760915324928)
[20191.253508] D: clear_extent_bit isize = 845491 odd range [1671168,5821247760915324928)
[20191.948060] D: __set_extent_bit isize = 0 odd range [774144,7384799041917984768)
[20191.956581] D: clear_extent_bit isize = 0 odd range [774144,7384799041917984768)

so I'm not sending it as a separate patch yet until the check covers all cases.


david
