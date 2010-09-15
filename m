From: Josh Berry <des@condordes.net>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 15:19:14 -0700
Message-ID: <AANLkTimvPVqMTr1Dbp_ATGHLduajHJA0KdkjF5ry7JuT@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
	<AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
	<201009142125.56710.kreijack@libero.it>
	<AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
	<AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
	<AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
	<m362y6n2ae.fsf@pullcord.laptop.org>
	<AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
	<m31v8un08c.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Nicol <davidnicol@gmail.com>, kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m31v8un08c.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 15, 2010 at 14:52, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =C2=A0 > Or make --sync the default behavior. =C2=A0This is probably =
what most
> =C2=A0 > people are expecting anyway (similar to how standard filesys=
tem
> =C2=A0 > commands like "rm" work). =C2=A0Add an --aysnc option for th=
ose that
> =C2=A0 > only care about knowing when the subvolume is taken out of t=
he
> =C2=A0 > tree.
>
> Yeah. =C2=A0We've also talked about making snapshot _creation_ perfor=
m an
> FS sync first by default, since otherwise you get a snapshot with sta=
le
> files, or without files that existed (not yet on disk) at creation-ti=
me.

Oh wow, I didn't know this.  Yes, sync-before-create would be nice.

*runs off to update his snapshot script*

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
