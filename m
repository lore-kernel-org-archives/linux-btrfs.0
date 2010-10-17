From: Chalet16 <chalet16@gmail.com>
Subject: How can I recover data from little overwritten missing raid0 device?
Date: Sun, 17 Oct 2010 21:57:31 +0700
Message-ID: <AANLkTinbmFFNySV=_vmWZzQWeLxL3wgBUmsuKch7Mn6j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I had set up btrfs with 2 devices by using command this command sequence.
"mkfs.btrfs -m raid1 /dev/sda1
mount /dev/sda1 /mnt/data
btrfs-vol -a /dev/sdb1 /mnt/data
btrfs-vol -b /mnt/data"

(I was think that it will do raid1 for both data and metadata but I currently
realised that it will do raid1 for metadata but raid0 for data.)

But I forgot that I have mount /dev/sdb1 with TrueCrypt. After I restarted my
PC and try to mount both devices array again there was a message in dmesg said
"chalet16@server:~$ sudo mount /dev/sda1 /mnt/data
[ 2828.921406] device label btr2902 devid 1 transid 8829 /dev/mapper/truecrypt1
[ 2828.931780] btrfs: failed to read the system array on dm-1
[ 2828.961330] btrfs: open_ctree failed"

And when I ran btrfs-show it show that
"chalet16@server:~$ sudo btrfs-show
failed to read /dev/sr0
Label: btr2902  uuid: 5673597c-ff57-4a42-8fe3-ff793f476809
	Total devices 2 FS bytes used 706.75GB
	devid    1 size 930.00GB used 717.26GB path /dev/sda1
	*** Some devices missing
Btrfs Btrfs v0.19"
And when I run btrfsck on missing device
"chalet16@server:~$ sudo btrfsck /dev/sde1
No valid Btrfs found on /dev/sde1"

So I would like to ask for help to recover data from this btrfs raid array. In
my opinion I think that TrueCrypt only overwrite a little location in device
because I haven't done anything with TrueCrypt device after that.

Thanks
Chalet16


PS. I have recently known that TrueCrypt is in "Forbidden items" list in Fedora
wiki, but this is not really related to TrueCrypt so please don't ban me because
I had used TrueCrypt.
