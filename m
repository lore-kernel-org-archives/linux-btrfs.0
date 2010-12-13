From: Paul Komkoff <i@stingr.net>
Subject: Re: btrfs: unable to remove the only writeable device
Date: Mon, 13 Dec 2010 14:23:50 +0000
Message-ID: <AANLkTim0ZU_b68dvYrEy2rWctUhVWLND1+9XZT76LCCt@mail.gmail.com>
References: <Pine.LNX.4.64.1009081954310.11139@claw.oc9.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Roy Keene <btrfs@rkeene.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009081954310.11139@claw.oc9.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

Sorry if it's already fixed, but with 2.6.35.6-48.fc14.x86_64, when I
do btrfs device delete /dev/blabla /btrfs kernel moves everything
except 1 gigabyte off the device, but then fails to remove it, saying
"btrfs: unable to remove the only writeable device" to dmesg.

What's even more interesting, it does that with all 3 of my devices,
and I clearly have enough free space to eject one drive.

What am I doing wrong?
Thanks.

P.S. For reference - what seems to be the same bug but from september.

On Thu, Sep 9, 2010 at 2:04 AM, Roy Keene <btrfs@rkeene.org> wrote:
> All,
>
> =A0 =A0 =A0 =A0I am using BtrFS at home for testing on my /home files=
ystem. =A0I
> started out with one disk (mkfs.btrfs /dev/sdb1) and then added anoth=
er disk
> (btrfs device add /dev/sda2 /home; btrfs filesystem balance /home).
>
> I then wanted to remove my second disk, but was unable to do so, I go=
t:
> =A0 =A0 =A0 =A0btrfs: unable to go below two devices on raid1
>
> I was told by the members of the BtrFS IRC channel that this was beca=
use my
> metadata was RAID1'd.
>
> To resolve this situation, I added an 8GB flash drive (my metadata wa=
s
> 5.99GB) and attempted to remove the drive again. =A0It ran for a whil=
e (a long
> while) and eventually returned me to the prompt. =A0It did not remove=
 the disk
> -- so I ran it again... and again... and again...
>
> I am to the point where "btrfs device delete <blah> /home" returns
> instantly, but has no effect. =A0The following is written to my kerne=
l message
> buffer whenever I try to remove ANY device from /home:
> =A0 =A0 =A0 =A0btrfs: unable to remove the only writeable device
>
> More information can be found in the attachement.
>
> I am still on my quest to remove a device from my BtrFS pool. =A0Does=
 anyone
> have any advice ?
>
> Thanks,
> =A0 =A0 =A0 =A0Roy Keene



--=20
This message represents the official view of the voices in my head
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
