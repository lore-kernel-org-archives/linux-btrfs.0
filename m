Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47165 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147AbbFDXZo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Jun 2015 19:25:44 -0400
Message-ID: <5570DE64.5020104@oracle.com>
Date: Fri, 05 Jun 2015 07:25:24 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Roger Binns <rogerb@rogerbinns.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs device ready non-success exit code
References: <mkq3i4$r5d$1@ger.gmane.org>
In-Reply-To: <mkq3i4$r5d$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/05/2015 01:57 AM, Roger Binns wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> This is on current Ubuntu 15.04.  What is device ready unhappy with?
> Note that the root filesystem and /home (both subvolumes of this) are
> mounted and working perfectly, and even where the commands are run from.
>
> $ sudo btrfs fi show /dev/sda1
> Label: 'main'  uuid: 3ff68715-0daa-4e44-8de2-0997f36d8ab6
> 	Total devices 2 FS bytes used 417.22GiB
> 	devid    2 size 894.25GiB used 362.03GiB path /dev/sdb1
> 	devid    3 size 894.25GiB used 362.03GiB path /dev/sda1
>
> Btrfs v3.17
> $ sudo btrfs fi show /
> Label: 'main'  uuid: 3ff68715-0daa-4e44-8de2-0997f36d8ab6
> 	Total devices 2 FS bytes used 417.22GiB
> 	devid    2 size 894.25GiB used 362.03GiB path /dev/sdb1
> 	devid    3 size 894.25GiB used 362.03GiB path /dev/sda1
>
> Btrfs v3.17
> $ sudo btrfs device ready /dev/sda1 ; echo $?
> 1
> $ sudo btrfs device ready /dev/sdb1 ; echo $?
> 1


typically ready cli is to check disk pool status in an unmounted state.

Strictly we wanted ready cli to be a read only cli, but it updates the 
device path as well, which eventually I think we will fix it, if the
systemd won't compliant about it.

-Anand


> $ uname -a
> Linux workstation 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> Roger
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
>
> iEYEARECAAYFAlVwkX4ACgkQmOOfHg372QTEjQCgmhFU8Gxx8VOeNay2fkJjgpaU
> ZOEAn18pogQVQnS8AzPzSEY7gu6rH+q3
> =foM6
> -----END PGP SIGNATURE-----
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
