From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs-progs: new integration branch out
Date: Wed, 12 Oct 2011 20:38:08 +0700
Message-ID: <CAG1y0sfayqAL=mg0KqNCyFDVWZru1URw7+V1X1mGh62X69brGw@mail.gmail.com>
References: <20111012123411.GC21931@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111012123411.GC21931@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 12, 2011 at 7:34 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> =A0 All -
>
> =A0 After a long wait (sorry about that, things have been busy for me
> lately), I've managed to pull together a new integration branch for
> btrfs-progs. This can be pulled from:
>
> http://git.darksatanic.net/repo/btrfs-progs-unstable.git/ integration=
-20111012
>
> =A0 This is only compile-tested so far, so there may still be serious
> problems with it. Please take care. I'm not likely to be able to do
> much additional work on it before the weekend, so I thought it would
> be better to get *something* out, even if it's unstable/buggy. This
> _is_ the integration branch, after all...
>
> =A0 Fixes or updated patches for any problems you may find are
> welcomed, of course.
>
> =A0 I've got a few additional things still to bring in -- David Sterb=
a
> did a trawl round quite a few distributions and turned up a couple of
> useful-looking patches that he's sent my way; plus there's Jan
> Schmidt's inspect-internal patches, which sadly clashed horribly with
> Xin Zhong's subvol-get-default patch.
>
> =A0 I hope I'll be able to run up another version within the week wit=
h
> these other parts in it, and actually do some proper review/testing o=
n
> it before it goes out.

Personally I'd like to see Josef's work on
https://github.com/josefbacik/btrfs-progs merged, in particular the
"restore" command (which should be useful even when a working fsck is
available). I'm not sure though if it's intended to be merged or just
a personal project as this point.

Also a small note on grouping of "btrfs" commands help text. For
example, it now jumps from "btrfs filesystem label" to four "btrfs
scrub" commands, then back to "btrfs filesystem restripe". Not really
critical, just cosmetic.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
