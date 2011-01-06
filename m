From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 01:03:24 +0000
Message-ID: <4D2514DC.6060306@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>	<4D24D8BC.90808@bobich.net> <4D250B3C.6010708@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D250B3C.6010708@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2011 12:22 AM, Spelic wrote:
> On 01/05/2011 09:46 PM, Gordan Bobic wrote:
>> On 01/05/2011 07:46 PM, Josef Bacik wrote:
>>
>> Offline dedup is more expensive - so why are you of the opinion that
>> it is less silly? And comparison by silliness quotiend still sounds
>> like an argument over which is better.
>>
>
> If I can say my opinion, I wouldn't want dedup to be enabled online for
> the whole filesystem.
>
> Three reasons:
>
> 1- Virtual machine disk images should not get deduplicated imho, if you
> care about performances, because fragmentation is more important in that
> case.

I disagree. You'll gain much, much more from improved caching and 
reduced page cache usage than you'll lose from fragmentation.

> So offline dedup is preferable IMHO. Or at least online dedup should
> happen only on configured paths.

Definitely agree that it should be a per-directory option, rather than 
per mount.

> 2- I don't want performances to drop all the time. I would run dedup
> periodically on less active hours, hence, offline. A rate limiter should
> also be implemented so not to trash the drives too much. Also a stop and
> continue should be implemented, so that dedup which couldn't finish
> within a certain time-frame (e.g. one night) can be made continue the
> night after without restarting from the beginning.

This is the point I was making - you end up paying double the cost in 
disk I/O and the same cost in CPU terms if you do it offline. And I am 
not convniced the overhead of calculating checksums is that great. There 
are already similar overheads in checksums being calculated to enable 
smart data recovery in case of silent disk corruption.

Now that I mentioned, that, it's an interesting point. Could these be 
unified? If we crank up the checksums on files a bit, to something 
suitably useful for deduping, it could make the deduping feature almost 
free.

As for restarting deduping (e.g. you chattr -R a directory to specify it 
for deduping. Since the contents aren't already deduped (the files' 
entries aren't in the hash index, it'd be obvious what still needs to be 
deduped and what doesn't.

> 3- Only some directories should be deduped, for performance reasons. You
> can foresee where duplicate blocks can exist and where not. Backup
> directories typically, or mailservers directories. The rest is probably
> a waste of time.

Indeed, see above. I think it should be a per file setting/attribute, 
hereditary from the parent directory.

> Also, the OS is small even if identical on multiple virtual images, how
> much is going to occupy anyway? Less than 5GB per disk image usually.
> And that's the only thing that would be deduped because data likely to
> be different on each instance. How many VMs running you have? 20? That's
> at most 100GB saved one-time at the cost of a lot of fragmentation.

That's also 100GB fewer disk blocks in contention for page cache. If 
you're hitting the disks, you're already going to slow down by several 
orders of magnitude. Better to make the caching more effective.

>>> So if you are doing this online, that means reading back the copy you
>>> want to dedup in the write path so you can do the memcmp before you
>>> write. That
>>> is going to make your write performance _suck_.
>>
>> IIRC, this is configurable in ZFS so that you can switch off the
>> physical block comparison. If you use SHA256, the probability of a
>> collission (unless SHA is broken, in which case we have much bigger
>> problems) is 1^128. Times 4KB blocks, that is one collission in 10^24
>> Exabytes. That's one trillion trillion (that's double trillion) Exabytes.
>
> I like mathematics, but I don't care this time. I would never enable
> dedup without full blocks compare. I think most users and most companies
> would do the same.

I understand where you are coming from, but by that reasoning you could 
also argue that AES256 isn't good enough to keep your data confidential. 
It is a virtual certainty that you will lose several times that much 
data through catastrophic disk+raid+backup failures than through finding 
a hash collission.

> If there is full blocks compare, a simpler/faster algorithm could be
> chosen, like md5. Or even a md-64bits which I don't think it exists, but
> you can take MD4 and then xor the first 8 bytes with the second 8 bytes
> so to reduce it to 8 bytes only. This is just because it saves 60% of
> the RAM occupation during dedup, which is expected to be large, and the
> collisions are still insignificant at 64bits. Clearly you need to do
> full blocks compare after that.

I really don't think the cost in terms of a few bytes per file for the 
hashes is that significant.

> Note that deduplication IS a cryptographically sensitive matter because
> if sha-1 is cracked, people can nuke (or maybe even alter, and with
> this, hack privileges) other users' files by providing blocks with the
> same SHA and waiting for dedup to pass.
> Same thing for AES btw, it is showing weaknesses: use blowfish or twofish.
> SHA1 and AES are two wrong standards...

That's just alarmist. AES is being cryptanalyzed because everything uses 
it. And the news of it's insecurity are somewhat exaggerated (for now at 
least).

> Dedup without full blocks compare seems indeed suited for online dedup
> (which I wouldn't enable, now for one more reason) because with full
> block compares performances would really suck. But please leave full
> blocks compare for the offline dedup.

Actually, even if you are doing full block compares, online would still 
be faster, because at least one copy will already be in page cache, 
ready to hash. Online you get checksum+read+write, offline you get 
read+checksum+read+write. You still end up 1/3 ahead in terms if IOPS 
required.

> Also I could suggest a third type of deduplication, but this is
> harder... it's a file-level deduplication which works like xdelta, that
> is, it is capable to recognize piece of identical data on two files,
> which are not at the same offset and which are not even aligned at block
> boundary. For this, a rolling hash like the one of rsync, or the xdelta
> 3.0 algorithm could be used. For this to work I suppose Btrfs needs to
> handle the padding of filesystem blocks... which I'm not sure it was
> foreseen.

I think you'll find this is way too hard to do sensibly. You are almost 
doing a rzip pass over the whole file system. I don't think it's really 
workable.

> Above in this thread you said:
>> The _only_ reason to defer deduping is that hashing costs CPU time.
>> But the chances are that a modern CPU core can churn out MD5 and/or
>> SHA256 hashes faster than a modern mechanical disk can keep up. A
>> 15,000rpm disk can theoretically handle 250 IOPS. A modern CPU can
>> handle considerably more than 250 block hashings per second. You could
>> argue that this changes in cases of sequential I/O on big files, but a
>> 1.86GHz GHz Core2 can churn through 111MB/s of SHA256, which even SSDs
>> will struggle to keep up with.
>
> A normal 1TB disk with platters can do 130MB/sec sequential, no problems.
> A SSD can do more like 200MB/sec write 280MB/sec read sequential or
> random and is actually limited only by the SATA 3.0gbit/sec but soon
> enough they will have SATA/SAS 6.0gbit/sec.

But if you are spewing that much sequential data all the time, your 
workload is highly unusual, not to mention that those SSDs won't last a 
year. And if you are streaming live video or have a real-time data 
logging application that generates that much data, the chances are that 
yuo won't have gained anything from deduping anyway. I don't think it's 
a valid use case, at least until you can come up with at least a 
remotely realistic scenario where you might get plausible benefit from 
deduping in terms of space savings that involves sequentially streaming 
data to disk at full speed.

> More cores can be used for hashing but multicore implementation for
> stuff that is not natively threaded (such as parallel and completely
> separate queries to a DB) usually is very difficult to do well. E.g. it
> was attempted recently on MD raid for parity computation by
> knowledgeable people but it performed so much worse than single-core
> that it was disabled.

You'd need a very fat array for one core to be unable to keep up. 
According to my dmesg, RAID5 checksumming on the box on my desk tops out 
at 1.8GB/s, and RAID6 at 1.2GB/s. That's a lot of disks' worth of 
bandwidth to have in an array, and that's assuming large, streaming 
writes that can be handled efficiently. In reality, on smaller writes 
you'll find you are severely bottlenecked by disk seek times, even if 
you have carefully tuned your MD and file system parameters to perfection.

Gordan
