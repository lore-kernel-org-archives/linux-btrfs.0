From: Chris Ball <cjb@laptop.org>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 17:52:19 -0400
Message-ID: <m31v8un08c.fsf@pullcord.laptop.org>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
	<AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
	<201009142125.56710.kreijack@libero.it>
	<AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
	<AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
	<AANLkTinmWrr5AH_dG9U+AGbFzsTyjzCNk3XugGKseYCj@mail.gmail.com>
	<m362y6n2ae.fsf@pullcord.laptop.org>
	<AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Nicol <davidnicol@gmail.com>, kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josh Berry <des@condordes.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinGTyujDgTqwO6R729_djEWa-aUwiJ-W0vknXgE@mail.gmail.com>
	(Josh Berry's message of "Wed, 15 Sep 2010 14:46:46 -0700")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Or make --sync the default behavior.  This is probably what most
   > people are expecting anyway (similar to how standard filesystem
   > commands like "rm" work).  Add an --aysnc option for those that
   > only care about knowing when the subvolume is taken out of the
   > tree.

Yeah.  We've also talked about making snapshot _creation_ perform an
FS sync first by default, since otherwise you get a snapshot with stale
files, or without files that existed (not yet on disk) at creation-time.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
