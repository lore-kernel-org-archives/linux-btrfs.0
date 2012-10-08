Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:33800 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751190Ab2JHNBp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 09:01:45 -0400
Message-ID: <5072CEB6.6030709@gmx.net>
Date: Mon, 08 Oct 2012 15:01:42 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?matthieu_Barth=E9lemy?= <bonsouere@gmail.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: working quota example?
References: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com>
In-Reply-To: <CAK=A7Ef2jTckd216+EVmYZhiArMWZrnWxe2K_aAF2C7ZL3pDHw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08.10.2012 14:09, matthieu Barthélemy wrote:
> Hi all,
> 
> I tried without success to get a working Btrfs+quota setup.
> I created a new Btrfs filesystem on a new
> partition, then activated quota management ('btrfs quota enable'), and
> created a few subvolumes.
> I created a qgroup (with id 100) with 'btrfs qgroup create', and tried to
> apply a quota on one of my subvolumes using 'btrfs qgroup limit'
> 
> So far I've been unable to get this working, I can create a file (using dd)
> inside the subvolume that will happily eat all my FS space without triggering
> anything that could look like a quota limitation.
> btrfs-progs help is not really useful, it's more like a quick reminder than
> a real 'help'.
> So I have 2 questions for experimented Btrfs developers and users:
> -Could someone post a working example of a quota configuration on 1 or
> several subvolumes? Minimal/simplest working configuration.

# mkfs.btrfs /dev/sdx

WARNING! - Btrfs cloned-148-g8935d84 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/sdx
        nodesize 4096 leafsize 4096 sectorsize 4096 size 931.51GB
Btrfs cloned-148-g8935d84
# mount /dev/sdx /mnt/test
# btrfs quota enable /mnt/test
# btrfs sub create /mnt/test/sub1
Create subvolume '/mnt/test/sub1'
# dd if=/dev/zero of=/mnt/test/sub1/file1 bs=1048576 count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.000873268 s, 1.2 GB/s
# sync
# btrfs qgroup show /mnt/test
0/257 1052672 1052672

> -How can I see the used/remaining space for each subvolume that has a quota
> set (I guess it should be done with 'btrfs qgroup show ' but its output is
> rather terse (returns '0/100 0 0' on my system).
>  

Right. 2 things to note:
 a) quota only shows up after some time. To enforce this, you can sync the fs.
 b) The output is too terse, some UI design is necessary here. The output
    means:

qgroup references exclusive
0/257  1052672    1052672

Please refer here <http://sensille.com/qgroups.pdf> for a discussion of the
meaning of those values.
Your mistake was to create the group 0/100 yourself. The command qgroup
create is only needed to create quota groups of subvolumes.

To limit the subvol:

# btrfs qgroup limit 2m /mnt/test/sub1
# dd if=/dev/zero of=/mnt/test/sub1/file1 bs=10485760 count=1
dd: writing `/mnt/test/sub1/file1': Disk quota exceeded
1+0 records in
0+0 records out
1966080 bytes (2.0 MB) copied, 0.0056283 s, 349 MB/s

Hope that helps :)

-Arne

> Thanks in advance for your help, and all the work done to bring us so many
> features.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

