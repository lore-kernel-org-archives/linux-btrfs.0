From: Spelic <spelic@shiftmail.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 06 Jan 2011 02:19:04 +0100
Message-ID: <4D251888.7060508@shiftmail.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>
 <4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>
 <4D24D8BC.90808@bobich.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Gordan Bobic <gordan@bobich.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D24D8BC.90808@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2011 09:46 PM, Gordan Bobic wrote:
> On 01/05/2011 07:46 PM, Josef Bacik wrote:
>
> Offline dedup is more expensive - so why are you of the opinion that 
> it is less silly? And comparison by silliness quotiend still sounds 
> like an argument over which is better.
>

If I can say my opinion, I wouldn't want dedup to be enabled online for 
the whole filesystem.

Three reasons:

1- Virtual machine disk images should not get deduplicated imho, if you 
care about performances, because fragmentation is more important in that 
case.
So offline dedup is preferable IMHO. Or at least online dedup should 
happen only on configured paths.

2- I don't want performances to drop all the time. I would run dedup 
periodically on less active hours, hence, offline. A rate limiter should 
also be implemented so not to trash the drives too much. Also a stop and 
continue should be implemented, so that dedup which couldn't finish 
within a certain time-frame (e.g. one night) can be made continue the 
night after without restarting from the beginning.

3- Only some directories should be deduped, for performance reasons. You 
can foresee where duplicate blocks can exist and where not. Backup 
directories typically, or mailservers directories. The rest is probably 
a waste of time.

> Dedup isn't for an average desktop user. Dedup is for backup storage 
> and virtual images

Not virtual images imho, for the reason above.

Also, the OS is small even if identical on multiple virtual images, how 
much is going to occupy anyway? Less than 5GB per disk image usually. 
And that's the only thing that would be deduped because data likely to 
be different on each instance. How many VMs running you have? 20? That's 
at most 100GB saved one-time at the cost of a lot of fragmentation.

Now if you backup those images periodically, that's a place where I 
would run dedup.

> I'd just make it always use the fs block size. No point in making it 
> variable.

Agreed. What is the reason for variable block size?

>> And then lets bring up the fact that you _have_ to manually compare 
>> any data you
>> are going to dedup.  I don't care if you think you have the greatest 
>> hashing
>> algorithm known to man, you are still going to have collisions 
>> somewhere at some
>> point, so in order to make sure you don't lose data, you have to 
>> manually memcmp
>> the data.

Totally agreed

>> So if you are doing this online, that means reading back the copy you
>> want to dedup in the write path so you can do the memcmp before you 
>> write.  That
>> is going to make your write performance _suck_.
>
> IIRC, this is configurable in ZFS so that you can switch off the 
> physical block comparison. If you use SHA256, the probability of a 
> collission (unless SHA is broken, in which case we have much bigger 
> problems) is 1^128. Times 4KB blocks, that is one collission in 10^24 
> Exabytes. That's one trillion trillion (that's double trillion) Exabytes. 

I like mathematics, but I don't care this time. I would never enable 
dedup without full blocks compare. I think most users and most companies 
would do the same.

If there is full blocks compare, a simpler/faster algorithm could be 
chosen, like md5. Or even a md-64bits which I don't think it exists, but 
you can take MD4 and then xor the first 8 bytes with the second 8 bytes 
so to reduce it to 8 bytes only. This is just because it saves 60% of 
the RAM occupation during dedup, which is expected to be large, and the 
collisions are still insignificant at 64bits. Clearly you need to do 
full blocks compare after that.

BTW if you want to allow (as an option) dedup without full blocks 
compare, SHA1 is not so good: sha-0 already had problems, now sha-1 has 
problems, I almost wouldn't suggest it for cryptographically secure 
stuff foreseeing the future. Use ripemd160 or even better ripemd256 
which is even faster according to 
http://www.cryptopp.com/benchmarks.html  ripemds are much better 
algorithms than shas: they have no known weaknesses.
Note that deduplication IS a cryptographically sensitive matter because 
if sha-1 is cracked, people can nuke (or maybe even alter, and with 
this, hack privileges) other users' files by providing blocks with the 
same SHA and waiting for dedup to pass.
Same thing for AES btw, it is showing weaknesses: use blowfish or twofish.
SHA1 and AES are two wrong standards...

Dedup without full blocks compare seems indeed suited for online dedup 
(which I wouldn't enable, now for one more reason) because with full 
block compares performances would really suck. But please leave full 
blocks compare for the offline dedup.

Also I could suggest a third type of deduplication, but this is 
harder... it's a file-level deduplication which works like xdelta, that 
is, it is capable to recognize piece of identical data on two files, 
which are not at the same offset and which are not even aligned at block 
boundary. For this, a rolling hash like the one of rsync, or the xdelta 
3.0 algorithm could be used. For this to work I suppose Btrfs needs to 
handle the padding of filesystem blocks... which I'm not sure it was 
foreseen.


Above in this thread you said:
> The _only_ reason to defer deduping is that hashing costs CPU time. 
> But the chances are that a modern CPU core can churn out MD5 and/or 
> SHA256 hashes faster than a modern mechanical disk can keep up. A 
> 15,000rpm disk can theoretically handle 250 IOPS. A modern CPU can 
> handle considerably more than 250 block hashings per second. You could 
> argue that this changes in cases of sequential I/O on big files, but a 
> 1.86GHz GHz Core2 can churn through 111MB/s of SHA256, which even SSDs 
> will struggle to keep up with.

A normal 1TB disk with platters can do 130MB/sec sequential, no problems.
A SSD can do more like 200MB/sec write 280MB/sec read sequential or 
random and is actually limited only by the SATA 3.0gbit/sec but soon 
enough they will have SATA/SAS 6.0gbit/sec.
More cores can be used for hashing but multicore implementation for 
stuff that is not natively threaded (such as parallel and completely 
separate queries to a DB) usually is very difficult to do well. E.g. it 
was attempted recently on MD raid for parity computation by 
knowledgeable people but it performed so much worse than single-core 
that it was disabled.

