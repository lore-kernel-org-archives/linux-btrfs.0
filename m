From: Josh Berry <des@condordes.net>
Subject: Re: Updating the wiki pages adding btrfs command
Date: Wed, 15 Sep 2010 16:46:14 -0700
Message-ID: <AANLkTimySR7R9tkwQNDKxJ9gb_+6XK7VK_Chys0r_Bec@mail.gmail.com>
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
	<m3wrqmljkr.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sage Weil <sage@newdream.net>, David Nicol <davidnicol@gmail.com>,
	kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m3wrqmljkr.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 15, 2010 at 15:37, Chris Ball <cjb@laptop.org> wrote:
=2E..
> =C2=A0 > Why not just do:
> =C2=A0 > # btrfs subvolume delete /path/to/subvolume1
> =C2=A0 > # btrfs subvolume delete /path/to/subvolume2
> =C2=A0 > # sync
>
> Or even better, "btrfs filesystem sync <path>".
>
> I'm assuming that the caller wants to wait until the subvol delete
> has happened, but is unwilling to wait until all other writes to the
> FS have finished, and is even more unwilling to wait for all writes
> on the rest of the system to finish.
>
> I don't know whether that's actually a reasonable/plausible use case,
> though.

I think so, because I have that use case (sorta).  I have a home
fileserver with btrfs, and a cron job on that machine runs hourly,
taking snapshots.  However, once the disk fills up, I want to delete
the oldest snapshots:

while [[ disk > xx% full ]]; do
    btrfs subvol delete /the/oldest/snapshot
    wait for space to free up
done

If delete does not wait to free space, I'll delete too many snapshots.
 But if I force a filesystem-wide sync after every delete, the loop
may take longer, which on a system busier than mine could take more
than the hour to complete.

-- Josh
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
