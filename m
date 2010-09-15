From: David Nicol <davidnicol@gmail.com>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving
 an IOCTL number; other details]
Date: Wed, 15 Sep 2010 15:54:40 -0500
Message-ID: <AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
 <201009131923.53227.kreijack@libero.it> <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
 <201009142125.56710.kreijack@libero.it> <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
 <AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 15, 2010 at 1:41 PM, Josh Berry <des@condordes.net> wrote:
> Personally, I like "gc" or "clean". =C2=A0"wait-subvolume-deletion",
> "garbage-collect" or similar is too verbose for my taste.
>
> -- Josh

the question IMO is how much implementation details to saddle the user
with. Anything with the word "garbage" in it is just yucky; anything
with "wait" is revealing an implementation detail that hopefully will
change eventually.

adding a --wait or --sync switch to the delete command is certainly
possible, you'd want to add it to the last in a series of deletes.

I don't like "clean" for end-user API because it seems to imply
erasing data, like it's going to get overwritten with zeroes or
something like that to hide it from forensic analysis.

among the listings at http://thesaurus.com/browse/recycle "reclaim"
seems best: "salvage" connotes that the thing being salvaged is
damaged.

Is everyone happy with

  btrfs filesystem reclaim <path> [ms]

then? (I'm pleasantly surprised that I'm not having to defend milliseco=
nds.)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
