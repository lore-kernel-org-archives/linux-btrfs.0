From: Peter Silva <Peter.A.Silva@gmail.com>
Subject: usage, fs balance segfault, then hung.
Date: Sat, 18 Jun 2011 08:35:42 -0400
Message-ID: <BANLkTin7mCxEajK6o5DopH_bC+Uc_sGT6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hello,

Using an ubuntu natty std kernel, had a file system with 2 x 500 G
drives.  One was giving lots of SMART errors, and saying "failure
imminent".  Added a 750 GB to replace (btrfs device add), did a btrfs
device delete <the first bad drive> ... ran for a few hours, completed
correctly afaict.

Noticed that the other 500 G device was acting strangely as well.  It
had issues staying on the bus.   The 750 G drive is on another bus,
and unaffected by issues with the 500.  Two power cycles without
proper shutdown were necessary until I gave
up and removed the second drive.  fs would then only mount with -o
degraded.  Did that.  Added a 1 TB drive OK.
this did not trigger a balance.  Left it alone for an hour or two,
trying to delete the second 500 G drive.
no luck. ...

alu% btrfs filesystem balance /alu/tr8m_1      # ran for a few hours...
Segmentation fault
alu% btrfs filesystem balance /alu/tr8m_1     # running for eight
hours or so,...

in another window tried:
alu% btrfs filesystem show
failed to read /dev/sr0
Label: none  uuid: aec637e6-422a-41c6-8c03-b58d7912decb
	Total devices 2 FS bytes used 677.79GB
	devid    1 size 931.51GB used 680.27GB path /dev/sde
	devid    2 size 931.51GB used 680.27GB path /dev/sdf

Label: none  uuid: b7d56b78-f15a-42bf-bef1-0bff947dedbb
	Total devices 3 FS bytes used 95.08GB
	devid    3 size 698.64GB used 97.02GB path /dev/sdd
	devid    4 size 931.51GB used 95.01GB path /dev/sdg
	*** Some devices missing

Btrfs Btrfs v0.19
alu% btrfs device delete missing /alu/tr8m_1
^C^Z

so the balance and device delete have been hung for around 8 hours,
there is no activity on the devices.
All data is still accessible, file system is behaving normally.
processes are not killable.

Would like to return to safe state with current drives.  Suggestions?
