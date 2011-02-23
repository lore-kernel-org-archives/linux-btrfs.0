From: Chris Mason <chris.mason@oracle.com>
Subject: Re: bug#8001: cp (8.10) sparse handling fails on compressed btrfs (cp/fiemap-2)
Date: Tue, 22 Feb 2011 22:31:19 -0500
Message-ID: <1298431849-sup-5365@think>
References: <201102072253.34476.vapier@gentoo.org> <4D52730A.2080008@draigBrady.com> <201102191328.42067.vapier@gentoo.org> <4D6050A7.5090407@draigBrady.com> <AANLkTi=4x+RzqZRKVCreWy67eOUSocjA4c_N+9aEHeG9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Cc: =?utf-8?q?P=C3=A1draig_Brady?= <p@draigbrady.com>,
	8001 <8001@debbugs.gnu.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTi=4x+RzqZRKVCreWy67eOUSocjA4c_N+9aEHeG9@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Mike Frysinger's message of 2011-02-19 19:53:18 -0500:
> 2011/2/19 P=C3=A1draig Brady:
> > On 19/02/11 18:28, Mike Frysinger wrote:
> >> based on other threads (which i havent been following too closely)=
, did we
> >> settle on this being a btrfs bug ?
> >
> > Nope, cp 8.10 is not absolved yet.
> > It may be btrfs not honoring FIEMAP_FLAG_SYNC,
> > and/or it may be cp needing to handle FIEMAP_EXTENT_ENCODED
> > specially.
> >
> > It would help if you ran `sync` before the copy,
> > to exclude that as a possible issue.
>=20
> makes no difference after applying this patch:

I've got a fix for this on the btrfs side in testing.  It is definitely
a btrfs bug.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
