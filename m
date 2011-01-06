From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 15:07:03 +0000
Message-ID: <4D25DA97.9010705@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<201101060833.15627.loony@loonybin.org> <4D25CB0F.2060002@bobich.net> <201101060952.50500.loony@loonybin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101060952.50500.loony@loonybin.org>
List-ID: <linux-btrfs.vger.kernel.org>

Peter A wrote:
> On Thursday, January 06, 2011 09:00:47 am you wrote:
>> Peter A wrote:
>>> I'm saying in a filesystem it doesn't matter - if you bundle everything
>>> into a backup stream, it does. Think of tar. 512 byte allignment. I tar
>>> up a directory with 8TB total size. No big deal. Now I create a new,
>>> empty file in this dir with a name that just happens to be the first in
>>> the dir. This adds 512 bytes close to the beginning of the tar file the
>>> second time I run tar. Now the remainder of the is all offset by
>>> 512bytes and, if you do dedupe on fs- block sized chunks larger than the
>>> 512bytes, not a single byte will be de- duped.
>> OK, I get what you mean now. And I don't think this is something that
>> should be solved in the file system.
> <snip>
>> Whether than is a worthwhile thing to do for poorly designed backup
>> solutions, but I'm not convinced about the general use-case. It'd be
>> very expensive and complicated for seemingly very limited benefit.
> Glad I finally explained myself properly... Unfortunately I disagree with you 
> on the rest. If you take that logic, then I could claim dedupe is nothing a 
> file system should handle - after all, its the user's poorly designed 
> applications that store multiple copies of data. Why should the fs take care 
> of that? 

There is merit in that point. Some applications do in fact do their own 
deduplication, as mentioned previously on this thread.

> The problem doesn't just affect backups. It affects everything where you have 
> large data files that are not forced to allign with filesystem blocks. In 
> addition to the case I mentioned above this affects in pretty much the same 
> effectiveness:
> * Database dumps 
> * Video Editing 
> * Files backing iSCSI volumes
> * VM Images (fs blocks inside the VM rarely align with fs blocks in the 
> backing storage). Our VM environment is backed with a 7410 and we get only 
> about 10% dedupe. Copying the same images to a DataDomain results in a 60% 
> reduction in space used.

I'd be interested to hear about the relative write performance on the 
variable block size.

> I also have to argue the point that these usages are "poorly designed". Poorly 
> designed can only apply to technologies that existed or were talked about at 
> the time the design was made. Tar and such have been around for a long time, 
> way before anyone even though of dedupe. In addition, until there is a 
> commonly accepted/standard API to query the block size so apps can generate 
> files appropriately laid out for the backing filesystem, what is the application 
> supposed to do?

Indeed, this goes philosophically in the direction that storage vendors 
have been (unsuccessfully) been trying to shift the industry for decades 
- object based storage. But, sadly, it hasn't happened (yet?).

> If anything, I would actually argue the opposite, that fixed block dedupe is a 
> poor design:
> * The problem is known at the time the design was made
> * No alternative can be offered as tar, netbackup, video editing, ... has been 
> around for a long time and is unlikely to change in the near future
> * There is no standard API to query the allignment parameters (and even that 
> would not be great since copying a file alligned for 8k to a 16k alligned 
> filesystem, would potentially cause the same issue again)
>
> Also from the human perspective its hard to make end users understand your 
> point of view. I promote the 7000 series of storage and I know how hard it is 
> to explain the dedupe behavior there. They see that Datadomain does it, and 
> does it well. So why can't solution xyz do it just as good?

I'd be interested to see the evidence of the "variable length" argument. 
I have a sneaky suspicion that it actually falls back to 512 byte 
blocks, which are much more likely to align, when more sensibly sized 
blocks fail. The downside is that you don't really want to store a 32 
byte hash key with every 512 bytes of data, so you could peel off 512 
byte blocks off the front in a hope that a bigger block that follows 
will match.

Thinking about it, this might actually not be too expensive to do. If 
the 4KB block doesn't match, check 512 byte sub-blocks, and try peeling 
them, to make the next one line up. If it doesn't, store the mismatch as 
a full 4KB block and resume. If you do find a match, save the peeled 512 
byte blocks separately and dedupe the 4KB block.

In fact, it's rather like the loop peeling optimization on a compiler, 
that allows you to align the data to the boundary suitable for vectorizing.

>> Typical. And no doubt they complain that ZFS isn't doing what they want,
>> rather than netbackup not co-operating. The solution to one misdesign
>> isn't an expensive bodge. The solution to this particular problem is to
>> make netbackup work on per-file rather than per stream basis.
 >
> I'd agree if it was just limited to netbackup... I know variable block length 
> is a significantly more difficult problem than block level. That's why the ZFS 
> team made the design choice they did. Variable length is also the reason why 
> the DataDomain solution is a scale out rather than scalue up approach. 
> However, CPUs get faster and faster - eventually they'll be able to handle it. 
> So the right solution (from my limited point of view, as I said, I'm not a 
> filesystem design expert) would be to implement the data structures to handle 
> variable length. Then in the first iteration, implement the dedupe algorithm to 
> only search on filesystem blocks using existing checksums and such. Less CPU 
> usage, quicker development, easier debugging. Once that is stable and proven, 
> you can then without requiring the user to reformat, go ahead and implement 
> variable length dedupe...

Actually, see above - I believe I was wrong about how expensive 
"variable length" block size is likely to be. It's more expensive, sure, 
but not orders of magnitude more expensive, and as discussed earlier, 
given the CPU isn't really the key bottleneck here, I think it'd be 
quite workable.

> Btw, thanks for your time, Gordan :)

You're welcome. :)

Gordan
