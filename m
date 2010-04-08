From: "Justin" <yoosty69@netzero.com>
Subject: Re: btrfs Bug?
Date: Thu, 8 Apr 2010 18:46:40 GMT
Message-ID: <20100408.114640.18413.0@webmail01.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Unfortunately I did reformat.
Actually, I did a complete zero-out of the drive with dd, and then I ran "badblocks -w" on the drive, which returned 0 bad blocks (not sure if this is really a good test for SSD's as there's some amount of internal voo-doo on the drive itself).

For future reference, how would I go about getting an image of the drive without being able to use btrfs-image?


   Justin


____________________________________________________________
Car Insurance 18.29/Month
Get car insurance for as low as $18.29 a month.
http://thirdpartyoffers.netzero.net/TGL3231/4bbe24ec3a7bb18d3e5st01vuc
