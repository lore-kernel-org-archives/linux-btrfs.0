From: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: [2.6.35.3] BUG: unable to handle kernel NULL pointer
 dereference at (null)
Date: Thu, 26 Aug 2010 14:16:16 +0200
Message-ID: <20100826121616.GA8036@Pilar.aei.mpg.de>
References: <20100826095357.GA7202@Pilar.aei.mpg.de>
 <20100826115336.GW14190@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100826115336.GW14190@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Do 26.Aug'10 at  7:53:36 -0400, Chris Mason wrote:
> On Thu, Aug 26, 2010 at 11:53:57AM +0200, Carlos R. Mafra wrote:
> > Hi,
> > 
> > I've just got this BUG: message in dmesg which I think is btrfs related.
> > 
> > I have a btrfs filesystem in a memory card which I use to contain the 
> > cache and config of chromium (to avoid writing to much in the SSD):
> > 
> > /dev/mmcblk0p1 on /home/mafra/mmc type btrfs (rw,noexec,nosuid,nodev,noatime,noacl,compress)
> > 
> > and the last message before the bug is about the memory card.
> 
> Hmmm it is definitely btrfs related.  Do you continue to get it after
> rebooting?

No, after rebooting chromium refused to open (like it did during the BUG) 
but no BUG: message appeared.

Then I deleted all chromium cache+config from the memory card and chromium
worked again, but after suspending to RAM I noticed this:

[ 6035.423238] PM: Syncing filesystems ... done.
[ 6036.524889] Freezing user space processes ... 
[ 6056.533079] Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze):
[ 6056.533119] chrome        D 00000000ffffffff     0  7028   7015 0x00800004
[ 6056.533124]  ffff8800630a1c08 0000000000000086 0000000000000000 0000000000012d40
[ 6056.533129]  ffff8800630a1fd8 ffff8800630a1fd8 ffff88006303e0c0 0000000000012d40
[ 6056.533133]  0000000000012d40 0000000000004000 0000000000004000 ffff8800630a1fd8
[ 6056.533137] Call Trace:
[ 6056.533145]  [<ffffffff81064029>] ? ktime_get_ts+0xa9/0xe0
[ 6056.533150]  [<ffffffff810a3610>] ? sync_page_killable+0x0/0x40
[ 6056.533155]  [<ffffffff81506bde>] io_schedule+0x6e/0xb0
[ 6056.533158]  [<ffffffff810a35f8>] sync_page+0x38/0x50
[ 6056.533161]  [<ffffffff810a3619>] sync_page_killable+0x9/0x40
[ 6056.533164]  [<ffffffff81507332>] __wait_on_bit_lock+0x52/0xb0
[ 6056.533168]  [<ffffffff810a3532>] __lock_page_killable+0x62/0x70
[ 6056.533172]  [<ffffffff8105bb40>] ? wake_bit_function+0x0/0x40
[ 6056.533175]  [<ffffffff810a3459>] ? find_get_page+0x19/0x90
[ 6056.533178]  [<ffffffff810a5144>] generic_file_aio_read+0x494/0x6d0
[ 6056.533183]  [<ffffffff810d4b22>] do_sync_read+0xd2/0x110
[ 6056.533186]  [<ffffffff81025406>] ? do_page_fault+0x186/0x390
[ 6056.533190]  [<ffffffff810d5273>] vfs_read+0xb3/0x160
[ 6056.533193]  [<ffffffff810d536c>] sys_read+0x4c/0x80
[ 6056.533197]  [<ffffffff81002d2b>] system_call_fastpath+0x16/0x1b
[ 6056.533207] 
[ 6056.533208] Restarting tasks ... done.

but everything is working well AFAICT.
