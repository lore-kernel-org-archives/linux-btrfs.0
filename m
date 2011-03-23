From: Kolja Dummann <k.dummann@gmail.com>
Subject: Re: efficiency of btrfs cow
Date: Wed, 23 Mar 2011 18:36:50 +0100
Message-ID: <AANLkTinJRUdQKLXyLHVk98Q9zWgkFYcZxNK7-i0AwjN5@mail.gmail.com>
References: <il0a8d$4ev$1@dough.gmane.org>
	<1299427596.15017.8.camel@ayu>
	<4D89EA17.20506@interlinx.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Calvin Walton <calvin.walton@kepstin.ca>,
	linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D89EA17.20506@interlinx.bc.ca>
List-ID: <linux-btrfs.vger.kernel.org>

> So it's clear that total usage (as reported by df) was 121,402,328KB =
but
> Metadata has two values:
>
> Metadata: total=3D5.01GB, used=3D3.26GB
>
> What's the difference between total and used? =C2=A0And for that matt=
er,
> what's the difference between the total and used for Data
> (total=3D110.01GB, used=3D109.26GB)?
>

total is the space allocated (reserved) for a kind usage (metadata or
data) the space allocated for a kind of usage can't be used for
something else. The used value is the space that is used from the
space that has been allocated for a kind of usage.

The wiki gives you a overview how to interpret the values:

https://btrfs.wiki.kernel.org/index.php/FAQ#btrfs_filesystem_df_.2Fmoun=
tpoint

cheers Kolja.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
