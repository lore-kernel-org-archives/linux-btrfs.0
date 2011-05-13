From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: Understanding DF, etc.
Date: 13 May 2011 21:50:00 +0200
Message-ID: <BlnToEqD1uB@helmut.hullen.de>
References: <1305284038.3052.46.camel@tethys>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1305284038.3052.46.camel@tethys>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Sw=E2mi,

Du meintest am 13.05.11:

> I have trouble understanding this, which doesn't really correspond to
> the wiki FAQ (so my question is hopefully not a FAQ ;-) :

> # btrfs fi df /
> Data: total=3D74.01GB, used=3D72.77GB
> System, DUP: total=3D8.00MB, used=3D16.00KB
> System: total=3D4.00MB, used=3D0.00
> Metadata, DUP: total=3D1.75GB, used=3D657.48MB
> Metadata: total=3D8.00MB, used=3D0.00

> Some questions are :

> What are the "DUP" lines compared to the "non-DUP" ones ?

That may depend on the "mkfs.btrfs" options - which options have you =20
set?

What tells

        df -t btrfs

        btrfs filesystem show

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
