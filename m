From: Erik Hoppe <amiga600dev@yahoo.de>
Subject: Re: system crash at mounting of btrfs
Date: Wed, 27 Oct 2010 16:53:00 +0200
Message-ID: <1288191180.4424.6.camel@malta>
References: <1288190373-21381-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: amiga600dev@yahoo.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288190373-21381-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

I did another test with 2.6.36 same results (system instantly crash
after mount, even in read only mode) 

Userland View (mount filesystem image)
------------------------------ snip ------------------------------
vbox portable # uname -a
Linux vbox 2.6.36-gentoo-VBOX #1 SMP Tue Oct 26 12:56:53 CEST 2010
x86_64 Intel(R) Xeon(R) CPU W3520 @ 2.67GHz GenuineIntel GNU/Linux
vbox portable # modprobe loop   
vbox portable # losetup /dev/loop0 sd.img 
vbox portable # mount -t btrfs -o ro /dev/loop0 /mnt/sdcard/
------------------------------ snip ------------------------------

Kernel View
------------------------------ snip ------------------------------
Btrfs loaded
device label home devid 1 transid 122306 /dev/loop0
------------------------------ snip ------------------------------


btrfsck report (everything ok)
------------------------------ snip ------------------------------
vbox portable # btrfsck sd.img 
found 4694925312 bytes used err is 0
total csum bytes: 4518676
total tree bytes: 67801088
total fs tree bytes: 53567488
btree space waste bytes: 18724362
file data blocks allocated: 5819858944
 referenced 5092511744
Btrfs Btrfs v0.19
------------------------------ snip ------------------------------

any help appreciated


regards Erik


