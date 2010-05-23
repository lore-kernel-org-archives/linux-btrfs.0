From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Sun, 23 May 2010 19:59:30 -0400
Message-ID: <20100523235930.GA25333@dhcp231-156.rdu.redhat.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-6-git-send-email-josef@redhat.com> <4BF8E7F8.50800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	hch@infradead.org, akpm@linux-foundation.org
To: Shi Weihua <shiwh@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BF8E7F8.50800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 23, 2010 at 04:31:52PM +0800, Shi Weihua wrote:
> at 2010-5-22 1:03, Josef Bacik wrote:
> > In order for AIO to work, we need to implement aio_write.  This patch converts
> > our btrfs_file_write to btrfs_aio_write.  I've tested this with xfstests and
> > nothing broke, and the AIO stuff magically started working.  Thanks,
> 
> But xfstests's case 198(source: src/aio-dio-regress/aiodio_sparse2.c) still failed, 
> following message outputted.
> --------------------
> AIO write offset 0 expected 65536 got -22
> AIO write offset 5242880 expected 65536 got -22
> AIO write offset 10485760 expected 65536 got -22
> AIO write offset 15728640 expected 65536 got -22
> AIO write offset 20971520 expected 65536 got -22
> AIO write offset 31457280 expected 65536 got -22
> AIO write offset 36700160 expected 65536 got -22
> AIO write offset 41943040 expected 65536 got -22
> AIO write offset 47185920 expected 65536 got -22
> AIO write offset 52428800 expected 65536 got -22
> AIO write offset 57671680 expected 65536 got -22
> AIO write offset 62914560 expected 65536 got -22
> AIO write offset 73400320 expected 65536 got -22
> AIO write offset 78643200 expected 65536 got -22
> non one buffer at buf[0] => 0x00,00,00,00
> non-one read at offset 0
> *** WARNING *** /tmp/aaaa has not been unlinked; if you don't rm it manually first, it may influence the next run
> -------------------- 
> 
> generic_file_direct_write()(in btrfs_file_aio_write(), fs/btrfs/file.c) returned -22, 
> maybe it's useful for your analysing.

Yes, change that testcase to run -a 4096 and it will run fine.  Because BTRFS
doesn't pass in a bdev to __blockdev_direct_IO it doesn't do 512 byte aligned
IO, just blocksize aligned IO.  I will fix that at some later point, but its a
little tricky since we have to figure out which bdev has the largest alignment
(in case we have a 4k sector device and a 512 byte sector device in the same
volume).  Thanks,

Josef
