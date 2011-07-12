From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: last_index variable in btrfs_buffered_write function
Date: Tue, 12 Jul 2011 14:43:23 -0500
Message-ID: <CAKcLGm-Oq1WtU8QGO+pMGwbcj61CHL837oGTZUSeu33nF-qu6Q@mail.gmail.com>
References: <28FB38ED-FC82-4EAD-BED8-330C8FA9AF83@gmail.com>
	<CAKcLGm_wag+9zEwt-=6uNpG203EP+vHcOA9NG0t=xJACiiOGuQ@mail.gmail.com>
	<1310479850-sup-3754@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: =?ISO-8859-1?Q?Jo=E3o_Eduardo_Lu=EDs?= <jecluis@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310479850-sup-3754@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011/7/12 Chris Mason <chris.mason@oracle.com>:
> Excerpts from Mitch Harder's message of 2011-07-11 15:38:45 -0400:
>> 2011/7/11 Jo=E3o Eduardo Lu=EDs <jecluis@gmail.com>:
>> > Hello.
>> >
>> > Am I reading the code the wrong way, or is the 'last_index' variab=
le in '__btrfs_buffered_write()' (and previously used in 'btrfs_file_ai=
o_write()') irrelevant?
>> >
>> > It appears to just be used in 'prepare_pages()', passed as an argu=
ment, but never actually used by this function.
>> >
>> > Furthermore, I'm not sure what is intended with this variable, but=
 if the idea is to assign it with the =A0last page in the range, then I=
 would say that instead of
>> >
>> >> last_index =3D (pos + iov_iter_count(i)) >> PAGE_CACHE_SHIFT;
>> >
>> > it should be
>> >
>> >> =A0last_index =3D (pos + iov_iter_count(i) - 1) >> PAGE_CACHE_SHI=
=46T;
>> >
>> > Then again, I may be missing something.
>> >
>> > Cheers.
>> >
>>
>> I came to the same conclusion a few months ago when looking at a bug
>> in the same area of code.
>>
>> The calculation appears to be wrong, but since it's not used anywher=
e,
>> you can't say for certain. =A0:)
>>
>> I just haven't gotten around to testing a patch to confirm the hypot=
hesis.
>
> I'd say it is a victim of a cleanup that didn't completely clean it u=
p.
> It is unused ;)
>

I've put together a patch for this clean-up.

I'll send it to the list.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
