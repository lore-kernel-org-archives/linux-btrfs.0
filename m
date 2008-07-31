From: "Yan Zheng" <zheng.yan@oracle.com>
Subject: Re: Kernel oops after compile error
Date: Thu, 31 Jul 2008 09:11:29 +0800
Message-ID: <3d0408630807301811l45f94721tfa925a81a7ad40d2@mail.gmail.com>
References: <1905261913@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Marcel Runte" <marcel.runte@web.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1905261913@web.de>
List-ID: <linux-btrfs.vger.kernel.org>

2008/7/31 Marcel Runte <marcel.runte@web.de>:
> Hello,
>
> I fiddled around with btrfs this evening and need some further insigh=
t into this error.
>
> During compilation this error occurs:
>
> /home/runtema/btrfs_build/kernel-9da425337329/file.c: In Funktion =BB=
btrfs_file_write=AB:
> /home/runtema/btrfs_build/kernel-9da425337329/file.c:851: Warnung: =DC=
bergabe des Arguments 1 von =BBremove_suid=AB von inkompatiblem Zeigert=
yp
>
> As you see, I used a newer release from kernel.org to build btrfs. Th=
e german error message nearly translates into: "Warning: Handover of ar=
gument 1 of =BBremove_suid=AB is of incompatible pointertype."
>
> Rest of compilation is OK. Compilation of brtfs-progs is OK.
>

This is a known issue caused by AppArmor. See following URL.

http://oss.oracle.com/pipermail/btrfs-devel/2008-February/000491.html

Regards
YZ
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
