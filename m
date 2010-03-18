From: Shaohua Li <shaohua.li@intel.com>
Subject: btrfs: why default 4M readahead size?
Date: Thu, 18 Mar 2010 09:42:57 +0800
Message-ID: <20100318014257.GA30963@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, jens.axboe@oracle.com,
	fengguang.wu@intel.com, shaohua.li@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs uses below equation to calculate ra_pages:
	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
              		4 * 1024 * 1024 / PAGE_CACHE_SIZE);
is the max() a typo of min()? This makes the readahead size is 4M by default,
which is too big.
I have a system with 16 CPU, 6G memory and 12 sata disks. I create a btrfs for
each disk, so this isn't a raid setup. The test is fio, which has 12 tasks to
access 12 files for each disk. The fio test is mmap sequential read. I measure
the performance with different readahead size:
ra size		io throughput
4M		268288 k/s
2M		367616 k/s
1M		431104 k/s
512K		474112 k/s
256K		512000 k/s
128K		538624 k/s
The 4M default readahead size has poor performance.
I also does sync sequential read test, the test difference in't that big. But
the 4M case still has about 10% drop compared to the 512k case.

One might argue how about the case memory isn't tight. I tried only run a
one-disk setup with only one task. The 4M ra almost has no difference with the
128K ra. I guess the 128k default ra size for backing dev is carefuly choosed
to work with popular disks.
So my question is why we have a default 4M readahead size even with noraid case?

Thanks,
Shaohua
