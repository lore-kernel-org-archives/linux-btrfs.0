From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Configuring default mount options..
Date: Mon, 26 Jul 2010 03:10:58 +0200
Message-ID: <AANLkTikNemTBWO8ChQ-XYdP4gp=1zKt5EMyzdzLrxgWq@mail.gmail.com>
References: <1280105806.3327.4.camel@hardline>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "A. James Lewis" <james@fsck.co.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1280105806.3327.4.camel@hardline>
List-ID: <linux-btrfs.vger.kernel.org>

On 26 July 2010 02:56, A. James Lewis <james@fsck.co.uk> wrote:
> If using BTRFS on a removable drive... it may be a problem for exampl=
e,
> to always mount with compression, or always mount with encryption (If
> supported in future)... perhaps btrfstune could define default mount
> options, such as compression... so if there is a BTRFS filesystem on =
a
> removable hard drive, or flash stick, the filesystem can be configure=
d
> to mount with compression by default.
>
> Maybe there is a way to do this already, but it seems like the
> filesystem itself should contain preferences for the way it is used
> under those circumstances.
>
> A. James Lewis
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

That's actually a good idea. Perhaps an override flag could be
specified in case you do not wish to use said default mount options?

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
