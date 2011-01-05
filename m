From: Gordan Bobic <gordan@bobich.net>
Subject: Re: Offline Deduplication for Btrfs
Date: Wed, 05 Jan 2011 20:46:52 +0000
Message-ID: <4D24D8BC.90808@bobich.net>
References: <1294245410-4739-1-git-send-email-josef@redhat.com>	<4D24AD92.4070107@bobich.net> <20110105194645.GC2562@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110105194645.GC2562@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2011 07:46 PM, Josef Bacik wrote:

> Blah blah blah, I'm not having an argument about which is better because I
> simply do not care.  I think dedup is silly to begin with, and online dedup even
> sillier.

Offline dedup is more expensive - so why are you of the opinion that it 
is less silly? And comparison by silliness quotiend still sounds like an 
argument over which is better.

> The only reason I did offline dedup was because I was just toying
> around with a simple userspace app to see exactly how much I would save if I did
> dedup on my normal system, and with 107 gigabytes in use, I'd save 300
> megabytes.  I'll say that again, with 107 gigabytes in use, I'd save 300
> megabytes.  So in the normal user case dedup would have been wholey useless to
> me.

Dedup isn't for an average desktop user. Dedup is for backup storage and 
virtual images. I don't remember anyone ever saying it is for the 
average desktop user. I am amazed you got that much saving even - I 
wouldn't expect there to be any duplicate files on a normal system. 
Compression is a feature that the desktop users would benefit with, not 
deduplication.

> Dedup is only usefull if you _know_ you are going to have duplicate information,
> so the two major usecases that come to mind are
>
> 1) Mail server.  You have small files, probably less than 4k (blocksize) that
> you are storing hundreds to thousands of.  Using dedup would be good for this
> case, and you'd have to have a small dedup blocksize for it to be usefull.

Explain to me why you think this would yield duplicate blocks. If your 
server is Maildir, headers will be in the mail files, and because all 
emails went to different users, they'd have different headers, and thus 
not be dedupable.

> 2) Virtualized guests.  If you have 5 different RHEL5 virt guests, chances are
> you are going to share data between them, but unlike with the mail server
> example, you are likely to find much larger chunks that are the same, so you'd
> want a larger dedup blocksize, say 64k.  You want this because if you did just
> 4k you'd end up with a ridiculous amount of framentation and performance would
> go down the toilet, so you need a larger dedup blocksize to make for better
> performance.

Fragmentation will cause you problems anyway, the argument in the UNIX 
world since year dot was that defragging doesn't make a damn worth of 
difference when you have a hundred users hammering away on a machine 
that has to skip between all their collective files.

If you have VM image files a-la vmware/xen/kvm, then using blocks of the 
same size as the guests is the only way that you are going to get sane 
deduplication performance. Otherwise the blocks won't line up. If the 
dedupe block size is 4KB and guest fs block size is 4KB, that's a 
reasonably clean case.

The biggest win by far, however, would be when using chroot type guests, 
as I mentioned.

> So you'd want an online implementation to give you a choice of dedup blocksize,
> which seems to me to be overly complicated.

I'd just make it always use the fs block size. No point in making it 
variable.

> And then lets bring up the fact that you _have_ to manually compare any data you
> are going to dedup.  I don't care if you think you have the greatest hashing
> algorithm known to man, you are still going to have collisions somewhere at some
> point, so in order to make sure you don't lose data, you have to manually memcmp
> the data.  So if you are doing this online, that means reading back the copy you
> want to dedup in the write path so you can do the memcmp before you write.  That
> is going to make your write performance _suck_.

IIRC, this is configurable in ZFS so that you can switch off the 
physical block comparison. If you use SHA256, the probability of a 
collission (unless SHA is broken, in which case we have much bigger 
problems) is 1^128. Times 4KB blocks, that is one collission in 10^24 
Exabytes. That's one trillion trillion (that's double trillion) 
Exabytes. That is considerably more storage space than there is likely 
to be available on the planet for some time. And just for good measure, 
you could always up the hash to SHA512 or use two different hashes (e.g. 
a combination of SHA256 and MD5).

> Do I think offline dedup is awesome?  Hell no, but I got distracted doing it as
> a side project so I figured I'd finish it, and I did it in under 1400 lines.  I
> dare you to do the same with an online implementation.  Offline is simpler to
> implement and simpler to debug if something goes wrong, and has an overall
> easier to control impact on the system.

It is also better done outside the FS if you're not going to do it 
properly using FL-COW or fuse based lessfs.

Gordan
