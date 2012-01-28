From: Ben Klein <shacklein@gmail.com>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 17:05:41 +1100
Message-ID: <CAJboL97CGufkN=QEtr=ysU83nrq+UuUoEFuL+wJu85Hx+xBEuA@mail.gmail.com>
References: <4F22BCCC.5090800@danisch.de> <CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
 <4F234616.6020407@danisch.de> <pan.2012.01.28.03.32.23@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.01.28.03.32.23@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 28 January 2012 14:32, Duncan <1i5t5.duncan@cox.net> wrote:
> Hadmut Danisch posted on Sat, 28 Jan 2012 01:49:26 +0100 as excerpted=
:
>
>> Am 28.01.2012 00:20, schrieb Chester:
>>> It should be okay to mount with compress or without compress. Even =
if
>>> you mount a volume with compressed data without '-o compress' you w=
ill
>>> still be able to correctly read the data (but newly written data wi=
ll
>>> not be compressed)
>>
>> But having both compressed and uncompressed files in the filesystem =
is
>> exactly what I want to avoid. Not because of reading problems, but t=
o
>> avoid wasting disk space. I don't have a reading problem. I have a
>> writing problem.
>
> Having a compression flag in the superblock (probably more than one, =
thus
> allowing indication of compression type, etc), which is I guess what
> you're suggesting, sounds useful to me too. =C2=A0Perhaps it'll get i=
t, once
> development settles down a bit and they know enough about what's stil=
l
> missing in the existing superblock to be able to intelligently alloca=
te
> flags, etc, on a priority basis based on what they then know they nee=
d.

mkfs -O some_feature comes to mind. I know mke2fs has that, but I
haven't yet actually used btrfs; I'm waiting for fsck to be able to
repair a damaged filesystem.

> At this point I can certainly see a reluctance to make that change, t=
ho,
> since it's a rather small change to make on its own, and with continu=
ing
> tweaks to the compression types and etc, it's worth holding off
> committing now to what might look like a bad implementation down the
> line, when it has to continue to be supported.

This would affect not just a compression-preference option, but
existing filesystems with compression. If the compression routine
changes in a later kernel/filesystem revision, then you could end up
with some files using one routine and others using another. Does btrfs
currently have an "algorithm" specifier for compressed files?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
