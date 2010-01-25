From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to
	read the system array on sda"
Date: Sun, 24 Jan 2010 21:00:09 -0800
Message-ID: <c67eed301001242100x92e5fc2s6e130ed6ccf3b97d@mail.gmail.com>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
	 <201001240902.38535.kreijack@libero.it>
	 <c67eed301001240846y74ec4cdajdf2b07934782eaae@mail.gmail.com>
	 <23a15591001241535h3768f413iee4bde3214a07bc5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Leszek Ciesielski <skolima@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <23a15591001241535h3768f413iee4bde3214a07bc5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 24, 2010 at 3:35 PM, Leszek Ciesielski <skolima@gmail.com> =
wrote:
>> how would that, then, get handled for automount @ boot via fstab? =A0=
i
>> guess that the scan needs to get done as well ...
>> --
>
> Please see this discussion:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/4126/focus=3D41=
87

Thanks for the reference.

@ that link,

  "Would this option ["mount -t btrfs -o device=3D/dev/sdb2 /dev/sda2
  /mnt"] work on boot, bypasing the need for "btrfsctl -a" to mount a
  multi-device filesystem?"


would translate how, in my case, to an fstab entry?

   /dev/sda    /mnt    btrfs
device=3D/dev/sdb,device=3D/dev/sdc,device=3D/dev/sdd     1 2

?

thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
