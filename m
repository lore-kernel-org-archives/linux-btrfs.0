From: Sage Weil <sage@newdream.net>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 15:33:06 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1009151531580.3434@cobra.newdream.net>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
 <201009131923.53227.kreijack@libero.it> <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
 <201009142125.56710.kreijack@libero.it> <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
 <AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
 <AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
 <m362y6n2ae.fsf@pullcord.laptop.org> <AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
 <m31v8un08c.fsf@pullcord.laptop.org> <Pine.LNX.4.64.1009151527090.3434@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josh Berry <des@condordes.net>, David Nicol <davidnicol@gmail.com>,
	kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009151527090.3434@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Sep 2010, Sage Weil wrote:
> For subvolume removal, racing doesn't seem like an issue.  Why not just 
> do
> 
> # btrfs subvolume delete /path/to/subvolume1
> # btrfs subvolume delete /path/to/subvolume2
> # ...
> # sync
> 
> ?

Nevermind, read the whole thread this time.  I'll defer to others on the 
best way to wait for the old space to be freed.

sage
