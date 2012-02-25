From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Strange prformance degradation when COW writes happen at fixed
 offsets
Date: Sat, 25 Feb 2012 03:34:00 +0000 (UTC)
Message-ID: <pan.2012.02.25.03.34.00@cox.net>
References: <CAB3q8748dryFek4UZnh+5__feqp_ffCX-VdZNkcs62B=X47Ghw@mail.gmail.com>
	<CAB3q874F+6HrjvxYduex3sKcskMYcVXOa_CqW6i1F=gDv8+u7g@mail.gmail.com>
	<pan.2012.02.24.06.38.07@cox.net>
	<CAB3q876D=jFQF8D+PypAkZM3Uuxgwmf+tjLB9m9Pb5JZsCHZTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Nik Markovic posted on Fri, 24 Feb 2012 14:38:57 -0600 as excerpted:

> On Fri, Feb 24, 2012 at 12:38 AM, Duncan <1i5t5.duncan@cox.net> wrote=
:
>> Nik Markovic posted on Thu, 23 Feb 2012 20:31:02 -0600 as excerpted:
>>
>>> I noticed a few errors in the script that I used. I corrected it an=
d
>>> it seems that degradation is occurring even at fully random writes:
>>
>> I don't have an ssd, but is it possible that you're simply seeing
>> erase- block related degradation due to multi-write-block sized
>> erase-blocks?
>>
>> It seems to me that when originally written to the btrfs-on-ssd, the
>> file will likely be written block-sequentially enough that the file =
as
>> a whole takes up relatively few erase-blocks. =C2=A0As you COW-write
>> individual blocks, they'll be written elsewhere, perhaps all the
>> changed blocks to a new erase-block, perhaps each to a different era=
se
>> block.
>=20
> This is a very interesting insight. I wasn't even aware of the
> erase-block issue, so I did some reading up on it...

I take it you looked at TRIM/discard, then, as well?  In theory and for=
=20
some SSD firmware, it works well at helping to alleviate the problem by=
=20
informing the SSD of data areas that it no longer needs to care about=20
(empty space), thus allowing more effective management of those erase-
blocks.

Reality is however not quite so simple, and it doesn't help a lot with=20
some SSDs, plus there's a potential performance issue due when doing th=
e=20
discard on especially earlier devices, since TRIM is an unqueueable=20
command in the earlier standards (I've read it's defined as queueable i=
n=20
the latest standards, however), thus forcing a flush of all activity in=
=20
the queue before the discard, potentially triggering I/O freeze=20
behavior.  Additionally, when run on top of dm-crypt, there's a potenti=
al=20
security issue (examination of the raw undecrypted storage reveals=20
whether there's data there or not, and possibly the filesystem type use=
d=20
based on patterns, a potential deniability issue in that they know the=20
data is there, tho it doesn't affect the strength of the encryption=20
itself).

So since on a lot of firmware it doesn't make a lot of difference anywa=
y,=20
and there's a couple of down sides, the btrfs ssd mount option does NOT=
=20
enable discard as well.  However, there *IS* a discard option that you=20
can experiment with if you like, and it probably WILL help with erase-
block handling on SOME firmware.

See the FAQ, part 3 Features, # 3.4 on TRIM/discard, for a bit more. I'=
ve=20
really covered what it says, above, but there's a link to the encryptio=
n=20
security vs TRIM research, for instance.  And the discard mount-option=20
for whatever reason isn't listed in mount options, or at least I didn't=
=20
see it, only in the FAQ.

(This is one URL, my client is wrapping it and it's a hassle to fix.)

http://btrfs.ipv5.de/index.php?
title=3DFAQ#Does_Btrfs_support_TRIM.2Fdiscard.3F

Bottom line, if it is indeed an erase-block issue, the discard mount=20
option MIGHT help, or it might not, depending on your device firmware. =
=20
It's an experiment-and-see thing.

>> As you increase the successive COW generation count, the file's file=
-
>> system/write blocks will be spread thru more and more erase-blocks,
>> basically fragmentation but of the SSD-critical type, into more and
>> more erase blocks, thus affecting modification and removal time but =
not
>> read time.
>=20
> OK, so time to write would increase due to fragmentation and writing,=
 it
> now makes sense (though I don't see why small writes would affect thi=
s,
> but my concerns are not writes anyway), but why would cp --reflink ti=
me
> increase so much. Yes, new extents would be created, but btrfs doesn'=
t
> write into data blocks, does it? I figured its metadata would be kept=
 in
> one place. I figure the only thing BTRFS would do on cp
> --reflink=3Dalways:
> 1. Take a collection of extents owned by source.
> 2. Make the new copy use the same collection of extents.
> 3. Write the collection of extents to the "directory".
>=20
> Now this process seems to be CPU intensive. When I remove or make a
> reflink copy, one core pikes up to 100%, which tells me that there's =
a
> performance issue there, not an ssd issue. Also, only one CPU thread =
is
> being used for this. I figured that I can improve this by some settin=
g.
> Maybe thread_pool mount option? Are there any updates in later kernel=
s
> that I should possibly pick up?

=46WIW... I am by no means an expert on this.  I /think/ I understand=20
enough of it to somewhat guide trial and error testing to arrive at a=20
reasonable if not best-case config for any setup I might deal with, and=
=20
well enough to hopefully point you in the right direction for your own=20
research and testing, but I'd not going to claim to be able to explain=20
the whys of individual cases, or even necessarily to understand them=20
myself, just understand enough to know of the issue and to trial and=20
error resolve to a hopefully reasonable situation on any hardware I mig=
ht=20
run.

However, I could speculate (enough to guide my own testing were I=20
troubleshooting here) that it's one of several things or more likely a=20
combination of them.  =20

One, I'm not sure if the metadata ends up being COW also, or not, but i=
f=20
it is, then your test case is fragmenting it too, thus explaining the=20
reflink copy issue.  And keep in mind that by default, btrfs uses DUP f=
or=20
metadata, so there's TWO copies of it written, thereby DOUBLING the=20
performance effects of anything affecting metadata!

Two, see the FAQ deduplication question/answer a couple questions below=
=20
the TRIM/discard one mentioned above.  I'm rather fuzzy on the filesyst=
em=20
implications of this myself, but it seems to me that our COW assumption=
s=20
might be wrong because they're assuming deduplication effects that simp=
ly=20
aren't the way btrfs works presently, as it hasn't implemented=20
deduplication.  Admittedly, this is at best a handwavy black-box factor=
,=20
but that's the best I can do with it, presently.  I guess that at least=
=20
gives you another place to do additional research, if it comes to that.=
 =20
(In this regard I do wish the COW subsection of the sysadmin guide page=
=20
on the wiki was written, it's simply punted ATM, since there's a fair=20
chance that a good explanation there would cover the filesystem viewpoi=
nt=20
differences between full deduplication and the COW that btrfs does,=20
perhaps clearing up some misconceptions people including me may have=20
about it, as well.)

Three, as evident in the discussion on the nodatacow and autodefrag=20
options I mentioned before, there's known issues with some use cases=20
involving large files and rewrites of data at random locations within=20
them.  But I'm not sure if these known issues are simply the ones we've=
=20
been discussing, or if there's other factors I'm unaware of in this=20
regard.  Knowing more about just what those known issues are and the=20
specific scenarios under which they occur, could go a long way toward=20
resolving the situation for you.

But I'm only a recent list regular, joining a few weeks ago as part of =
my=20
own research into btrfs (FWIW my use case involves N-way mirroring, wit=
h=20
N=3D3-4; since only no-mirroring and N=3D2 is available today and 3-way=
/n-way=20
is planned to layer on top of raid5/6, which is planned for kernel=20
3.4/3.5, I'm now waiting for that... while continuing to stay current o=
n=20
the list), so whatever research or test cases lead to the remarks on th=
e=20
wiki regarding large files with random data rewrites, predates my=20
involvement likely by quite some time.

=46our, there's additional block alignment issues having to do with the=
=20
alignment of the partition on the physical storage, as it relates to=20
read-, write- and erase-block sizes and alignment.  On SSDs, erase-bloc=
k=20
sizes are the biggest, so the optimum alignment would be to erase-block=
=20
size.  Getting it wrong can result in multiple block writes and/or eras=
es=20
where proper alignment would require only one.  This phenomenon is call=
ed=20
write-amplification (and less commonly, erase-amplification).  However,=
=20
depending on what you used to create the partition on which the=20
filesystem resides (and loopback files do tend toward worst-case), it's=
=20
quite possible you don't have block-alignment level control at all.

=46WIW, that's one use case for the mkbtrfs/mkfs.btrfs --alloc-start/-A=
=20
option, since that allows you to align the allocation within the=20
partition as necessary for alignment, regardless of the partition=20
alignment.

=46WIW2, gptfdisk (a gpt partitioner as opposed to the old mbr style) h=
as=20
reasonable alignment defaults of 1 MiB on disks without an existing=20
partition layout, and attempts 8-sector (4 KiB) alignment even on=20
existing layouts, for disks >=3D300 GB at least.  That's what I've been=
=20
using for the last few years, having converted to gpt-based partitionin=
g=20
for everything, even USB-thumb-drives, if partitioned.  (GPT was design=
ed=20
for EFI, but can be used on BIOS based systems as well, which is what I=
'm=20
doing.  Grub2 understands gpt well and puts to good use any reserved BI=
OS=20
partition it finds, and there's options in the kernel for it that need=20
enabled as well.)

Block alignment is DEFINITELY something you can play with, in terms of=20
testing whether it makes a difference on your drives, SSD or "spinning=20
rust".

There's probably other factors involved of which I'm unaware, as well.

>> IIRC I saw a note about this on the wiki, in regard to the nodatacow
>> mount-option.

>> In addition to nodatacow, see the note on the autodefrag option.

> Unless I am wrong, this would disable COW completely and reflink copy=
=2E
> Reflinks are a crucial component and the sole reason I picked BTRFS f=
or
> the system that I am writing for my company.
> The autodefrag option addresses multiple writes. Writing is not the
> problem, but cp --reflink should be near-instant. That was the reason=
 we
> chose BTRFS over ZFS, which seemed to be the only feasible alternativ=
e.
> ZFS snapshot complicate the design and deduplication copy time is the
> same as (or not much better than) raw copy.

> As I mentioned above, the COW is the crucial component of our system,
> XFS won't do. Our system does not do random writes. In fact it is mai=
nly
> heavy on read operation. The system does occasional "rotation of rust=
"
> on large files in a way that version control system would (large file=
s
> are modified and then used as a new baseline)

Pardon me, I think I might have been too vague with that "rotating rust=
"=20
allusion and lost you.  Either that or you're taking the allusion out=20
even further and potentially lost me! =3D;^0

I meant spinning magnetic media with that "rotating rust" reference, th=
e=20
"rotating rust" bit being a double entendre allusion both to the iron=20
oxide (rust) used as the data storage layer, and to the fact that many=20
view rotating magnetic media as a legacy technology (rusting out)=20
compared to SSDs. =3D:^)  As it happens, I saw that double-meaning word=
-
play used elsewhere recently with the same two allusions attached, and=20
liked it enough to use it myself, when I got the chance.  Only I'm not=20
sure you got the reference, because...

You used it quite differently, referring to file rotation.  So either y=
ou=20
saw my reference and upped the ante, so to speak, leaving me to pick up=
=20
the pieces, or I lost you with the original reference, one of the two.

But I guess we should be on the same page knowing each other's meaning,=
=20
now.  Meanwhile...

[I do see your followup mentioning that it doesn't actually disable /al=
l/=20
COW, and that you tested it, without significant change in the results.=
=2E.]

=46WIW, I wasn't so much SUGGESTING those options, as noting the=20
INFORMATION contained in their description, the random writes to large =
db=20
files and its effect on btrfs bit.  But testing (which you did) is a go=
od=20
idea, just to see what difference it makes, little in your case, so=20
either the nocow option isn't disabling it in your case (specific use o=
f=20
cp --reflink), or the cow isn't the problem at all.


While you're at testing, tho, the question occurred to me of whether=20
simply using btrfs' snapshotting would make a difference.  (I did say I=
=20
don't claim a full understanding, and that trial and error testing woul=
d=20
be my method here, that I really only understand enough to hopefully=20
guide me a bit in what to test...)  Snapshotting by definition uses the=
=20
COW capacities, bit it occurs to me that since it's doing it on a=20
filesystem-wide basis instead of a single-file basis, that might allow=20
more efficiency in metadata handling.

Note that I don't necessarily expect that snapshotting would be a=20
workable final solution for you, but if in testing you discover that th=
e=20
speed stays reasonable with the snapshot method (still only changing th=
e=20
single file between snapshots), while it degrades (as you've found) wit=
h=20
the single cp --reflink method, then that's important data for the test=
=20
case, and given btrfs' state of development, it could well lead to majo=
r=20
optimizations of the single-file cp --reflink case as well, which you=20
presumably COULD use in final deployment.


> Thanks for all your help on this issue. I hope that someone can point
> out some more tweaks or added features/fixes after 3.2 RC5 that I may
> do.

Talking about which... since you mentioned 3.2-rc5, you do seem aware o=
f=20
the fact that btrfs is still very much experimental status, in active=20
development, and the need for staying current on the kernel.

However, unless your testing is for a system with actual deployment=20
scheduled for say a year or more out, I'd question btrfs as a reasonabl=
e=20
solution in any case.  One of the things that a lot of people don't see=
m=20
to realize is just how much active btrfs development is still going on,=
=20
and that it's NOT just corner-case use cases such as the multi-mirror=20
raid1 that I'm waiting on ATM, but that there's still data corruption=20
issues being traced and fixed, etc.

IOW, btrfs isn't something I'd recommend on either a production system =
or=20
even a general user's system, for the time being.  If the intent is to=20
test btrfs, filling it with data that you are not only prepared for it =
to=20
be destroyed, but expect it to happen, so you not only have backups or=20
simply don't value the data enough to be worth backups, you're not=20
counting on the btrfs copy as anything but experimental "garbage" data,=
=20
expected to be lost in testing, as well, then that's FINE.  Such testin=
g,=20
and hopefully bug reporting, and patching where possible, is what btrfs=
=20
is out there for, ATM. =20

But if the intent is to actually put production data on the filesystem,=
=20
or use it as the primary copy of data that you don't want to lose, btrf=
s=20
isn't an appropriate choice at this point, and I'd say probably won't b=
e=20
until say Q4, or even next year, so if your production deployment is=20
scheduled for before that, really, you shouldn't be looking at btrfs fo=
r=20
it, as it's not fit for that purpose ATM and isn't likely to be, for=20
another year or so (and even then, it'll be suitable for only the early=
=20
adopters, the cautious folk will wait another year or more after that,=20
just as many of the cautious folk are only now warming to ext4 as oppos=
ed=20
to ext3).

I just don't want to see you back here as one of those folks asking=20
questions about recovering data on a screwed filesystem, because they h=
ad=20
no backups or the backups weren't kept current, because they were using=
=20
btrfs for real-life use beyond testing purposes, and that's simply not=20
the sort of use btrfs is designed to or can properly deliver at this=20
point!

--=20
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
