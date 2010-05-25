From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Confused by performance
Date: Mon, 24 May 2010 20:59:34 -0700
Message-ID: <AANLkTimqGqdZfARXYZmVhFzGQ4h2lQoK6VmHbUb4Iwi5@mail.gmail.com>
References: <4BFAEABD.2070700@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BFAEABD.2070700@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 24, 2010 at 2:08 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> I've just started to work with btrfs so I started with a benchmark. =C2=
=A0On four
> identical servers, (2 dual core cpus, single local disk), I built
> filesystems - ext3, ext4, nilfs2, and btrfs. =C2=A0I checked out a si=
zable code
> tree and timed a build. =C2=A0The build is parallelized to use 4 thre=
ads when
> possible.
>
> I'm seeing similar build times on ext[34] and nilfs2 but I'm seeing a=
lmost
> double the times for btrfs using default options. =C2=A0And I'm havin=
g trouble
> reconciling this performance cost with the benchmarks I'm seeing arou=
nd the
> net.
>
> Is this a common result? =C2=A0Is there a trick to getting ext4 compe=
titive
> performance out of btrfs? =C2=A0Is my application a poor choice for b=
trfs? =C2=A0Am I
> missing something obvious here?
>

Please make sure you're testing with the latest btrfs from git or
linus latest kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
