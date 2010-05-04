From: "Justin" <yoosty69@netzero.com>
Subject: TRIM + RAID Support?
Date: Tue, 4 May 2010 15:53:17 GMT
Message-ID: <20100504.085317.25251.0@webmail21.vgs.untd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As I understand it, hardware RAID controllers do not pass the TRIM command to it's disks; btrfs deals with the disk directly, supports TRIM, and supports RAID. I have seen no explicit mention of being able to combine RAID and TRIM support using btrfs with independent disks so I'm asking: When btrfs is in RAID mode, does it still pass the TRIM commands to the SSD?


   Justin

____________________________________________________________
Penny Stock Jumping 2000%
Sign up to the #1 voted penny stock newsletter for free today!
http://thirdpartyoffers.netzero.net/TGL3231/4be042fc378a34813fst01vuc
