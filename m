From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: Btrfs partition lost after RAID1 mirror disk failure?
Date: Sat, 7 Jan 2012 00:22:03 -0600
Message-ID: <CAGAVQTFJg9YFYFBPvQ2-TkS5_yvigYTvwEHTdRgQPObm8UmaFw@mail.gmail.com>
References: <CA+h3BtujUZbu17t0FSEht2wytE7Kj8T9DbAS7T74+c0bOWNnGA@mail.gmail.com>
 <CAGAVQTGMH0Y_5BvC6nxGsMcb3Dg2r8VEC10SN+gKRc08B1yDpA@mail.gmail.com> <CA+h3BtsdcOnvXfjcUzRvEYFw_RavNE38hMP61RFXiSNoCHsGvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Dan Garton <dan.garton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+h3BtsdcOnvXfjcUzRvEYFw_RavNE38hMP61RFXiSNoCHsGvg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 4, 2012 at 2:30 PM, Dan Garton <dan.garton@gmail.com> wrote:
>
> Assuming that this is the case, do I stand a chance of retrieving that
> volume and accessing that data again?
> Or does "destructive" imply total loss? (In which case, I'll cut my
> losses....)

unfortunately i really don't know enough to advise ... i did similar
actions a long time ago while experimenting for an initcpio-based
rollback utility, but in my case the FS was a dummy/loopback, so i
just burned it.  my only suggestion would be to try Josef's readonly
recovery/slurp utility and maybe you can pull some data off, since my
completely uninformed guess is the structures are 99% intact, but your
UUIDs no longer match, or internal top-level pointers to wrong
locations, etc etc.  perhaps someone more familiar with actual
internals can be of more help -- good luck.

-- 

C Anthony
