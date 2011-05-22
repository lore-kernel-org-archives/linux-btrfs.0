From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Subject: Re: curious writes on mounted, not used btrfs filesystem
Date: Sun, 22 May 2011 17:21:14 +0200
Message-ID: <1306077674.3416.2.camel@tethys>
References: <4DD7B6ED.5040403@wpkg.org>  <20110522093352.GA22491@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110522093352.GA22491@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Le dimanche 22 mai 2011 =C3=A0 10:34 +0100, Stephane Chazelas a =C3=A9c=
rit :
> >=20
> > I noticed that whenever I do "sync", btrfs will write for around 6.=
5s and write 13 MB (see below).
> [...]

I had also noticed here, without really paying further attention, that
external USB HDs with a BTRFS mounted, but without any open files (and
no possibly open files, these disks being only used for files backups
and no direct work, no libraries, no spools, no progs, etc...), show
some activity (LED flashing) when executing a "sync" when I would expec=
t
there's nothing to be synced on them...

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
