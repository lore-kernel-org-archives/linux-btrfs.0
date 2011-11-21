From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Re: mount errors
Date: Mon, 21 Nov 2011 11:27:24 -0500
Message-ID: <ad43919226351cd8f695a0dfc44adc81@www.jots.org>
References: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=fixed
To: linux-btrfs@vger.kernel.org,
	"=?UTF-8?B?UmVuw6k=?= Vangsgaard" <rene.vangsgaard@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPWZyXa84avAjPfsv0FS8L67+uWSk0LKj7pUvLT3JM+bE4wwag@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

1) As of right now, btrfs's fsck is "done when it's done."  So don't ho=
ld your
breath, I'm afraid.

2) What errors do you get on mount?  It may be as simple as changing yo=
ur fstab
entry such that fsck isn't attempted to be run.  (Change the last colum=
n to
"0".) =20

-Ken


On Sat, 19 Nov 2011 14:01:41 +0100 Ren=C3=A9 Vangsgaard <rene.vangsgaar=
d@gmail.com>
wrote

> Hi - I have been using btrfs on /home for 2 weeks, and now it mounts
> with errors. I know that no fsck is available yet. I ignore the error
> and it still works, for now. Can I do anything to help you debug this
> problem with btrfs?
> Any news on fsck for btrfs?
>=20
> I am running Ubuntu 11.10.
> Thank you, Ren=C3=A9
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html





--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
