From: cwillu <cwillu@cwillu.com>
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 13:09:00 -0600
Message-ID: <BANLkTikf4SUHHp52+GTYrSyE90yEDGwXDw@mail.gmail.com>
References: <201105031227.43619.CACook@quantum-sci.com>
	<20110504095153.GA6914@attic.humilis.net>
	<201105050749.09690.CACook@quantum-sci.com>
	<201105051109.35152.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105051109.35152.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 5, 2011 at 12:09 PM,  <CACook@quantum-sci.com> wrote:
>
> Anyone have a suggestion?
>
> Also on another machine set up similarly, I now cannot mkdir. =C2=A0I=
t says 'no space left on device'. =C2=A0df says:
> # df /dev/sdb
> Filesystem =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 1K-blocks =C2=A0 =C2=A0=
 =C2=A0Used Available Use% Mounted on
> /dev/sdb =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 3907029168 2658010=
524 1246486516 =C2=A069% /home
>
> sdb and sdc are one btrfs 'raid' volume. =C2=A0What could be wrong?

Which kernel version (uname -a), and what's the output of "btrfs fi df
/home" and "sudo btrfs fi show /dev/sdb"?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
