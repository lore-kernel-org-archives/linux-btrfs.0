From: Maria =?ISO-8859-1?Q?Wikstr=F6m?= <maria@ponstudios.se>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped
 buffer of the same page
Date: Sat, 29 Jan 2011 16:38:56 +0100
Message-ID: <1296315536.11437.66.camel@mainframe>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com>
	 <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de>
	 <1296233241.11428.23.camel@mainframe> <201101281827.17306.rmfrfs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: xin.zhong@intel.com, linux-btrfs@vger.kernel.org,
	johannes.hirte@fem.tu-ilmenau.de
To: Rui Miguel Silva <rmfrfs@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101281827.17306.rmfrfs@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

fre 2011-01-28 klockan 18:27 +0000 skrev Rui Miguel Silva:=20
> On Friday, January 28, 2011 04:47:21 pm Maria Wikstr=C3=B6m wrote:
> > fre 2011-01-28 klockan 03:54 +0100 skrev Johannes Hirte:
> > > On Friday 28 January 2011 02:26:43 Zhong, Xin wrote:
> > > > Please try the fix in below link:
> > > > http://www.spinics.net/lists/linux-btrfs/msg08051.html
> > > >=20
> > > > Thanks!
> > >=20
> > > This doesn't fix it for me. At least there is a difference. Where=
as the
> > > svn process started consuming 100% CPU without any further intera=
ction
> > > before, the system just hang now. The svn process starts eating t=
he CPU
> > > when I cancel the emerge via ctrl-c. Additional I see a flush-btr=
fs task
> > > now consuming CPU time.
> > >=20
> > > regards,
> > >=20
> > >   Johannes
> > >=20
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-b=
trfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.htm=
l
> >=20
> > The patch makes the process exit cleanly but complains that there i=
s no
> > space left. It should be a few GB but it is only a few MB!? I delet=
e 5GB
> > and controls that the space is usable. Try again but this time it a=
lmost
> > hangs the system, I can blink the leds and move the mouse but notin=
g
> > more.
> > I boot 2.6.36.1 and use a snapshot as root, "emerge libgcrypt" comp=
iles
> > and installs fine. Boots back into 2.6.37 and try again and the sys=
tem
> > hangs again.
> >=20
> > // Maria
> >=20
>=20
> Hi Maria,
> I had something similar with vanilla 2.6.37 just for running:
> cscope -R -b -q
>=20
> allways hang complety the process, only solution reboot.
> I just applied the  btrfs patches that arrived in the main tree betwe=
en the=20
> 2.6.37 and 2.6.38-rc1 and they seem to fix the issue.
>=20
> I did not have the time to try to found which patch fixed the problem=
=2E
>=20
> Hope this could help you.
>=20
> Cheers,
>   //Rui

I have tried with both vanilla 2.6.38-rc2 and btrfs-unstable from git,
both having the problem.=20

Btrfs-unstable with the patch above behaves differently. The process ca=
n
be killed with Ctrl + C but then the terminal and gnome-pty-helper eats
cpu instead. They can be killed with SysRq + i together with everything
else.

// Maria


--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
