From: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: cannot remove files: No space left on device
Date: Sun, 12 Jun 2011 09:31:27 +0100
Message-ID: <BANLkTikprQh1qEUQFJaPHE6hGvKxgqX33w@mail.gmail.com>
References: <4DF3FB15.1040108@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF3FB15.1040108@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 12 June 2011 00:32, Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> I'm trying to remove some files on a btrfs filesystem which has 26 GB=
 free:
>
> /dev/sdb4 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 336G =C2=A0310G =C2=
=A0 26G =C2=A093% /mnt/btrfs
>
>
> Unfortunately, removing some of the files fails, due to "No space lef=
t on device":
>
> root@dom:/mnt/btrfs# rm -rfv postgresql-noindex
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.6'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.7'
> rm: cannot remove `postgresql-noindex/postgresql/8.4/main/base/16384/=
16508.8': No space left on device
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508.9'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16508_fsm'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16511'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16513'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16516'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16516_fsm'
> removed `postgresql-noindex/postgresql/8.4/main/base/16384/16521'
>
> This is a snapshot of a different directory (with some changes).
>
> Is it expected? I'm running 2.6.39.1 kernel.
>
> --
> Tomasz Chmielewski

Check out the btrfs FAQ about space usage:
 https://btrfs.wiki.kernel.org/index.php/FAQ#Why_are_there_so_many_ways=
_to_check_the_amount_of_free_space.3F

and try these command too:
 btrfs filesystem df /mnt/btrfs
 btrfs filesystem show /dev/sdb4

I'm no btrfs expert but it's worth trying to delete one file and
syncing the fs, then repeating.


Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
