From: Rui Miguel Silva <rmfrfs@gmail.com>
Subject: Re: [PATCH v2]Btrfs: pwrite blocked when writing from the mmaped buffer of the same page
Date: Fri, 28 Jan 2011 18:27:17 +0000
Message-ID: <201101281827.17306.rmfrfs@gmail.com>
References: <1291887014-18447-1-git-send-email-xin.zhong@intel.com> <201101280354.36884.johannes.hirte@fem.tu-ilmenau.de> <1296233241.11428.23.camel@mainframe>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Cc: xin.zhong@intel.com, linux-btrfs@vger.kernel.org,
	johannes.hirte@fem.tu-ilmenau.de
To: Maria =?utf-8?q?Wikstr=C3=B6m?= <maria@ponstudios.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296233241.11428.23.camel@mainframe>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday, January 28, 2011 04:47:21 pm Maria Wikstr=C3=B6m wrote:
> fre 2011-01-28 klockan 03:54 +0100 skrev Johannes Hirte:
> > On Friday 28 January 2011 02:26:43 Zhong, Xin wrote:
> > > Please try the fix in below link:
> > > http://www.spinics.net/lists/linux-btrfs/msg08051.html
> > >=20
> > > Thanks!
> >=20
> > This doesn't fix it for me. At least there is a difference. Whereas=
 the
> > svn process started consuming 100% CPU without any further interact=
ion
> > before, the system just hang now. The svn process starts eating the=
 CPU
> > when I cancel the emerge via ctrl-c. Additional I see a flush-btrfs=
 task
> > now consuming CPU time.
> >=20
> > regards,
> >=20
> >   Johannes
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btr=
fs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> The patch makes the process exit cleanly but complains that there is =
no
> space left. It should be a few GB but it is only a few MB!? I delete =
5GB
> and controls that the space is usable. Try again but this time it alm=
ost
> hangs the system, I can blink the leds and move the mouse but noting
> more.
> I boot 2.6.36.1 and use a snapshot as root, "emerge libgcrypt" compil=
es
> and installs fine. Boots back into 2.6.37 and try again and the syste=
m
> hangs again.
>=20
> // Maria
>=20

Hi Maria,
I had something similar with vanilla 2.6.37 just for running:
cscope -R -b -q

allways hang complety the process, only solution reboot.
I just applied the  btrfs patches that arrived in the main tree between=
 the=20
2.6.37 and 2.6.38-rc1 and they seem to fix the issue.

I did not have the time to try to found which patch fixed the problem.

Hope this could help you.

Cheers,
  //Rui
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
