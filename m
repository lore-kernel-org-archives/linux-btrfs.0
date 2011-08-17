From: Lenz Grimmer <lenz@grimmer.com>
Subject: Re: [RFC] btrfs auto snapshot
Date: Wed, 17 Aug 2011 21:56:54 +0200
Message-ID: <CAJAd_WGL1CEDVNgLKeNOOPhAdyWTFqmX9Un5zU0ydUU+PNC8aA@mail.gmail.com>
References: <4E4B2452.9070407@oracle.com> <4E4B88BA.4030603@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4B88BA.4030603@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand,

On Wed, Aug 17, 2011 at 11:24, Anand Jain <Anand.Jain@oracle.com> wrote=
:

> And a rough implementation design is here below. (As of now this does
> not include the GNOME integration since I have no idea how to do that=
).

Very cool idea! With regards to the Gnome integration, you might want t=
o take
a look at what the Solaris folks did for Nautilus - I really liked the
UI and the
integration with ZFS:

http://src.opensolaris.org/source/xref/jds/spec-files/branches/gnome-2-=
30/patches/nautilus-14-zfs-snapshot.diff

Bye,
=C2=A0 =C2=A0 =C2=A0 =C2=A0 LenZ
--
=C2=A0Lenz Grimmer <lenz@grimmer.com> -=C2=A0 http://www.lenzg.net/
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
