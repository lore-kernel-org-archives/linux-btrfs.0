From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: Unable to mount (or, why not to work late at night).
Date: Fri, 28 Oct 2011 11:57:47 +0000 (UTC)
Message-ID: <slrnjal65r.86j.stephane.chazelas@spam.is.invalid>
References: <7d421a89143f5c4811d64e08c6820c29@www.jots.org>
 <CAG1y0sfBkczDLRgq=c42_nKwtG3M2UTRB2NHjnZz3L1-jta90w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-28, 07:57(+07), Fajar A. Nugraha:
[...]
>> Already got 'em. =C2=A0Everything that tries to even think about mod=
ifying stuff
>> (btrfs-zero-log, btrfsck, and btrfs-debug-tree) all dump core:
>
> Your last resort (for now, anyway) might be using "restore" from
> Josef's btrfs-progs: https://github.com/josefbacik/btrfs-progs
>
> It might be able to copy some data.

I also have got one FS in that same situation. I tried
everything on it including that "restore" (which bailed out with
those same error messages IIRC).

The only thing that got me a bit further was to use an alternate
superblock, though that screwed the FS even further as I need to
reboot the machine after trying to mount it (mount hangs and
there are some btrfs tasks using all the CPU time).

=46ortunately, for that one, I had a not too old backup at the
block device level.

--=20
Stephane

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
