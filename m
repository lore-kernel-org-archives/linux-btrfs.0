From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: strange btrfs sub list output
Date: Thu, 2 Jun 2011 01:23:09 -0500
Message-ID: <BANLkTinMb7c1vEPSd+uCxa4+vbZ4ASUJjQ@mail.gmail.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com>
 <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com>
 <20110527091224.GA15627@carfax.org.uk> <chaz20110527093029.GA30613@seebyte.com>
 <20110527094523.GA12089@carfax.org.uk> <chaz20110527113010.GA12775@seebyte.com>
 <4DDF8FE0.9040107@gmail.com> <20110531100014.GA12396@yahoo.fr>
 <BANLkTikWE6b8nO7azgrCVhdZZ8b0ZfneVg@mail.gmail.com> <4DE5387A.7080704@gmail.com>
 <BANLkTim9++r7+FFehF67YqUkBLv=axBXwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephane Chazelas <stephane_chazelas@yahoo.fr>,
	Hugo Mills <hugo@carfax.org.uk>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTim9++r7+FFehF67YqUkBLv=axBXwA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2011 at 2:32 PM, C Anthony Risinger <anthony@xtfx.me> w=
rote:
> On Tue, May 31, 2011 at 1:50 PM, Andreas Philipp
> <philipp.andreas@gmail.com> wrote:
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 31.05.2011 19:40, C Anthony Risinger wrote:
>>> On Tue, May 31, 2011 at 5:00 AM, Stephane Chazelas
>>> <stephane_chazelas@yahoo.fr> wrote:
>>>> 2011-05-27 13:49:52 +0200, Andreas Philipp: [...]
>>>>>> Thanks, I can understand that. What I don't get is how one
>>>>>> creates a subvol with a top-level other than 5. I might be
>>>>>> missing the obvious, though.
>>>>>>
>>>>>> If I do:
>>>>>>
>>>>>> btrfs sub create A btrfs sub create A/B btrfs sub snap A
>>>>>> A/B/C
>>>>>>
>>>>>> A, A/B, A/B/C have their top-level being 5. How would I get a
>>>>>> new snapshot to be a child of A/B for instance?
>>>>>>
>>>>>> In my case, 285, was not appearing in the btrfs sub list
>>>>>> output, 287 was a child of 285 with path "data" while all I
>>>>>> did was create a snapshot of 284 (path
>>>>>> u6:10022/vm+xfs@u8/xvda1/g8/v3/data in vol 5) in
>>>>>> u6:10022/vm+xfs@u8/xvda1/g8/v3/snapshots/2011-03-30
>>>>>>
>>>>>> So I did manage to get a volume with a parent other than 5,
>>>>>> but I did not ask for it.
>>>> [...]
>>>>> Reconsidering the explanations on btrfs subvolume list in this
>>>>> thread I get the impression that a line in the output of btrfs
>>>>> subvolume list with top level other than 5 indicates that the
>>>>> backrefs from one subvolume to its parent are broken.
>>>>>
>>>>> What's your opinion on this?
>>>> [...]
>>>>
>>>> Given that I don't really get what the parent-child relationship
>>>> means in that context, I can't really comment.
>>>>
>>>> In effect, the snapshot had been created and was attached to the
>>>> right directory (but didn't appear in the sub list), and there
>>>> was an additional "data" volume that I had not asked for nor
>>>> created that had the snapshot above as parent and that did appear
>>>> in the sub list.
>>>>
>>>> It pretty much looks like a bug to me, I'd like to understand
>>>> more so that I can maybe try and avoid running into it again.
>>>
>>> i'm actually really interested in the conclusion to this thread
>>> because i _want_ to create subvols with a new parent ... i didn't
>>> realize this wasn't possible (nor the mount option) until reading
>>> this thread. this would give me a little more flexibility with
>>> initcpio hooks and the like vs. packing the btrfs root with tons of
>>> hidden files [subvols] or using IDs directly ...
>>>
>>> i tried absolutely everything i could think of to reproduce this
>>> but all subvols ended up having a top level id of `5`.
>>>
>>> ... so, is there any known way to _purposefully_ create parented
>>> subvols with the current tools?
>>
>> Hopefully, I can help clarify this a little bit. In fact, this is th=
e
>> 'usual' case. With the attached patch to the master branch of
>> btrfs-progs-unstable you can 'watch' how the btrfs subvolume list
>> command builds the full path of the listed subvolumes. Additionally,
>> it gives you the IDs of the parent subvolumes. See the following exa=
mple.
>>
>> ID 256 top level 5 path test1
>> ID 257 top level 256 path test1.1
>> ID 257 top level 5 path test1/test1.1
>> ID 258 top level 5 path test2
>> ID 259 top level 258 path test2.1
>> ID 259 top level 5 path test2/test2.1
>>
>> - From the second line you see that subvolume ID 256 really is ID 25=
7's
>> parent. Additionally, only test1 and test2 have parent ID 5 or in yo=
ur
>> terminology are in the btrfs root.
>
> aaah, ok ... this is what i thought was happening too after taking a
> peek at the sources (albeit i don't write any C) and seems to match
> what Hugo was saying if i understand him correctly.
>
> this also makes sense what you said about a broken link ... since
> normally the `btrfs` tool will not let you remove a subvol that has
> other subvols nested within it ... though *technically* it does not
> seem to matter, yes? =C2=A0must have been a fluke/bug in the `btrfs` =
tool
> where a higher level subvol was removed before it's child somehow, is
> this correct? =C2=A0or is the FS itself slightly broken when this hap=
pens?
>
> yeah i know that's kind of "my terminology" :-) ... i've spent a lot
> of time explaining btrfs concepts to others and that term always
> seemed to makes the most sense to people ... `top-level` can change,
> `default` can change, etc, etc ... but `the btrfs root` can only mean
> one thing -- the most "bottomest" of the bottom (or top, if you prefe=
r
> :-)
>
> i'll try this out later tonight, thanks.

after booting the correct kernel in KVM, this works exactly as
advertised by the commit that added it, and by your explanation --
thanks -- this will be of much use wrt designing "sub-root" layouts
for advanced initramfs recovery options ... i always felt limited by
the requirement to be in the "btrfs root", and mounting by id looses
some flexibility, eg. when trying to use names like pointers/symlinks.

=2E.. now i can put subvols anywhere, and user/script only needs to
determine the stable parent ids once.  nice ... to the laboratory!

--=20

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
