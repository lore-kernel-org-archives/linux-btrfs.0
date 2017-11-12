Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f173.google.com ([74.125.82.173]:53678 "EHLO
        mail-ot0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbdKLAyw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Nov 2017 19:54:52 -0500
Received: by mail-ot0-f173.google.com with SMTP id 105so1956946oth.10
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Nov 2017 16:54:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171112004230.GJ27985@carfax.org.uk>
References: <CAJCQCtTJXpoSExk7aVKCZKk5YCpV6V31zUpLgQSxa+k4V8+x+w@mail.gmail.com>
 <20171112004230.GJ27985@carfax.org.uk>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 11 Nov 2017 17:54:51 -0700
Message-ID: <CAJCQCtR5oqOT2JdO_-gSgVCnBpYz_53eBOeF32G6+ZfX6RK7Kw@mail.gmail.com>
Subject: Re: btrfs-image hash collision option, super slow
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 11, 2017 at 5:42 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Nov 11, 2017 at 05:18:33PM -0700, Chris Murphy wrote:
>> OK this might be in the stupid questions category, but I'm not
>> understanding the purpose of computing hash collisions with -ss. Or
>> more correctly, why it's taking so much longer than -s.
>>
>> It seems like what we'd want is every filename to have the same hash,
>> but for the file to go through a PBKDF so the hashes we get aren't
>> (easily) brute forced. So I totally understand that -ss should take
>> much longer than -s, but this is at least two orders magnitude longer
>> (so far). That's why I'm confused.
>>
>> -s option on this file system took 5 minutes, start to finish.
>> -ss option is at 8 hours and counting.
>>
>> The other part I'm not groking is that some filenames fail with:
>>
>> WARNING: cannot find a hash collision for 'Tool', generating garbage,
>> it won't match indexes
>>
>> So? That seems like an undesirable outcome. And if it were just being
>> pushed through a PBKDF function, it wouldn't fail. Every
>> file/directory "Tool" would get the same hash on *this* run of
>> btrs-image. If I run it again, or someone else runs it, they'd get
>> some other hash (same hashes for each instance of "Tool" on their
>> filesystem).
>
>    In the FS tree, you can go from the inode of the file to its name
> (where the inode is in the index, and the name is stored in the
> corresponding data item). Alternatively, you can go from the filename
> to the inode. In the latter case, since the keys are a structured 17
> byte object, you obviously can't fit the whole filename into the key,
> so the filename is hashed (using, IIRC, CRC32), and it's the hash that
> appears in the key of the index.
>
>    When an image is made without the -s options, the whole metadata is
> stored, including all the filenames in the data items. For some
> people, that's a security risk, and they don't want their filenames
> leaking out, so -s exists to put junk in the filename records.
> However, it doesn't change the hashes in the index to correspond with
> the modified filenames, because that would at minimum require the
> whole tree to be rebuilt (because all the items would have different
> hashes, and hence different ordering in the index). This is a bad
> thing for debugging, because you're not getting the details of the
> tree as it was in the broken filesystem. So, in this case, the image
> is actually broken, because the filenames don't match the hashes.
>
>    Most of the time, that's absolutely fine, because the thing being
> debugged is somewhere else, and it doesn't matter that "ls" on the
> restored FS won't work right.
>
>    However, in some (possibly hypothetical) cases, it _does_ matter,
> and you do need the hashes to match the filenames. This is where -ss
> comes in. We can't generate random filenames and then take the hashes
> of those, because of the undesirability of rewriting the whole FS tree
> to reindex it with the changed hashes. So, what -ss tries to do is
> stick with the original hashes and find arbitrary filenames which
> match them. It's (I think) CRC32, so it shouldn't be too hard, but
> it's still non-trivial amounts of work to reverse engineer a
> human-readable ASCII filename which hashes to a given value.
> Particularly if, as was the case when Josef wrote it, a simple
> brute-force algorithm was used.
>
>    It could definitely be improved -- I believe there are some good
> (but non-trivial) algorithms for finding preimages for CRC32 checksums
> out there. It's just that btrfs-image doesn't use them. However, it's
> not an option that's needed very often, so it's probably not worth
> putting in the effort to fix it up. (I definitely remember Josef
> commenting on IRC when he wrote -s and -ss that it could almost
> certainly be done more efficiently, but he had bigger fish to fry at
> the time, like fixing the broken FS he was working on)
>
>    As to the thing where it's not finding a pre-image at all -- I'm
> guessing here, but it's possible that this is a case where two of the
> orginal filenames hashed to the same value. If that happens, one of
> the hashes is incremented by a small integer in a predictable way
> before storage. So it may be that the resulting value isn't mappable
> to an ASCII pre-image, or that the search just gives up before finding
> one.
>

Super explanation, thanks Hugo. Maybe it's worth an additional note in
the man page, just how expensive it is. I'm definitely regretting not
starting this imaging in a tmux session.

-- 
Chris Murphy
