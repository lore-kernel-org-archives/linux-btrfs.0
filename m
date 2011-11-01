From: Gustavo Sverzut Barbieri <barbieri@gmail.com>
Subject: corrupted btrfs after suspend2ram uncorrectable with scrub
Date: Tue, 1 Nov 2011 16:38:29 -0200
Message-ID: <CANkykrA7uxc51rFTbTXar8v_3vE2Gn9LKYrApOfvqWNf5B_adw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm using kernel 3.1.0 and I have both / and /home as btrfs. I used
suspend to ram quite often and never had a problem, but yesterday I've
suspended to get into a plane and when I resumed my /home was all
about input/output errors. Reboot did not help either.  My root (/)
did not suffer any problems.

Today I've upgraded btrfs-progs to latest GIT and tried scrub without success:

  # btrfs scrub start -B -d /home/
  scrub device /dev/sda6 (id 1) done
  	scrub started at Sun Dec 31 23:13:19 2000 and finished after 273 seconds
  	total bytes scrubbed: 548.90MB with 1 errors
  	error details: verify=1
  	corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

  # dmesg after "cat /home/gustavo/file":
  btrfs no csum found for inode 2957021 start 0
  btrfs no csum found for inode 2957021 start 0
  btrfs csum failed ino 2957021 extent 85041815552 csum 667310679
wanted 0 mirror 0
  btrfs no csum found for inode 2957021 start 0
  btrfs no csum found for inode 2957021 start 0
  btrfs csum failed ino 2957021 extent 85041815552 csum 667310679
wanted 0 mirror 1

  # dmesg during scrub:
  btrfs: unable to fixup at 402384056320

  # grep btrfs /etc/fstab
  /dev/sda4  /	 btrfs noatime,noacl,compress,nodatacow,nobarrier,ssd	0 0
  /dev/sda6  /home btrfs
noatime,noacl,compress,ssd,comment=systemd.automount 0 0

I can still list directories and all, but no file contents can be
read. Not even those that I'm sure were not changed recently, like
~/.emacs or some read-only files.

Before the suspend I was writing some code under
/home/gustavo/Development, but just 2 files were written recently. Of
course something like ~/.xsession-errors or some browser cache may
have changed recently. But nothing big like a compile.

It is an Apple MacBook Pro with their SSD. badblocks (read-only) shows
no errors.

Is there any way to recover it?  :-S

-- 
Gustavo Sverzut Barbieri
--------------------------------------
Mobile: +55 (19) 9225-2202
Contact: http://www.gustavobarbieri.com.br/contact
