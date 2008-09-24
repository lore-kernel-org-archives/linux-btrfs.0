From: Tomasz Torcz <tomek@crocom.com.pl>
Subject: Re: snapshot merging?
Date: Wed, 24 Sep 2008 12:27:02 +0200
Message-ID: <1222252022.3186.43.camel@s1.crocom.com.pl>
References: <48D63C8E.2060802@wpkg.org> <48D657DB.7050601@oracle.com>
	 <48D65ACD.7030907@wpkg.org>  <200809232034.21750.phillips@phunq.net>
	 <1222246456.26395.16.camel@telesto>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel Phillips <phillips@phunq.net>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Zheng Yan <zheng.yan@oracle.com>, linux-btrfs@vger.kernel.org
To: Eric Anopolsky <erpo41@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1222246456.26395.16.camel@telesto>
List-ID: <linux-btrfs.vger.kernel.org>

Dnia 2008-09-24, =C5=9Bro o godzinie 02:54 -0600, Eric Anopolsky pisze:
> What do people use snapshots for?
 =20
I use snapshots as "quick backup", as addition to full backups done by
Bacula. It much faster and easier to recover previous version of file
from snapshot than from backup software. Revert is not necessary.

 OpenSolaris guys use snapshots for safe system upgrade. With ability t=
o
select rootfs from before upgrade at GRUB screen and boot into older
installation. Revert is crucial in case of wedged upgrade.

--=20
Tomasz Torcz

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
