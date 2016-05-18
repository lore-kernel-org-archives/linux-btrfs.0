Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-hk2apc01on0070.outbound.protection.outlook.com ([104.47.124.70]:62055
	"EHLO APC01-HK2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbcERX7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 May 2016 19:59:33 -0400
From: Paul Jones <paul@pauljones.id.au>
To: Graham Cobb <g.btrfs@cobb.uk.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: Reducing impact of periodic btrfs balance
Date: Wed, 18 May 2016 23:44:43 +0000
Message-ID: <SYXPR01MB036721A501F143F4ED3ED5489E490@SYXPR01MB0367.ausprd01.prod.outlook.com>
References: <573C6E47.2080109@cobb.uk.net>
In-Reply-To: <573C6E47.2080109@cobb.uk.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Graham Cobb
> Sent: Wednesday, 18 May 2016 11:30 PM
> To: linux-btrfs@vger.kernel.org
> Subject: Reducing impact of periodic btrfs balance
> 
> Hi,
> 
> I have a 6TB btrfs filesystem I created last year (about 60% used).  It is my
> main data disk for my home server so it gets a lot of usage (particularly mail).
> I do frequent snapshots (using btrbk) so I have a lot of snapshots (about 1500
> now, although it was about double that until I cut back the retention times
> recently).
> 
> A while ago I had a "no space" problem (despite fi df, fi show and fi usage all
> agreeing I had over 1TB free).  But this email isn't about that.
> 
> As part of fixing that problem, I tried to do a "balance -dusage=20" on the
> disk.  I was expecting it to have system impact, but it was a major disaster.
> The balance didn't just run for a long time, it locked out all activity on the disk
> for hours.  A simple "touch" command to create one file took over an hour.
> 
> More seriously, because of that, mail was being lost: all mail delivery timed
> out and the timeout error was interpreted as a fatal delivery error causing
> mail to be discarded, mailing lists to cancel subscriptions, etc. The balance
> never completed, of course.  I eventually got it cancelled.
> 
> I have since managed to complete the "balance -dusage=20" by running it
> repeatedly with "limit=N" (for small N).  I wrote a script to automate that
> process, and rerun it every week.  If anyone is interested, the script is on
> GitHub: https://github.com/GrahamCobb/btrfs-balance-slowly


Hi Graham,

I've experienced similar problems from time to time. It seems to be fragmentation of the metadata. In my case I have a volume with about 20 million smallish (100k) files scattered through around 20,000 directories, and originally they were created at random. Updating the files at a data rate of around 5 MB/s took 100% disk utilisation on Raid1 SSD. After a few iterations I needed to delete the files and start again, this took 4 days!! I cancelled it a few times and tried defrags and balances, but they didn't help. Needless to say, the filesystem was basically unusable at the time.
Long story short, I discovered that populating each directory completely, one at a time, alleviated the speed issue. I then remembered that if you run defrag with the compress option it writes out the files again, which also fixes the problem. (Note that there is no option for no compression)
So if you are ok with using compression try a defrag with compression. That massively fixed my problems.

Regards,
Paul.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
