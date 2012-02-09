From: Chester <somethingsome2000@gmail.com>
Subject: Re: Freeing space over reboot question
Date: Thu, 9 Feb 2012 12:11:19 -0600
Message-ID: <CAAE6i0j02XLf3OGCj_6osrGZpe-Dd9PLmaAg5dB-EzzFJUpQnw@mail.gmail.com>
References: <20120209174232.318280@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Norbert Scheibner <scno@gmx.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120209174232.318280@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 9, 2012 at 11:42 AM, Norbert Scheibner <scno@gmx.net> wrote=
:
> Gl=FCck Auf!
> I use now kernel 3.2. The filesystem was originally created under 2.6=
=2E39 on 1 whole hdd, mounted with "noatime,nodiratime,inode_cache". I =
use it for backups: rsync the whole system to a subvolume, snapshot it =
and then delete some tempfiles in the snapshot, which are 90% of the fu=
ll-backup, all once a day. In figures: on this 1 TB hdd is the full-bac=
kup with around 600 GiB and 10 to 20 snapshots with around 30 GiB each,=
 all together using around 700 GiB on disc.
>
> What I did:
> - I deleted (by accident) the big subvolume with the full-backup with=
 "btrfs subvolume delete" and recreated it with the same name with a sn=
apshot of the latest snapshot.
> - During the deletion of this big subvolume in background I changed t=
he kernel from 3.1 to 3.2 and did a reboot.
> - After that, the fs was operational, but the space was still used an=
d the next system-backup onto this fs failed with no space left errors.=
 "btrfs filesystem df" showed me that the fs used the whole hdd and tha=
t there were only some kB free, which fits to the errors from rsync dur=
ing backup.
>
> So the used space of subvolume I deleted, was not freed.
>
> How to get the space back which should have been freed?
> A balance did not help. What worked was the deletion of that half-fil=
led subvolume, which I use for the full backup. After that the space go=
t freed and the next balance run shrinked the fs again, so that it uses=
 only a part of the hdd.
>
> What I wonder is: Couldn't this be a little bit more user-friendly?
>
> If there is a background process running like this here, freeing some=
 space, should the umount take as long as the background process or sho=
uld the background process stop immediately and restart after the next =
mount (if possible, especially with a kernel change in between or the p=
ossibility that the fs gets mounted read-only)?
>

A similar thing has happened to me recently. The snapshot deletion
happens asynchronously and should continue after a reboot (in my
case). If you boot up your system and leave it idle, take a look at
iotop. You might see a [btrfs-cleaner] doing some work.

> ... Or is this all nonsense and it happened here because I rebooted a=
nd after that used another kernel.
>
> My best wishes
> =A0 =A0Norbert
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
