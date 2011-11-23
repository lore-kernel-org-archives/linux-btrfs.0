From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fsck with "err is 1"
Date: Wed, 23 Nov 2011 13:02:13 +0700
Message-ID: <CAG1y0sc3w1wWdTYNLgTFEtmF3x+sooZX6dpjJWMoKxV==Bce4A@mail.gmail.com>
References: <EB38FBF9-9284-4902-ABC6-B6FB6B6D4E50@orcaware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Blair Zajac <blair@orcaware.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <EB38FBF9-9284-4902-ABC6-B6FB6B6D4E50@orcaware.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 23, 2011 at 12:33 PM, Blair Zajac <blair@orcaware.com> wrot=
e:
> Hello,
>
> I'm trying btrfs in a VirtualBox VM running Ubuntu 11.10 with kernel =
3.0.0. =A0Running fsck I get a message with "err is 1".

> Does this mean there's an error? =A0Is err either always 0 or 1, or d=
oes err increment beyond 1?

I can't answer that, but I can tell you that fsck for btrfs right now
is almost useless. It can't fix anyting.

Short summary, if you can mount the fs, and can access the data, and
don't have any weird messages on syslog, then it's most likely OK.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
