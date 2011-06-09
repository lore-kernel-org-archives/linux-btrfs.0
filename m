From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: defrag makes fragmentation worse
Date: Fri, 10 Jun 2011 00:48:36 +0200
Message-ID: <201106100048.36499.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've observed several times that after a btrfs filesystem defrag a file was way 
more fragmented than before. For example, a file that was recently written, had 
10 extents (output from filefrag). After a defrag filefrag showed more than 1900 
extents. For curiosity, a simple copy of this "defragmented" file reduced the 
number of fragments to 1. With a different file I got 63 extents before and over 
3000 extents after defrag. 
It's no problem if defrag can't reduce the fragmentation. But in this case it 
shouldn't be done at all. 

regards,
  Johannes
