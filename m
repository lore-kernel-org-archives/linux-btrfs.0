From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 17:49:44 +0400
Message-ID: <2a31deca0904280649w29d9cca8re9c0abc910ff99@mail.gmail.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	<1240839448.26451.13.camel@think.oraclecorp.com> <20090428052215.GA22921@cip.informatik.uni-erlangen.de>
	<1240912971.2149.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Thomas Glanzmann <thomas@glanzmann.de>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240912971.2149.5.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 28, 2009 at 2:02 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Tue, 2009-04-28 at 07:22 +0200, Thomas Glanzmann wrote:
>> Hello Chris,
>>
>> > There is a btrfs ioctl to clone individual files, and this could b=
e used
>> > to implement an online dedup. =A0But, since it is happening from u=
serland,
>> > you can't lock out all of the other users of a given file.
>>
>> > So, the dedup application would be responsible for making sure a g=
iven
>> > file was not being changed while the dedup scan was running.
>>
>> I see, does that mean that I can not do ,,dedup'' for files that are
>> currently opened by a userland program?
>
> No, but it does mean the dedup done from userland is racey. =A0Pictur=
e

Race disappears if (background) dedupe is run against snapshot(s).

Regards,
Andrey

> this:
>
> process A:
> =A0 =A0create some_file # some_file matches the contents of another f=
ile
>
> dedup proc:
> =A0 =A0check some_file
> =A0 =A0decide to start block dedup
>
> process A:
> =A0 =A0 modify some_file
>
> dedup proc:
> =A0 =A0 progress through block dedup
>
> So, this will happily replace blocks in some_file with the dedup bloc=
ks.
> But there's no way to atomically swap them.
>
> We could create new ioctls for this, basically a variant of the clone
> file ioctl that makes sure a given set of pages has a given sum (or
> strict memory contents) before doing the swap.
>
> But they don't exist yet.
>
> -chris
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
