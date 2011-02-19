From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: bug#8001: cp (8.10) sparse handling fails on compressed btrfs
 (cp/fiemap-2)
Date: Sat, 19 Feb 2011 23:22:15 +0000
Message-ID: <4D6050A7.5090407@draigBrady.com>
References: <201102072253.34476.vapier@gentoo.org> <4D52730A.2080008@draigBrady.com> <201102191328.42067.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: 8001@debbugs.gnu.org,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102191328.42067.vapier@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 19/02/11 18:28, Mike Frysinger wrote:
> based on other threads (which i havent been following too closely), d=
id we=20
> settle on this being a btrfs bug ?
> -mike

Nope, cp 8.10 is not absolved yet.
It may be btrfs not honoring FIEMAP_FLAG_SYNC,
and/or it may be cp needing to handle FIEMAP_EXTENT_ENCODED
specially.

It would help if you ran `sync` before the copy,
to exclude that as a possible issue.

Also `filefrag -v` output for the file on
the compressed BTRFS file system would be helpful.

thanks,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
