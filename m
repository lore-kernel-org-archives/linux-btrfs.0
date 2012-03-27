From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs csum failed, scrub ok
Date: Tue, 27 Mar 2012 10:24:32 -0600
Message-ID: <CAE5mzvh57pD_FTonZNEfH0a0o-oPNKo7OsGR3hSi_5oEW0mNGQ@mail.gmail.com>
References: <87haxawbtw.fsf@falma.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Christoph Groth <cwg@falma.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87haxawbtw.fsf@falma.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2012 at 4:57 AM, Christoph Groth <cwg@falma.de> wrote:
> I have a freshly installed system with btrfs as the root file system.
> The machine is running linux 3.2. =C2=A0The raid1 btrfs file system l=
ives on
> two new hard drives.
>
> About one day after installation the following message appeared in
> kern.log. =C2=A0There were no other errors.
>
> root@mim:/var/log# grep 'btrfs.*fail' kern.log
> Mar 27 01:07:46 mim kernel: [ 6480.233861] btrfs csum failed ino 4535=
09 off 1495040 csum 3301532933 private 4156998194
> Mar 27 01:07:46 mim kernel: [ 6480.234470] btrfs csum failed ino 4535=
09 off 1499136 csum 1873118812 private 3512102188
> Mar 27 01:07:46 mim kernel: [ 6480.234572] btrfs csum failed ino 4535=
09 off 1503232 csum 1034640717 private 2041007647
> Mar 27 01:07:46 mim kernel: [ 6480.234670] btrfs csum failed ino 4535=
09 off 1507328 csum 889729013 private 2342095239
> Mar 27 01:07:46 mim kernel: [ 6480.237977] btrfs csum failed ino 4535=
09 off 1503232 csum 1518679450 private 2041007647
> Mar 27 01:07:46 mim kernel: [ 6480.238149] btrfs csum failed ino 4535=
09 off 1507328 csum 889729013 private 2342095239
> Mar 27 01:07:46 mim kernel: [ 6480.238330] btrfs csum failed ino 4535=
09 off 1495040 csum 3234580989 private 4156998194
> Mar 27 01:07:46 mim kernel: [ 6480.238447] btrfs csum failed ino 4535=
09 off 1499136 csum 1873118812 private 3512102188
> Mar 27 01:07:46 mim kernel: [ 6480.243873] btrfs csum failed ino 4535=
09 off 1503232 csum 2184012753 private 2041007647
> Mar 27 01:07:46 mim kernel: [ 6480.243962] btrfs csum failed ino 4535=
09 off 1507328 csum 240604621 private 2342095239
>
> inode 453509 belongs to a file installed by dpkg
>
> root@mim:/# find / -inum 453509 -ls
> 453509 1976 -rw-r--r-- =C2=A0 1 root =C2=A0 =C2=A0 root =C2=A0 =C2=A0=
 =C2=A02020832 Mar =C2=A07 21:11 /usr/lib/libreoffice/basis3.4/program/=
libsblx.so
>
> That file seems to be ok, there are no errors when re-reading it.
>
> A scrub done the morning after the incident also didn't find any
> problems:
>
> root@mim:/home/cwg# btrfs scrub status /
> scrub status for 2da00153-f9ea-4d6c-a6cc-10c913d22686
> =C2=A0 =C2=A0 =C2=A0 =C2=A0scrub started at Tue Mar 27 10:37:49 2012 =
and finished after 3921 seconds
> =C2=A0 =C2=A0 =C2=A0 =C2=A0total bytes scrubbed: 550.20GB with 0 erro=
rs

If btrfs is able to find a good copy, it will fix the bad copy automati=
cally.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
