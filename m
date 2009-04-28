From: Anthony Roberts <btrfs-devel@arbitraryconstant.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Tue, 28 Apr 2009 10:10:08 -0600
Message-ID: <8b61e08616069210e116c254b2ca9d5a@localhost>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de> <1240839448.26451.13.camel@think.oraclecorp.com> <20090428052215.GA22921@cip.informatik.uni-erlangen.de> <1240912971.2149.5.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: <linux-btrfs@vger.kernel.org>
To: Chad Clark <chad@bernoullinetworks.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1240912971.2149.5.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

I don't know if this strikes me as a 1.0 feature, but it doesn't seem like
something that wouldn't need changes to the disk format. :)

Some ioctls occured to me that might be helpful here, without unduly
loading up the kernel with dedup logic:

-A speculative dedup that you could open, do whatever verification you need
(it would be up to the application), and then commit. I believe there's
already an ioctl to retrieve checksums, or your app could compare the bytes
if you were paranoid; this approach would be agnostic to that. Your dedup
handle would be automatically invalidated if any changes happened in the
specified ranges of bytes in the specified files, so it would be safe.

-A way to subscribe to writes in a subvolume, something similar to the
inotify API. You'd get structs that would tell you the
file/offset/size/csum of writes, allowing you to dedup on the fly without
having to crawl the whole filesystem. I'm not sure about the feasibility of
dealing with the volume of traffic you'd get from something like that, but
if it's something where you can keep a hash table in memory it might be
doable.

-Anthony

On Tue, 28 Apr 2009 06:02:51 -0400, Chris Mason <chris.mason@oracle.com>
wrote:
> On Tue, 2009-04-28 at 07:22 +0200, Thomas Glanzmann wrote:
>> Hello Chris,
>> 
>> > There is a btrfs ioctl to clone individual files, and this could be
>> > used
>> > to implement an online dedup.  But, since it is happening from
>> > userland,
>> > you can't lock out all of the other users of a given file.
>> 
>> > So, the dedup application would be responsible for making sure a given
>> > file was not being changed while the dedup scan was running.
>> 
>> I see, does that mean that I can not do ,,dedup'' for files that are
>> currently opened by a userland program?
> 
> No, but it does mean the dedup done from userland is racey.  Picture
> this:
> 
> process A:
>     create some_file # some_file matches the contents of another file
> 
> dedup proc:
>     check some_file
>     decide to start block dedup
> 
> process A:
>      modify some_file
> 
> dedup proc:
>      progress through block dedup
> 
> So, this will happily replace blocks in some_file with the dedup blocks.
> But there's no way to atomically swap them.
> 
> We could create new ioctls for this, basically a variant of the clone
> file ioctl that makes sure a given set of pages has a given sum (or
> strict memory contents) before doing the swap.
> 
> But they don't exist yet.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
