From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: fallocate overhead
Date: Thu, 13 Aug 2009 16:07:32 +0200
Message-ID: <20090813140732.GA1915@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lkml@rtr.ca
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I was playing with the new hdparm wiper script (
http://sourceforge.net/projects/hdparm/files/) on my Vertex SSD and
it appears that btrfs needs a huge space overhead when dealing with
fallocate system calls. Basically what the wiper script does is to
fallocate one huge file using all free space minus a safety margin.
And this margin has to be about 30% on btrfs, e.g.:

# df -T /
Filesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/root    btrfs    31266648  10464096  20802552  34% /
# hdparm --fallocate 20002552 test_temp
test_temp: No space left on device
# hdparm --fallocate 16002552 test_temp
test_temp: No space left on device
# hdparm --fallocate 15002552 test_temp
#

and from dmesg:
no space left, need 20482613248, 4096 delalloc bytes, 9786335232 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 25545211904 total
no space left, need 16386613248, 4096 delalloc bytes, 9786335232 bytes_used, 0 bytes_reserved, 0 bytes_pinned, 0 bytes_readonly, 0 may use 25545211904 total

My question is if 30% isn't a bit too much overhead?
-- 
Markus
