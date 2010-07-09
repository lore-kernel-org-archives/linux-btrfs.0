From: Daniel Kozlowski <dan.kozlowski@gmail.com>
Subject: Re: boot problem
Date: Fri, 9 Jul 2010 11:10:23 -0400
Message-ID: <AANLkTikuvSuH9JS4OOIqFzhycMOmlykjYdXKylUNbC1e@mail.gmail.com>
References: <i17dsv$eq3$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i17dsv$eq3$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

Lubos ,

If you have a multi-device btrfs filesystem you need to run btrfsctrl
-a to have the kernel register the filesystem. Tehre were some open
bug reports about this in various distros.

https://bugzilla.redhat.com/show_bug.cgi?id=3D498445
http://bugs.gentoo.org/show_bug.cgi?id=3D309219
http://ubuntuforums.org/showthread.php?t=3D1456494

On Fri, Jul 9, 2010 at 11:06 AM, Lubos Kolouch <lubos.kolouch@gmail.com=
> wrote:
> Hello,
>
> I added another device to the / filesystem
> (btrfs device add).
>
> Now I can't boot off it, even though kernel sees both devices
> (sda2, sdb2).
>
> Am I screwed or is there any way how to convince the kernel
> to assemble the / filesystem?
>
> Thank you
>
> Lubos
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
S.D.G.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
