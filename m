From: Josh Berry <des@condordes.net>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 14:46:46 -0700
Message-ID: <AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
	<AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
	<201009142125.56710.kreijack@libero.it>
	<AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
	<AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
	<AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
	<m362y6n2ae.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Nicol <davidnicol@gmail.com>, kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m362y6n2ae.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 15, 2010 at 14:07, Chris Ball <cjb@laptop.org> wrote:
> Hi,
>
> =C2=A0 > adding a --wait or --sync switch to the delete command is
> =C2=A0 > certainly possible, you'd want to add it to the last in a se=
ries
> =C2=A0 > of deletes.
>
> I think this (--sync) is a much better idea than the alternatives so =
far.

Or make --sync the default behavior.  This is probably what most
people are expecting anyway (similar to how standard filesystem
commands like "rm" work).  Add an --aysnc option for those that only
care about knowing when the subvolume is taken out of the tree.

But I agree, an option to "subvolume delete" is probably better.

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
