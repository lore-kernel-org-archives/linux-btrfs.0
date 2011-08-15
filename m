From: ivo welch <ivo.welch@gmail.com>
Subject: Re: licenses (for apple OSX and others)?
Date: Sun, 14 Aug 2011 19:27:14 -0700
Message-ID: <CAPr7RtXjJESVr4VnnyBQsts9E6Cw=rhG2W3FQVDO7m0LAr6QFQ@mail.gmail.com>
References: <CAPr7RtVfNtNno=7KTJvyvNFnkumHd3PiJSo8eoswBZT-0vwFQA@mail.gmail.com>
 <003201cc5aef$23baccb0$6b306610$@nedharvey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Edward Ned Harvey <kernel@nedharvey.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <003201cc5aef$23baccb0$6b306610$@nedharvey.com>
List-ID: <linux-btrfs.vger.kernel.org>

thx, ed.

this is a case where I am wondering whether EVERYONE, including all
the commercial contributors to btrfs, would be better off with another
additional license that also allowed kernel integration for companies
like Apple.   the decision-making (and rights) for btrfs are so
dispersed, however, that we may all end up with a worse outcome,
including the commercial and other contributors.  (perhaps, it would
be worth asking them, if a mailing list of contributors to btrfs
existed.)

I am and I am not a fan of Apple.  they scare me.  I am afraid that
Apple will be much worse than IBM and Microsoft ever were.  I would
rather not see them get more than 20% market share.  still, the world
is what it is.

now, specifically, which contributors to btrfs would it hurt if Apple
were allowed to integrate the code into its kernel to make btrfs its
main file system?

I can only think of Microsoft as a company that might be hurt.  FAT is
the universal file system now, and it could lose that status.
Microsoft may not have wanted to contribute to btrfs in this case to
begin with.  did they ever contribute here?

I cannot imagine that any server company, like Sun, Oracle, or IBM,
would be worse off if OSX and linux would both use btrfs.  it would
probably make their life a whole lot easier.

linux on the desktop would be MUCH better off compared to the current
situation with everyone using their own almost-compatible file system,
and more so than OSX on the desktop would be better off.  (linux on
the server would probably be mildly better off, but here one can argue
that Apple would get more than it contributes.)  besides, the btrfs
system would control the evolution of btrfs, not Apple.

just my two cents...

/iaw


On Sun, Aug 14, 2011 at 7:00 PM, Edward Ned Harvey <kernel@nedharvey.co=
m> wrote:
>> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
>> owner@vger.kernel.org] On Behalf Of ivo welch
>>
>> curiosity question---could btrfs be licensed in multiple ways to all=
ow
>> Apple and other vendors to adopt it?
>
> No. =A0The source code is copyrighted by many different entities, and=
 the only
> way to release it under any other license would require all of the
> contributors to mutually agree. =A0It'll never happen. =A0Likewise, p=
erhaps
> Apple could release their code under a license that's compatible with=
 GPL,
> but I seriously doubt that would ever happen.
>
>
>> as end users, having one good
>> file system that works everywhere as a main root system would be
>> heaven...
>
> Agreed. =A0But the various producers of filesystems are generally com=
mercial
> entities interested in making a profit. =A0For various reasons, many =
of them
> intentionally don't go this direction. =A0They're all trying to diffe=
rentiate
> themselves.
>
> Generally speaking, the problem is the requirement to integrate some =
other
> FS into a kernel or other component that requires license compatibili=
ty for
> booting. =A0Generally speaking you can circumvent this problem by usi=
ng things
> like Fuse to mount a filesystem in user space, thus not requiring it =
to be
> built into the kernel, thus eliminating any license compatibility pro=
blems.
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
