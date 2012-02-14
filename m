From: Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH 00/21] Btrfs: restriper
Date: Tue, 14 Feb 2012 18:44:27 +0200
Message-ID: <20120214164427.GA19172@zambezi.lan>
References: <1325860269-15013-1-git-send-email-idryomov@gmail.com>
 <CALJXSJpjmb2F=fg_KML_W61gRPfiFH8Drz-H+uukn9d4owdwTg@mail.gmail.com>
 <20120214141843.GA1987@zambezi.lan>
 <CALJXSJpXZL8cx=TvuoGhnh9s8VukWn=Ou3q9Pu=ob6BwqBkoqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: =?utf-8?B?SsOpcsO0bWU=?= Poulin <jeromepoulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALJXSJpXZL8cx=TvuoGhnh9s8VukWn=Ou3q9Pu=ob6BwqBkoqg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 14, 2012 at 11:15:39AM -0500, J=C3=A9r=C3=B4me Poulin wrote=
:
> On Tue, Feb 14, 2012 at 9:18 AM, Ilya Dryomov <idryomov@gmail.com> wr=
ote:
> >
> > Just to be sure, could you please paste the output of
> > `btrfs-debug-tree -d <your device>' somewhere ?
>=20
> Here it is: http://paste.pocoo.org/show/550900/

So I was correct, you have one system chunk, and it happens to start at
logical 0.  Balancing code simply skips it, I'll fix that.

Thanks,

		Ilya
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
