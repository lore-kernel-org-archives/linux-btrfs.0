From: Josh Berry <des@condordes.net>
Subject: Re: Updating the wiki pages adding btrfs command [Was Re: reserving
 an IOCTL number; other details]
Date: Wed, 15 Sep 2010 11:41:30 -0700
Message-ID: <AANLkTimtpNcszRh2-jqnixuKK2uydp6Bf=H-zHS0di0W@mail.gmail.com>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com>
	<201009131923.53227.kreijack@libero.it>
	<AANLkTi=RFO1kQEQ3FJYJ2XBYh4++TDYakrLxhoQDwA3k@mail.gmail.com>
	<201009142125.56710.kreijack@libero.it>
	<AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kreijack <kreijack@libero.it>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimB-tHAL8U8-_=9QsKisQgO-QPt4=X89QOsiPaK@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 15, 2010 at 07:10, David Nicol <davidnicol@gmail.com> wrote:
> Does the manpatch below describe an acceptable API for a hook to a
> facility for waiting for the completion of deleted snapshot cleanup?
...
> +\fBfilesystem GC\fR\fI <path> [ms] \fR
> +wait for completion of salvage of deleted subvolumes on
> +the filesystem identified by \fI<path>\fR. The optional
> +timeout is in milliseconds.
> +.TP

I'd suggest different wording for the manpage:

filesystem GC <filesystem> [timeout_in_ms]
Wait for btrfs to free any space that was used by deleted subvolumes
in <filesystem>.  If timeout_in_ms is specified, wait up to that many
milliseconds, then exit with status 1 [or whatever code is chosen] if
not all space could be freed in that time.

Personally, I like "gc" or "clean".  "wait-subvolume-deletion",
"garbage-collect" or similar is too verbose for my taste.

-- Josh
