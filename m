From: cwillu <cwillu@cwillu.com>
Subject: Re: New btrfsck status
Date: Wed, 9 Feb 2011 21:04:52 -0600
Message-ID: <AANLkTimbUz_VHUC2Cb3YvhgUR1EpycRSMG01HdUW0XXE@mail.gmail.com>
References: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ben Gamari <bgamari@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 9, 2011 at 8:52 PM, Ben Gamari <bgamari@gmail.com> wrote:
> Hey all,
>
> Over the last several months there have been many claims regarding the
> release of the rewritten btrfsck. Unfortunately, despite numerous
> claims that it will be released Real Soon Now(c), I have yet to see
> even a repository with preliminary code. Did I miss an announcement?
> There is something to be said for "release early, release often." Is
> there a timeline for getting btrfsck into some sort of usable form?

I can't speak for the devs, but that's never stopped me before :p

Speculative code to directly muck with known-to-be-corrupted data
structures is not something that benefits from early releases.  It's
too easy to cause damage that _can't_ be fixed later, and no amount of
warnings will prevent people from trying that code in desperation.

Or would you have taken a full image of your 8 drives before trying it
the first time?
