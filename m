From: Chris Ball <cjb@laptop.org>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 18:37:24 -0400
Message-ID: <m3wrqmljkr.fsf@pullcord.laptop.org>
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
	<Pine.LNX.4.64.1009151527090.3434@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josh Berry <des@condordes.net>, David Nicol <davidnicol@gmail.com>,
	kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Sage Weil <sage@newdream.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009151527090.3434@cobra.newdream.net> (Sage
	Weil's message of "Wed, 15 Sep 2010 15:31:17 -0700 (PDT)")
List-ID: <linux-btrfs.vger.kernel.org>

Hi Sage,

   > Actually, that was fixed in 2.6.34 (0bdb1db2).  Creating a
   > snapshot syncs all dirty data and metadata to disk, so you get a
   > fully consistent point in time snapshot.  No 'sync' is necessary
   > (and doing a 'sync' yourself would be racy any).

Oh, thanks!  Am happy to see that.

   > Why not just do:
   > # btrfs subvolume delete /path/to/subvolume1
   > # btrfs subvolume delete /path/to/subvolume2
   > # sync

Or even better, "btrfs filesystem sync <path>".

I'm assuming that the caller wants to wait until the subvol delete
has happened, but is unwilling to wait until all other writes to the
FS have finished, and is even more unwilling to wait for all writes
on the rest of the system to finish.

I don't know whether that's actually a reasonable/plausible use case,
though.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
