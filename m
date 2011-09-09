From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Verifying TRIM support on SSDs when using BtrFS
Date: Fri, 09 Sep 2011 13:04:36 +0800
Message-ID: <4E699E64.4000204@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Shane Meyers <shane@smugmug.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

(resend with linux-btrfs Cced)

> Hi All,
>=20
> My company is considering using BtrFS for some of our production
> systems, but before we can use it, I must positively verify that the
> TRIM command is being issued to the SSDs. =E7=87=9F attempted to veri=
fy TRIM
> first using examples that work for Ext4
> <http://andyduffell.com/techblog/?p=3D852>, but I had to make changes=
 to
> the procedure to work with BtrFS.
>=20
> The server is Ubuntu 11.04 server 64-bit release (mkfs.btrfs version
> 0.19). I have installed the Linux 3.0.0 kernel as the BtrFS changelog
> states that bulk TRIM is not available in the kernel shipped with
> Ubuntu 11.04 (2.6.38).
>=20
> My testing methodology:
>=20
> * Manually TRIM the disks before starting: for i in {0..10} ; do let
> A=3D"$i * 65536" ; hdparm --trim-sector-ranges $A:65535
> --please-destroy-my-drive /dev/sda ; done
> * Verify the drive was TRIM'd: ./sectors.pl |grep + | tee sectors-$(d=
ate +%s)
> * Partition the drive: fdisk /dev/sda
> * Make the file system: mkfs.btrfs /dev/sda1
> * Mount: sudo mount -t btrfs -o ssd /dev/sda1 /mnt
> * Create a file: dd if=3D/dev/urandom of=3D/mnt/testfile bs=3D1k coun=
t=3D50000
> oflag=3Ddirect
> * Verify the file is on the disk: ./sectors.pl | tee sectors-$(date +=
%s)
> * Delete the test file: rm /mnt/testfile
> * See that the test file is TRIM'd from the disk: ./sectors.pl | tee
> sectors-$(date +%s)
> * Verify the TRIM'd blocks: diff the two most recent sectors-* files
>=20
> At this point, the pre-delete and post delete verifications still sho=
w
> the same disk blocks in use. I should instead see a reduction in the
> number of in use blocks. Waiting an hour (in case it takes a while fo=
r
> the TRIM command to be issued) after the test file is deleted still
> shows the same blocks in use.
>=20
> I have also tried mounting with the "-o ssd,discard" options, but tha=
t
> doesn't seem to help at all.
>=20
> I also posted this question at
> <http://serverfault.com/questions/307397/verify-trim-support-with-btr=
fs-on-ssd>
> but a good answer has yet to surface.  If you are interested, you can
> see my sectors.pl and a little more detail at that URL.
>=20
> Is my testing methodology flawed?  Am I missing something here?
> Thanks for your help.
>=20

Have you tried to use this methodology to test ext4? So you can verify =
if
it's flawed.

I used a much simpler way to test this, and I found btrfs works fine:

  # mount -t btrfs -o discard /dev/sdc5 /mnt
  # dd if=3D/dev/urandom of=3D/mnt/tmp bs=3D1M count=3D5
  # sync
  # hexdump /mnt/tmp
  0000000 064c ded5 c386 4721 060c 13e8 b090 b4a0
  ...
  # hexdump /dev/sdc5 | grep '064c ded5'
  0c00000 064c ded5 c386 4721 060c 13e8 b090 b4a0

Now verify the discard feature:

  # rm /mnt/tmp
  # sync
  # echo 3 > /proc/sys/vm/drop_caches
  # hexdump /dev/sdc5 | grep '064c ded5'
  (grep returns nothing, as expected)

So there's nothing wrong in btrfs.

Try the above test but without discard option, and you'll see the secto=
rs
will not be zeroed.

--
Li Zefan

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
