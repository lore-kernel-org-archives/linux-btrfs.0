From: Sage Weil <sage@newdream.net>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 15:31:17 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1009151527090.3434@cobra.newdream.net>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
 <201009131923.53227.kreijack@libero.it> <AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
 <201009142125.56710.kreijack@libero.it> <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
 <AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
 <AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
 <m362y6n2ae.fsf@pullcord.laptop.org> <AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
 <m31v8un08c.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josh Berry <des@condordes.net>, David Nicol <davidnicol@gmail.com>,
	kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m31v8un08c.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 15 Sep 2010, Chris Ball wrote:
> Hi,
> 
>    > Or make --sync the default behavior.  This is probably what most
>    > people are expecting anyway (similar to how standard filesystem
>    > commands like "rm" work).  Add an --aysnc option for those that
>    > only care about knowing when the subvolume is taken out of the
>    > tree.
> 
> Yeah.  We've also talked about making snapshot _creation_ perform an
> FS sync first by default, since otherwise you get a snapshot with stale
> files, or without files that existed (not yet on disk) at creation-time.

Actually, that was fixed in 2.6.34 (0bdb1db2).  Creating a snapshot syncs 
all dirty data and metadata to disk, so you get a fully consistent point 
in time snapshot.  No 'sync' is necessary (and doing a 'sync' yourself 
would be racy any).

For subvolume removal, racing doesn't seem like an issue.  Why not just 
do

# btrfs subvolume delete /path/to/subvolume1
# btrfs subvolume delete /path/to/subvolume2
# ...
# sync

?
sage
