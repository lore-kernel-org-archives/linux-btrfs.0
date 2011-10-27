From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Fri, 28 Oct 2011 05:32:51 +0700
Message-ID: <CAG1y0scDZtDg04uKhbpiiuA=W44o3rL2ofoYzEEvme0SxxL+0Q@mail.gmail.com>
References: <47bc8413b603ceebfb85404d10cdc5f3@www.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Ken D'Ambrosio" <ken@jots.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <47bc8413b603ceebfb85404d10cdc5f3@www.jots.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 27, 2011 at 10:22 PM, Ken D'Ambrosio <ken@jots.org> wrote:
> So, I was trying to downgrade my Ubuntu last night, and, before doing=
 anything
> risky like that, I backed up my disk via dd to an image on an externa=
l disk.

some of us make use of snapshot/clone, whether it's using btrfs or zfs =
:)

> So, I dd'd everything back, and now it crashes on boot. =A0Booting to=
 a 2.6.x
> kernel (which is what I had on-hand on a USB drive) mounts it, but do=
esn't let
> me *do* anything (though it spews btrfs errors in dmesg).

What do you mean don't let you do anything? Can you mount it read-only
and copy the data off the disk?

> =A0Getting Ubuntu 11.10
> (kernel rev. 3.0.0) gives me this:

I'd try 3.1. If you use 11.10 try
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.1-oneiric/

>
> [ =A0121.226246] device fsid d657ce6a-d353-4c2c-858a-6a1f4d9e766e dev=
id 1 transid
> 217713 /dev/sda1
> [ =A0121.232430] parent transid verify failed on 100695031808 wanted =
217713 found
> 217732
> [ =A0121.232898] parent transid verify failed on 100695031808 wanted =
217713 found
> 217732
> [ =A0121.233357] parent transid verify failed on 100695031808 wanted =
217713 found
> 217732
> [ =A0121.233365] parent transid verify failed on 100695031808 wanted =
217713 found
> 217732
> [ =A0121.248231] btrfs: open_ctree failed

> As I have this complete image on-disk, I'm more than willing to try E=
xtreme
> Measures(tm), whatever that might entail.

Try getting source of btrfs-progs, do "make btrfs-zero-log", and use it=
=2E

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
