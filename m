From: Evert Vorster <evorster@gmail.com>
Subject: Re: cloning single-device btrfs file system onto multi-device one
Date: Tue, 5 Apr 2011 22:45:42 -0700
Message-ID: <BANLkTimQaPNm22kN8g2ha+XrOP3uyBUE-Q@mail.gmail.com>
References: <chaz20110321162450.GB918@seebyte.com>
	<chaz20110322092259.GA4861@seebyte.com>
	<AANLkTin1++vPq904tkPOAf3ZxwWTZaQYL+=WJHetEr9h@mail.gmail.com>
	<chaz20110328131748.GA18131@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Stephane Chazelas <stephane.chazelas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110328131748.GA18131@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi there.

=46rom my limited understanding, btrfs will write metadata in raid1 by
default. So, this could be where your 2TB has gone.

I am assuming you used raid0 for the three new disks?

Also, hard-stopping a btrfs is a no-no...

Kind regards,
-Evert-

On Mon, Mar 28, 2011 at 6:17 AM, Stephane Chazelas
<stephane.chazelas@gmail.com> wrote:
> 2011-03-22 18:06:29 -0600, cwillu:
>> > I can mount it back, but not if I reload the btrfs module, in whic=
h case I get:
>> >
>> > [ 1961.328280] Btrfs loaded
>> > [ 1961.328695] device fsid df4e5454eb7b1c23-7a68fc421060b18b devid=
 1 transid 118 /dev/loop0
>> > [ 1961.329007] btrfs: failed to read the system array on loop0
>> > [ 1961.340084] btrfs: open_ctree failed
>>
>> Did you rescan all the loop devices (btrfs dev scan /dev/loop*) afte=
r
>> reloading the module, before trying to mount again?
>
> Thanks. That probably was the issue, that and using too big
> files on too small volumes I'd guess.
>
> I've tried it in real life and it seemed to work to some extent.
> So here is how I transferred a 6TB btrfs on one 6TB raid5 device
> (on host src) over the network onto a btrfs on 3 3TB hard drives
> (on host dst):
>
> on src:
>
> lvm snapshot -L100G -n snap /dev/VG/vol
> nbd-server 12345 /dev/VG/snap
>
> (if you're not lucky enough to have used lvm there, you can use
> nbd-server's copy-on-write feature).
>
> on dst:
>
> nbd-client src 12345 /dev/nbd0
> mount /dev/nbd0 /mnt
> btrfs device add /dev/sdb /dev/sdc /dev/sdd /mnt
> =A0# in reality it was /dev/sda4 (a little under 3TB), /dev/sdb,
> =A0# /dev/sdc
> btrfs device delete /dev/nbd0 /mnt
>
> That was relatively fast (about 18 hours) but failed with an
> error. Apparently, it managed to fill up the 3 3TB drives (as
> shown by btrfs fi show). Usage for /dev/nbd0 was at 16MB though
> (?!)
>
> I then did a "btrfs fi balance /mnt". I could see usage on the
> drives go down quickly. However, that was writing data onto
> /dev/nbd0 so was threatening to fill up my LVM snapshot. I then
> cancelled that by doing a hard reset on "dst" (couldn't find
> any other way). And then:
>
> Upon reboot, I mounted /dev/sdb instead of /dev/nbd0 in case
> that made a difference and then ran the
>
> btrfs device delete /dev/nbd0 /mnt
>
> again, which this time went through.
>
> I then did a btrfs fi balance again and let it run through. However h=
ere is
> what I get:
>
> $ df -h /mnt
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/sdb =A0 =A0 =A0 =A0 =A0 =A0 =A08.2T =A03.5T =A03.2T =A053% /mnt
>
> Only 3.2T left. How would I reclaim the missing space?
>
> $ sudo btrfs fi show
> Label: none =A0uuid: ...
> =A0 =A0 =A0 =A0Total devices 3 FS bytes used 3.43TB
> =A0 =A0 =A0 =A0devid =A0 =A04 size 2.73TB used 1.17TB path /dev/sdc
> =A0 =A0 =A0 =A0devid =A0 =A03 size 2.73TB used 1.17TB path /dev/sdb
> =A0 =A0 =A0 =A0devid =A0 =A02 size 2.70TB used 1.14TB path /dev/sda4
> $ sudo btrfs fi df /mnt
> Data, RAID0: total=3D3.41TB, used=3D3.41TB
> System, RAID1: total=3D16.00MB, used=3D232.00KB
> Metadata, RAID1: total=3D35.25GB, used=3D20.55GB
>
> So that kind of worked but that is of little use to me as 2TB
> kind of disappeared under my feet in the process.
>
> Any idea, anyone?
>
> Thanks
> Stephane
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-Evert-
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
