From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: btrfs: why default 4M readahead size?
Date: Fri, 19 Mar 2010 09:22:11 +0100
Message-ID: <20100319082210.GO5768@kernel.dk>
References: <20100318014257.GA30963@sli10-desk.sh.intel.com> <20100318125313.GA14074@think> <20100319005948.GA12851@sli10-desk.sh.intel.com> <20100319025642.GA20828@sli10-desk.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	fengguang.wu@intel.com
To: Shaohua Li <shaohua.li@intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100319025642.GA20828@sli10-desk.sh.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 19 2010, Shaohua Li wrote:
> On Fri, Mar 19, 2010 at 08:59:48AM +0800, Shaohua Li wrote:
> > On Thu, Mar 18, 2010 at 08:53:13PM +0800, Chris Mason wrote:
> > > On Thu, Mar 18, 2010 at 09:42:57AM +0800, Shaohua Li wrote:
> > > > Btrfs uses below equation to calculate ra_pages:
> > > > 	fs_info->bdi.ra_pages = max(fs_info->bdi.ra_pages,
> > > >               		4 * 1024 * 1024 / PAGE_CACHE_SIZE);
> > > > is the max() a typo of min()? This makes the readahead size is 4M by default,
> > > > which is too big.
> > > 
> > > Looks like things have changed since I tuned that number.  Fengguang has
> > > been busy ;)
> > > 
> > > > I have a system with 16 CPU, 6G memory and 12 sata disks. I create a btrfs for
> > > > each disk, so this isn't a raid setup. The test is fio, which has 12 tasks to
> > > > access 12 files for each disk. The fio test is mmap sequential read. I measure
> > > > the performance with different readahead size:
> > > > ra size		io throughput
> > > > 4M		268288 k/s
> > > > 2M		367616 k/s
> > > > 1M		431104 k/s
> > > > 512K		474112 k/s
> > > > 256K		512000 k/s
> > > > 128K		538624 k/s
> > > > The 4M default readahead size has poor performance.
> > > > I also does sync sequential read test, the test difference in't that big. But
> > > > the 4M case still has about 10% drop compared to the 512k case.
> > > 
> > > I'm surprised the 4M is so much slower.  At any rate, the larger size
> > > was selected because btrfs checksumming means we need a bigger buffer to
> > > keep the disks saturated.  Were you on a fancy intel box with hardware
> > > crc32c enabled?
> > yes, this machine supports sse4.2 instruction. Let me check the result with checksum
> > disabled.
> Sounds no big difference with checksum disabled. I format the disks and redo
> the test:
> 128k ra: 539648 k/s
> 4m ra: 285696 k/s

4MB is definitely a huge read-ahead size, but I do wonder why it would
perform that much worse than a 128KB window. If you narrow your test
down to a single disk (or something simpler, at least), how does 4MB
compare to 128KB? With 6GB of memory, you should not run into read-ahead
memory thrashing.

-- 
Jens Axboe

