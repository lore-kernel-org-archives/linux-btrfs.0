From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to
	read the system array on sda"
Date: Mon, 25 Jan 2010 11:33:20 -0800
Message-ID: <c67eed301001251133i1a167415x4b94bd119be7a977@mail.gmail.com>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
	 <23a15591001241535h3768f413iee4bde3214a07bc5@mail.gmail.com>
	 <c67eed301001242100x92e5fc2s6e130ed6ccf3b97d@mail.gmail.com>
	 <201001251919.40182.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Leszek Ciesielski <skolima@gmail.com>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001251919.40182.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 25, 2010 at 10:19 AM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
>> =A0 =A0/dev/sda =A0 =A0/mnt =A0 =A0btrfs  device=3D/dev/sdb,device=3D=
/dev/sdc,device=3D/dev/sdd =A0 =A0 1 2
>
> Yes; it works for me.

thanks for the confirmation.

verifying, with that in /etc/fstab, after boot i see,

  mount | grep sda
    /dev/sda on /mnt type btrfs
(rw,device=3D/dev/sdb,device=3D/dev/sdc,device=3D/dev/sdd)

which apparenlty worked.

still, the RAID size is wrong ...

 df -H | grep sda
  /dev/sda               4.1T    29k   4.1T   1% /mnt

but that's a different thread.

thanks again.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
