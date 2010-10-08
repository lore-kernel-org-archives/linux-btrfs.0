From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Slow link/Capacity changed + Kernel OOPS... possible hardware
 issues, ideas?
Date: Fri, 8 Oct 2010 10:53:19 -0400
Message-ID: <20101008145319.GK4804@think>
References: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 07, 2010 at 10:07:47PM -0500, C Anthony Risinger wrote:
> well after recently talking about how i haven't had any problems with
> btrfs on several machines for ~1.5yrs...
>=20
> it happens :-(
>=20
> ) 2.6.35 kernel
> ) btrfs on partition 2 of sda
> ) no special mkfs or mount options used (except ssd)
>=20
> my fianc=E9's EEE S101 netbook, w/SSD, is failing hard.  when booting
> normally (subvol=3D__active), no special boot options, it hangs at
> udev... it all started today, when it suddenly froze during normal
> use, and i was forced to hard power off.  it hasn't started up
> correctly since.  using an Archlinux rescue usb disk (archboot), i
> tried to tar + ssh backup the system to another machine (i can still
> mount the btrfs disk); i tried a couple times, and it always transfer=
s
> ~1.3MB then pukes.  the last time i managed to get the kernel log
> somehow, as it didn't lockup...
>=20
> can anyone point me in the right direction?  it looks like maybe the
> SSD is failing to me (all the "slow link" and "capacity changed to 0"
> stuff), but i really don't know.  i knew there was a reason they were
> selling these things cheap on Newegg!!!
>=20
> i have backups of important data, but i'd rather not have to set the
> damn thing up again; you know how it is :-), should have backed up th=
e
> whole system, whoopsie, next time.
>=20
> the mayhem starts with:
>=20
> "Oct  8 02:38:26 (none) kernel: btrfs bad tree block start 2463035801=
6
> 24630292480"

Ok, so the drive has decided to jumble up our blocks a little bit.  Thi=
s
message means we're finding the wrong data at a given offset.

I can help you copy things off but I don't think this FS is going to be
good any longer.  Are you interested in copying the latest bits off or
do you just want to cut your losses?

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
