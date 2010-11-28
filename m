From: C Anthony Risinger <anthony@extof.me>
Subject: mounting arbitrary directories
Date: Sat, 27 Nov 2010 21:19:17 -0600
Message-ID: <AANLkTi=7LY6y3BvGgkyYBTLwu=SYJjZZhL8kHusCn_vs@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i have read just recently and in the past that btrfs supports COW for
_any_ file/directory (this is reflinks, yes?), and today i
accidentally noticed that i can mount a directory as well (if it's in
the top level volume at least).

eg. if i have a "regular" directory (not a subvolume) in the top-level:

/__boot

i can mount it with:

mount -o subvol=__boot /dev/sda /mnt

is this supposed to be supported via the "subvol" mount option?
though it sounds like i've answered my own question, i ask because
playing around with this caused my kernel to oops for the first time
in a long, long time (on .35 but just about to upgrade to .36 in about
10 min).

i am working on an update to my initramfs hook that will utilize
extlinux, and this property to provide seamless kernel level system
rollbacks, and i want to make sure it's safe to do this.

also, is there a way to target an arbitrary directory?  does "subvol"
support paths yet, or maybe via "subvolid" somehow?  essentially i
just want to mount a directory inside a snapshot at /boot, so when
users upgrade there kernels, the images are visible to extlinux (which
cannot yet peek inside or use subvolumes, so it has to be a regular
directory in the top-level volume)

any insight is much appreciated.

C Anthony
