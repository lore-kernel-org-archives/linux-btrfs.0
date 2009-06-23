From: Mike Ramsey <MikeJRamsey@comcast.net>
Subject: Phoronix article slaming BTRFS
Date: Tue, 23 Jun 2009 02:51:41 +0000 (UTC)
Message-ID: <loom.20090623T024010-331@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I ran across this article "Testing Out The SSD Mode In Btrfs". 
http://www.phoronix.com/scan.php?page=article&item=btrfs_ssd_mode&num=1

At first I was disappointed.  It gave a very disappointing set of benchmarks.
However, a close reading revealed this:

"With the OCZ Vertex SATA 2.0 SSD, which we used for this testing today, had its
write caching always enabled. When attempting to disable the write cache through
hdparm it would remain enabled regardless and when using sdparm it would report
change_mode_page: failed setting page: Caching (SBC)."

This invalidates the benchmark! Disabling the write cache would yield a 2X
improvement.  

Digging deeper, I found this:
http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg07949.html

" Michael,
 My information may be out of date, but last time I
 looked libata didn't support MODE SELECT which is
 the SCSI command to change mode page settings.
 [I have sent patches several times to add support
 for this in libata but ...]

Ahhha!!!

That looks exactly the case.

I tested the two drives (AS and NS ones) on different
machines, and currently, NS (where things doesn't work)
is connected to AHCI controller, while the AS one is
behind mptsas.  So it just looks like mptsas is doing
the right thing in the first place, while ahci (or
libata, whatever) is failing."

So the article managed to unjustly smear both OCZ Vertex and BTRFS in one shot. 

--Mike Ramsey


