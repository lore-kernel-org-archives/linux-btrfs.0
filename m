From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 14:00:47 +0000
Message-ID: <4D25CB0F.2060002@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<201101052258.36457.loony@loonybin.org> <4D259DF2.8090200@bobich.net> <201101060833.15627.loony@loonybin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101060833.15627.loony@loonybin.org>
List-ID: <linux-btrfs.vger.kernel.org>

Peter A wrote:
> On Thursday, January 06, 2011 05:48:18 am you wrote:
>> Can you elaborate what you're talking about here? How does the length of
>> a directory name affect alignment of file block contents? I don't see
>> how variability of length matters, other than to make things a lot more
>> complicated.
 >
> I'm saying in a filesystem it doesn't matter - if you bundle everything into a 
> backup stream, it does. Think of tar. 512 byte allignment. I tar up a 
> directory with 8TB total size. No big deal. Now I create a new, empty file in 
> this dir with a name that just happens to be the first in the dir. This adds 
> 512 bytes close to the beginning of the tar file the second time I run tar. Now 
> the remainder of the is all offset by 512bytes and, if you do dedupe on fs-
> block sized chunks larger than the 512bytes, not a single byte will be de-
> duped. 

OK, I get what you mean now. And I don't think this is something that 
should be solved in the file system.

> I know its a stupid example but it matches the backup-target and database dump 
> usage pattern really well. Files backing iSCSI shows similar dedupe behavior. 
> Essentially every time you bundle mutliple files together into one you run into 
> things like that.

I suspect a large part of the underlying cause of this is that most 
things still operate on 512 byte sectors. Once that is replaced with 4KB 
sectors, that will probably go away. And if this is the case, then 
perhaps making the block size "variable" to 512, 1024, 2048 and 4096 
bytes (probably in reverse order) will achieve most of that benefit.

Whether than is a worthwhile thing to do for poorly designed backup 
solutions, but I'm not convinced about the general use-case. It'd be 
very expensive and complicated for seemingly very limited benefit.

>> Have you some real research/scientifically gathered data
>> (non-hearsay/non-anecdotal) on the underlying reasons for the
>> discrepancy in the deduping effectiveness you describe? 3-17x difference
>> doesn't plausibly come purely from fixed vs. variable length block sizes.
 >
> Personal experience isn't hearsay :) Netapp publishes a whitepaper against the 
> 7000 making this a big point but that isn't publicly available. Try search 
> "zfs dedupe +netbackup" or "zfs dedupe +datadomain" and similar - you will 
> hear of hundreds of people all complain about the same thing.

Typical. And no doubt they complain that ZFS isn't doing what they want, 
rather than netbackup not co-operating. The solution to one misdesign 
isn't an expensive bodge. The solution to this particular problem is to 
make netbackup work on per-file rather than per stream basis.

Gordan
