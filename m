From: "Norbert Scheibner" <scno@gmx.net>
Subject: Freeing space over reboot question
Date: Thu, 09 Feb 2012 18:42:32 +0100
Message-ID: <20120209174232.318280@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Gl=C3=BCck Auf!
I use now kernel 3.2. The filesystem was originally created under 2.6.3=
9 on 1 whole hdd, mounted with "noatime,nodiratime,inode_cache". I use =
it for backups: rsync the whole system to a subvolume, snapshot it and =
then delete some tempfiles in the snapshot, which are 90% of the full-b=
ackup, all once a day. In figures: on this 1 TB hdd is the full-backup =
with around 600 GiB and 10 to 20 snapshots with around 30 GiB each, all=
 together using around 700 GiB on disc.

What I did:
- I deleted (by accident) the big subvolume with the full-backup with "=
btrfs subvolume delete" and recreated it with the same name with a snap=
shot of the latest snapshot.
- During the deletion of this big subvolume in background I changed the=
 kernel from 3.1 to 3.2 and did a reboot.
- After that, the fs was operational, but the space was still used and =
the next system-backup onto this fs failed with no space left errors. "=
btrfs filesystem df" showed me that the fs used the whole hdd and that =
there were only some kB free, which fits to the errors from rsync durin=
g backup.

So the used space of subvolume I deleted, was not freed.

How to get the space back which should have been freed?
A balance did not help. What worked was the deletion of that half-fille=
d subvolume, which I use for the full backup. After that the space got =
freed and the next balance run shrinked the fs again, so that it uses o=
nly a part of the hdd.

What I wonder is: Couldn't this be a little bit more user-friendly?

If there is a background process running like this here, freeing some s=
pace, should the umount take as long as the background process or shoul=
d the background process stop immediately and restart after the next mo=
unt (if possible, especially with a kernel change in between or the pos=
sibility that the fs gets mounted read-only)?

=2E.. Or is this all nonsense and it happened here because I rebooted a=
nd after that used another kernel.

My best wishes
    Norbert
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
