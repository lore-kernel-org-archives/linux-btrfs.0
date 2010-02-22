From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [PATCH 0/3 V3] btrfs: a new tool to manage a btrfs filesystem
Date: Sun, 21 Feb 2010 21:33:05 -0800
Message-ID: <93cdabd21002212133o3d257fa6t29d67059e80eb98a@mail.gmail.com>
References: <201002211740.13074.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
	Thomas Kupper <thomas@kupper.org>,
	"Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>,
	rk <rkasl@computer.org>
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002211740.13074.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 21, 2010 at 8:40 AM, Goffredo Baroncelli <kreijack@gmail.co=
m> wrote:
> =C2=A0 =C2=A0 =C2=A0 filesystem resize [+/-]<size>[gkm]|max <filesyst=
em>

-filesystem resize [+/-]<size>[gkm]|max <filesystem>
+filesystem resize [+/-]<size>[gkm]|max <dev>

This command works on devices, not paths.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Resize a filesystem i=
dentified by <path>. =C2=A0The <size> parame=E2=80=90

-Resize a filesystem identified by <path>.  The <size> parame=E2=80=90
+Resize a filesystem identified by <dev>.  The <size> parame=E2=80=90

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ter =C2=A0specifies t=
he new size of the filesystem. =C2=A0If the prefix
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0+ or - is present the=
 size is increased or decreased =C2=A0by =C2=A0the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0quantity =C2=A0<size>=
=2E =C2=A0If no units are specified, the unit of the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0<size> parameter defa=
ults =C2=A0to =C2=A0bytes. =C2=A0Optionally, =C2=A0the =C2=A0size
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0parameter =C2=A0may =C2=
=A0be suffixed by one of the following the units
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0designators: 'K', 'M'=
, or 'G', kilobytes, megabytes, or giga=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bytes, respectively.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0If =C2=A0'max' is pas=
sed, the filesystem will occupy all available
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0space on the volume(s=
).
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0The resize command do=
es not manipulate the size of underlying
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0partitions. =C2=A0 If=
 you wish to enlarge/reduce a filesystem, you

-partitions.   If you wish to enlarge/reduce a filesystem, you
+partition.   If you wish to enlarge/reduce a filesystem, you

> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0must make sure you ca=
n expand/reduce the size of =C2=A0the =C2=A0parti=E2=80=90
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tion also.

-must make sure you can expand/reduce the size of  the  parti=E2=80=90
-tion also.
+must make sure you can expand the partition before enlarging
+the filesystem and shrink the partition after reducing the size
+of the filesystem.

>
>
> =C2=A0 =C2=A0 =C2=A0 filesystem show [<uuid>|<label>]
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Show =C2=A0the =C2=A0=
btrfs =C2=A0filesystem with some additional info. If no
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0UUID or label is pass=
ed, btrfs show info =C2=A0of =C2=A0all =C2=A0the =C2=A0btrfs
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0filesystem.
>
>
> =C2=A0 =C2=A0 =C2=A0 device balance|-b <path>

-device balance|-b <path>
+device balance <path>

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
