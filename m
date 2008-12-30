From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: A bug with multiple devices?
Date: Tue, 30 Dec 2008 19:35:17 +0800
Message-ID: <3d0408630812300335s4e7c6cf1x9a45ff187b80f83@mail.gmail.com>
References: <49597D06.1050806@cn.fujitsu.com>
	 <200812302145.25796.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Chris Samuel" <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200812302145.25796.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2008/12/30 Chris Samuel <chris@csamuel.org>:
> On Tue, 30 Dec 2008 12:44:38 pm Shen Feng wrote:
>
>> I think the partition size is no correct since this is a raid-1 partition.
>> The size should be half.
>
> I've just run into this myself and so can confirm this issue on a btrfs
> filesystem with 2 devices, where it is created by doing:
>
> mkfs.btrfs -m raid1 /dev/sda10 /dev/sda11
>
> modprobe btrfs
>
> btrfsctl -a
>
> mount /dev/sda10 /home
>
> The df command shows it has twice the space I was expecting (61GB rather than
> 30GB).  The btrfs-show command shows that it has two devices but doesn't
> appear to contain any way to show the RAID level implemented.    I get the
> same outcome if I mount /dev/sda11 instead of sda10.
>
> Any ideas ?
>

This is a known bug. In btrfs, chunks are created dynamically and may have
different RAID configurations.  So it's difficult to compute the space
in advance.

Regards
Yan Zheng
