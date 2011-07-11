From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: last_index variable in btrfs_buffered_write function
Date: Mon, 11 Jul 2011 14:38:45 -0500
Message-ID: <CAKcLGm_wag+9zEwt-=6uNpG203EP+vHcOA9NG0t=xJACiiOGuQ@mail.gmail.com>
References: <28FB38ED-FC82-4EAD-BED8-330C8FA9AF83@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: =?ISO-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <28FB38ED-FC82-4EAD-BED8-330C8FA9AF83@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/11 Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>:
> Hello.
>
> Am I reading the code the wrong way, or is the 'last_index' variable =
in '__btrfs_buffered_write()' (and previously used in 'btrfs_file_aio_w=
rite()') irrelevant?
>
> It appears to just be used in 'prepare_pages()', passed as an argumen=
t, but never actually used by this function.
>
> Furthermore, I'm not sure what is intended with this variable, but if=
 the idea is to assign it with the =A0last page in the range, then I wo=
uld say that instead of
>
>> last_index =3D (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;
>
> it should be
>
>> =A0last_index =3D (pos + iov_iter_count(i) - 1) >> PAGE_CACHE_SHIFT;
>
> Then again, I may be missing something.
>
> Cheers.
>

I came to the same conclusion a few months ago when looking at a bug
in the same area of code.

The calculation appears to be wrong, but since it's not used anywhere,
you can't say for certain.  :)

I just haven't gotten around to testing a patch to confirm the hypothes=
is.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
