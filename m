From: cwillu <cwillu@cwillu.com>
Subject: Re: SSD optimizations
Date: Mon, 13 Dec 2010 09:17:48 -0600
Message-ID: <AANLkTinpD+CXsHMB10DmXm-jF5a_rCUJ-tkeVthy4FYV@mail.gmail.com>
References: <1292174654.11248.10.camel@paddy-desktop>
	<4D05630E.7070809@bobich.net>
	<20101213051157.GA19543@attic.humilis.net>
	<4D05E681.5090004@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: sander@humilis.net, jarktasaa@gmail.com,
	linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D05E681.5090004@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 13, 2010 at 3:25 AM, Gordan Bobic <gordan@bobich.net> wrote=
:
> On 12/13/2010 05:11 AM, Sander wrote:
>>
>> Gordan Bobic wrote (ao):
>>>
>>> On 12/12/2010 17:24, Paddy Steed wrote:
>>>>
>>>> In a few weeks parts for my new computer will be arriving. The sto=
rage
>>>> will be a 128GB SSD. A few weeks after that I will order three lar=
ge
>>>> disks for a RAID array. I understand that BTRFS RAID 5 support wil=
l be
>>>> available shortly. What is the best possible way for me to get the
>>>> highest performance out of this setup. I know of the option to opt=
imize
>>>> for SSD's
>>>
>>> BTRFS is hardly the best option for SSDs. I typically use ext4
>>> without a journal on SSDs, or ext2 if that is not available.
>>> Journalling causes more writes to hit the disk, which wears out
>>> flash faster. Plus, SSDs typically have much slower writes than
>>> reads, so avoiding writes is a good thing.
>>
>> Gordan, this you wrote is so wrong I don't even know where to begin.
>>
>> You'd better google a bit on the subject (ssd, and btrfs on ssd) as =
much
>> is written about it already.
>
> I suggest you back your opinion up with some hard data before making =
such
> statements. Here's a quick test - make an ext2 fs and a btrfs on two =
similar
> disk partitions (any disk, for the sake of the experiment it doesn't =
have to
> be an ssd), then check vmstat -d to get a base line. Then put the ker=
nel
> sources on each it, do a full build, then make clean and check vmstat=
 -d
> again. Check the vmstat -d output again. See how many writes (sectors=
) hit
> the disk with ext2 and how many with btrfs. You'll find that there we=
re many
> more writes with BTRFS. You can't go faster when doing more. Journali=
ng is
> expensive.

Of course.  But that applies to rotating media as well (where the
seeks involved hurt much more), and has little if anything to do with
why you would use btrfs instead of ext2.

Good ssd drives (by which I mean anything but consumer flash as it
exists on sd cards and usb sticks) have very good wear leveling, good
enough that you could overwrite the same logical sector billions of
times before you'd experience any failure due to wear.  The issues
with cheaper ssd drives (which I distinguish from things like sd
cards) are uniformly performance degredation due to crappy garbage
collection and lack of trim support to compensate.  A journal is _not_
a problem here.

On crappy flash, yes, you want to avoid a journal, mainly because the
write leveling for a given sector only occurs over a fixed small
number of erase blocks, resulting in a filesystem that you can burn
out quite easily =97 I have a small pile of sd cards on my desk that I
sent to such a fate.  Even here there is reason to use btrfs.  The
journaling performed is much less strenuous that ext3/4:  it's
basically just a version stamp, as opposed to actually journaling the
metadata involved.  The actual metadata writes, being copy-on-write,
provide pretty much the best case for crappy flash, as cow inherently
wear-levels over the entire device (ssd_spread).  To say nothing of
checksums and duplicated metadata, allowing you to actually determine
if you're running into corrupted metadata, and often recover from it
transparently.  Ext2's behavior in this respect is less than ideal.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
