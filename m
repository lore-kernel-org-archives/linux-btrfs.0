Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55877 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDKGKe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 02:10:34 -0400
Received: by mail-wi0-f181.google.com with SMTP id hm4so446502wib.14
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Apr 2014 23:10:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$18fc6$7005cb64$a96a9a75$5cd6742f@cox.net>
References: <CAH3EO-o-S7WveO7V++zB1+Zd3kfrxk4YyMZ6P+GrcNWfALgrfA@mail.gmail.com>
	<20140410203439.GB20307@carfax.org.uk>
	<CAH3EO-oSzYTd2Q3H3wfg9eV9ii-phuquvtzU2mT5KGKF1_x5iw@mail.gmail.com>
	<pan$18fc6$7005cb64$a96a9a75$5cd6742f@cox.net>
Date: Thu, 10 Apr 2014 23:10:33 -0700
Message-ID: <CAH3EO-qB91cTUT0ZAib4xAA82_RDGM4dOWmp3smtUfS_=e1uxg@mail.gmail.com>
Subject: Re: Filesystem unable to recover from ENOSPC
From: Chip Turner <cturner@pattern.net>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for the extremely detailed and helpful reply.  I now
understand what was happening.  To me, when I read "total=" I guess I
thought that was capacity rather than allocated (but now "holey")
chunks.  I agree that perhaps adjusting the phrasing of the output of
df and show would be helpful in making this clearer (or perhaps some
adjustment to the wiki; maybe I will do that).

I assume metadata is where filesystem information (directory entries,
inodes, etc) are stored and not being able to delete was because there
wasn't room in the metadata chunks, and no room to allocate more
metadata chunks?  Or are those also data chunks and it was purely
about data chunks?

Does defrag do similar reallocation to balance such that it would help
combat this behavior?

Thanks again,
Chip

On Thu, Apr 10, 2014 at 7:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chip Turner posted on Thu, 10 Apr 2014 15:40:22 -0700 as excerpted:
>
>> On Thu, Apr 10, 2014 at 1:34 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> On Thu, Apr 10, 2014 at 01:00:35PM -0700, Chip Turner wrote:
>>>> btrfs show:
>>>> Label: none  uuid: 04283a32-b388-480b-9949-686675fad7df
>>>> Total devices 1 FS bytes used 135.58GiB
>>>> devid    1 size 238.22GiB used 238.22GiB path /dev/sdb2
>>>>
>>>> btrfs fi df:
>>>> Data, single: total=234.21GiB, used=131.82GiB
>>>> System, single: total=4.00MiB, used=48.00KiB
>>>> Metadata, single: total=4.01GiB, used=3.76GiB
>
> [Tried all the usual tricks, didn't work.]
>
>>> One thing you could do is btrfs dev add a small new device to the
>>> filesystem (say, a USB stick, or a 4 GiB loopback file mounted over NBD
>>> or something). Then run the filtered balance. Then btrfs dev del the
>>> spare device.
>>
>> Ah, this worked great.  It fixed it in about ten seconds.
>>
>> I'm curious about the space report; why doesn't Data+System+Metadata add
>> up to the total space used on the device?
>
> Actually, it does... *IF* you know how to read it.  Unfortunately that's
> a *BIG* *IF*, because btrfs show very confusingly reports two very
> different numbers using very similar wording, without making *AT* *ALL*
> clear what it's actually reporting.
>
> Try this:
>
> Add up the df totals (which is the space allocated for each category
> type). 234.21 gig, 4.01 gig, 4 meg.  238 gig and change, correct?  Look
> at the show output.  What number does that look like there?
>
> Now do the same with the df used (which is the space used out of that
> allocated).  131.82 gig, 3.76 gig, (insubstantial).  135 gig and change.
> What number from btrfs show does /that/ look like?
>
> Here's what's happening and how to read those numbers.  Btrfs uses space
> in two stages.
>
> First it on-demand allocates chunks dedicated to the usage type.  Data
> chunks are 1 GiB in size.  Metadata chunks are 256 MiB in size, a quarter
> the size of a data chunk, altho by default on a single device they are
> allocated in pairs, dup mode, so 512 MiB at a time (half a data-chunk),
> tho I see your metadata is single mode so it's still only 256 MiB at a
> time.
>
> The space used by these ALLOCATED chunks appears as the totals in btrfs
> filesystem df and as used in btrfs filesystem show for individual
> devices, but the show total line comes from somewhere else *ENTIRELY*,
> which is why the reported individual device used number sum up to (if
> there's more than one device, the individual device numbers can be added
> together, if it's just one, that's it) so much larger than the number
> reported by show as total used.
>
> That metadata-single, BTW, probably explains Hugo's observation, that you
> were able to use more of your metadata than most, because you're running
> single metadata mode instead of the more usual dup.  (Either you set it
> up that way, or mkfs.btrfs detected SSD, in which case it defaults to
> single metadata for a single device filesystem.)  So you were able to get
> closer to full metadata usage.  (Btrfs reserves some metadata, typically
> about a chunk, which means about two chunks in dup mode, for its own
> usage.  That's never usable so it always looks like you have a bit more
> free metadata space than you actually do.  But as long as there's
> unallocated free space to allocate additional metadata blocks from, it
> doesn't matter.  Only when all space is allocated does it matter, since
> then it still looks like you have free metadata space to use when you
> don't.)
>
> Anyway, once btrfs has a chunk of the appropriate type, it fills it up.
> When necessary, it'll try to allocate another chunk.
>
> The actual usage of the already allocated chunks appears in btrfs
> filesystem df as used, with the total of all types for all devices also
> appearing in btrfs filesystem show on the total used line.
>
> So data+metadata+system allocated as reported by df, adds up to the
> totals reported as used by show for all the individual devices, added
> together.
>
> And data+metadata+system actually used (out of the allocated) as reported
> by df, adds up to the total reported by show as used, on the total used
> line.
>
> But they are two very different numbers, one total chunks allocated, the
> other the total used OF those allocated chunks.  Makes sense *IF* *YOU*
> *KNOW* *HOW* *TO* *READ* *IT*, but otherwise, it's *ENTIRELY* misleading
> and confusing!
>
> There has already been discussion and proposed patches for adding more
> detail to df and show, with the wording changed up as well, and I sort of
> expected to see that in btrfs-progs v3.14 when it came out altho I'm
> running it now and don't see a change, but FWIW, from the posted examples
> at least, I couldn't quite figure out the proposed new output either, so
> it might not be that much better than what we have.  Which might or might
> not have anything to do with it not appearing in v3.14 as I expected.
> Meanwhile, now that I actually know how to read the current output, it
> does provide the needed information, even if the output /is/ rather
> confusing to newbies.
>
> Back to btrfs behavior and how it leads to nospc errors, however...
>
> When btrfs deletes files, it frees space in the corresponding chunks, but
> since individual files normally use a lot more data space than metadata,
> data chunks get emptied faster than the corresponding metadata chunks.
>
> But here's the problem.  Btrfs can automatically free space back to the
> allocated chunks as files get deleted, but it does *NOT* (yet) know how
> to automatically deallocate those now empty or mostly empty chunks,
> returning them to the unallocated pool so they can be reused as another
> chunk-type if necessary.
>
> So btrfs uses space up in two stages, but can only automatically return
> unused space back in one stage, not the other.  Currently, to deallocate
> and free those unused blocks, you must run balance (which is where the
> filtered balance -dusage=20 or whatever, to balance, in that case only
> data chunks with 20% usage or less), which rewrites those blocks and
> consolidates any remaining usage as it goes, freeing up the blocks it
> empties back to the unallocated pool.
>
> At some point the devs plan to automate the process, probably by
> automatically triggering a balance start -dusage=5 or balance start
> -musage=5, or whatever, as necessary.  But that hasn't happened yet.
> Which is why admins must currently keep an eye on things and run that
> balance manually (or hack up some sort of script to do it automatically,
> themselves) when necessary.
>
>> Was the fs stuck in a state
>> where it couldn't clean up because it couldn't write more metadata (and
>> hence adding a few gb allowed it to balance)?
>
> Basically, yes.  As you can see from the individual device line in the
> above show output, 238.22 gig used (that is, chunks allocated), of 238.22
> filesystem size.  There's no room left to allocate additional chunks, not
> even one in ordered to rewrite the remaining data from some of those
> mostly empty data chunks, in ordered to return them to the unallocated
> pool.
>
> With a bit of luck, you would have had at least one entirely empty data
> chunk, in which case a balance start -dusage=0 would have freed it (since
> it was entirely empty and thus there was nothing to rewrite to a new
> chunk), thus giving you enough space to actually allocate a new chunk, to
> write into and free more of them.  But if you tried a balance start
> -dusage=0 and it couldn't find even one entirely empty data chunk to
> free, as apparently you did, then you had a problem, since all available
> space was already allocated.
>
> Temporarily adding another device gave it enough room to allocate a few
> new chunks, such that balance then had enough space to rewrite a few of
> the mostly empty chunks, thereby freeing enough space so you could then
> btrfs device delete the new device, rewriting those new chunks back to
> the newly deallocated space on the original device.
>
>> After the balance, the
>> used space dropped to around 150GB, roughly what I'd expect.
>
> =:^)
>
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Chip Turner - cturner@pattern.net
