From: Russell Smith <russell.smith@ukd1.co.uk>
Subject: Can't mount (or debug-tree) my filesystem
Date: Mon, 27 Dec 2010 20:50:36 +0000
Message-ID: <AANLkTikzNNJcUaOk4syTAfqmG2dj71L-FYFXbyY-DTGp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

I am running btrfs v0.19 and have a problem after filling my drives,
attempting to delete the directory which had caused the drives to
become full, after which the machine locked and was reset. After which
basically, it wouldn't mount the drives.

An offline fsck revealed the "aborted" message after lots of "parent
transid verify failed on 2721514774528 wanted 39651 found 39649" type
messages.

My setup was 2x 1tb drives with mirroring (using btrfs). I don't
recall the command line options I used.

I installed the latest unstable tools from Chris Mason, and attempted
to use a newer SB, which all had the same result.


Also, I attempted to use btrfs_rescue.c, but this resulted in:

btrfs_rescue volumes /dev/sdb
ERROR: Cannot read block at 0x124c9c02000!



Also, I've now removed the second drive & re-used it.

btrfs-show
failed to read /dev/sr0
Label: none  uuid: 226aeac3-c5a3-4c3f-869e-46e1fdebdd10
	Total devices 2 FS bytes used 793.22GB
	devid    1 size 931.51GB used 399.76GB path /dev/sdb
	*** Some devices missing

Label: none  uuid: 51d2c9eb-a88d-42df-b2ed-559dc083210d
	Total devices 1 FS bytes used 3.87GB
	devid    1 size 32.59GB used 7.29GB path /dev/dm-0

Btrfs v0.19-35-g1b444cd




I also get;


btrfs-debug-tree /dev/sdb
failed to read /dev/sr0
btrfs-debug-tree: volumes.c:1367: btrfs_read_sys_array: Assertion
`!(ret)' failed.
Aborted



Hopefully, there is something that could be saved, but it's not
critical for me (it was mainly backups of which I keep plenty else
where). It would be handy if it was recoverable.

I am able to make a dd copy of the whole drive and try any new fsck
type software that is around?


Regards,

Russell Smith
UKD1 Limited

01730 888189 / 07971699945
http://www.ukd1.co.uk/

All work copyright UKD1 Limited

Registered in England 6140874

ATTENTION - This message is private and confidential and is solely for
the use of the party to which it is addressed. If you have received
this message in error please inform us immediately, and please be
aware that any use, dissemination, distribution or reproduction of
this message and the information contained herein is prohibited.

Any Concepts and or Designs may not be used or recreated in any form
and are Copyright UKD1 Limited
