Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward2p.cmail.yandex.net ([77.88.31.17]:50008 "EHLO
        forward2p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756976AbcHWADL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Aug 2016 20:03:11 -0400
From: Tomokhov Alexander <alexoundos@ya.ru>
To: Duncan <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <pan$3c21f$ab5f3fdc$db27222f$e3bd5a66@cox.net>
References: <126611471805976@web2j.yandex.ru> <pan$3c21f$ab5f3fdc$db27222f$e3bd5a66@cox.net>
Subject: Re: Will Btrfs have an official command to "uncow" existing files?
MIME-Version: 1.0
Message-Id: <59621471910096@web8m.yandex.ru>
Date: Tue, 23 Aug 2016 02:54:56 +0300
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the in-depth answer.

Well, "simple enough process" is still a sequence of steps which must be carefully done. In a proper order with correct parameters depending on environment. It's work with data, data which can be invaluable.
No, really, I'm not a beginner user. I use Arch Linux everyday from 2009, program in different languages and so on. But even a few ordered manual commands for changing file attribute involving quite dangerous "mv" and "cp" (overwrite case) is something very suspicious.

"2a" - step depends on whether another filesystem simply exists, better if it's free, has enough space, supports same file permission features, etc. Requires time to figure out these conditions, not suitable for all systems.

"2b" - step with "mv out". Out to where? What if the file with the same name already exists in a destination directory you "mv out". Not reliable. Ok, need to create temporary directory. Where, how to call it then - involves conditional checks performed by user.

Similarly creation of empty file should also satisfy the condition that it's name is unique in the directory.

Additionally all existing ways of "uncow" require manual free space check beforehand. User must control and monitor if the file is currently not opened. I'm sure I missed something else.
These all are problems that are unrelated to file attributes itself, but user must think of them for some reason. An official specialized tool could automatically track all these conditions, perform the right sequence of actions and report to user results.

Yes I do take into consideration that there are situations when "uncow" cannot be actually applied to a file for the reasons you described. No snapshots atm in my case and, for example, I have firefox sqlite database file with 900+ extents on a rotational disk. I wouldn't say it's noticeable, but at least desire the number of extents not to increase further so that I won't notice it ever. I admit that Btrfs may defragment it, but may not. Sometimes we need a more controllable approach.

22.08.2016, 05:00, "Duncan" <1i5t5.duncan@cox.net>:
> Tomokhov Alexander posted on Sun, 21 Aug 2016 21:59:36 +0300 as excerpted:
>
>>  Btrfs wiki FAQ gives a link to example Python script:
>>  https://github.com/stsquad/scripts/blob/master/uncow.py
>>
>>  But such a crucial and fundamental tool must exist in stock btrfs-progs.
>>  Filesystem with CoW technology at it's core must provide user sufficient
>>  control over CoW aspects. Running 3rd-party or manually written scripts
>>  for filesystem properties/metadata manipulation is not convenient, not
>>  safe and definitely not the way it must be done.
>
> Why? No script or dedicated tool needed as it's a simple enough process.
>
> Simply:
>
> 1. chattr +C (that being nocow) the containing directory.
>
> Then either:
>
> 2a. mv the file to and from another filesystem, so it's actually created
> new in the directory and thus inherits the nocow attribute at file
> creation,
>
> or
>
> 2b. mv out and then cp the file back into place with --reflink=never,
> again, forcing the file to be created new in the directory, so it
> inherits the nocow attribute at creation,
>
> OR (replacing both steps above)
>
> Create the empty file (using touch or similar), set it nocow, and use cat
> srcfile >> destfile style redirection to fill it, so the file again gets
> the nocow attribute set before it has content, but allowing you to set
> only the file nocow, without setting the containing directory nocow.
>
> Of course there's no exception here to the general case, if you're doing
> the same thing to a whole bunch of files, setting up a script to do it
> may be more efficient than doing it to each one manually one by one, and
> a script could be useful there, but that's a general rule, nothing
> exceptional for btrfs nocow, and a script or fancy tool isn't actually
> required, regardless.
>
> The point being, cow is the default case, and should work /reasonably/
> well in most cases, certainly well enough so that normal people doing
> normal things shouldn't need to worry about it. The only people who will
> need to worry about it, therefore, are people worried about the last bit
> of optimization possible to various corner-case use-cases that don't
> match default assumptions very well, and it's precisely these sorts of
> people that are /technical/ enough to be able to understand both why they
> might want nocow (and what the positives and negatives are going to be),
> and how to actually get it.
>
>>  Also is it possible (at least in theory) to "uncow" files being
>>  currently opened in-place? Without the trickery with creation & renaming
>>  of files or directories. So that running "chattr +C" on a file would be
>>  sufficient. If possible, is it going to be implemented?
>
> It's software. Of course it's possible, tho it's also possible the
> negatives make it not worth the trouble. If the implementation simply
> creates a new file and does a --reflink=never cp in the background when
> the nocow file attribute is set, it may not be worth it.
>
> As to whether it'll ultimately be implemented, I don't know as I'm not a
> dev. But even if it is ultimately implemented, it might well be five
> years out or longer, because there's simply way more "it'd be nice" btrfs-
> related ideas out there than there are devs working on implementations,
> and projecting more than five years out in a software development
> environment like the Linux kernel doesn't make a lot of sense, so five
> years out or longer is likely, but beyond that, nobody really knows.
>
> Add to that the fact that a lot of existing btrfs features took rather
> longer to implement and stabilize than originally projected, and...
>
> Meanwhile, if you aren't already, be aware that the basic concepts of
> snapshots locking in references to existing extents as unchangeable
> (snapshots being a btrfs feature that depends on its cow nature), and
> nocow setting files as rewrite-in-place, basically can't work with each
> other at the concept level, because once a snapshot is taken, extents
> referenced by that snapshot really /cannot/ change until that snapshot is
> deleted, something that can only be true if the extents are copy-on-write.
>
> To work around this btrfs makes the nocow attribute weaker than the
> snapshot locking a particular extent in place, using a process sometimes
> referred to as cow-once or cow1. When a change is written to a(n
> otherwise) nocow file that has been snapshotted and thus has its extents
> locked in place, the block of the file that is changed will have to be
> cowed, despite the nocow attribute. However, the nocow attribute is
> kept, and any further changes to that block will be rewritten to the new
> location it was copied to without further cowing of that block, of course
> until the next snapshot locks that location in place as well, at which
> further writes to the same block will of course cow it once more, to a
> third location, which will again remain in place until yet another
> snapshot...
>
> So snapshotting a nocow file means it's no longer absolutely nocow, it's
> now cow1. If the rewrite rate is higher than the snapshot rate, the nocow
> should still have some effect, but where the snapshot rate is higher than
> the rewrite rate, the effect will be as if the file wasn't nocow at all,
> because each snapshot will lock in the file as it then exists.
>
> It is for this reason that the recommendation is to keep nocow files in a
> dedicated subvolume, so snapshots to the parent subvolume exclude the
> nocow files, and to minimize snapshotting of the nocow subvolume. As
> long as snapshotting is occurring at all, however, there will be some
> fragmentation over time, but by combining a limited snapshotting rate
> with a reasonable defrag schedule targeting the nowcow files as well,
> fragmentation should at least remain under control.
>
> And of course nocow has other negatives as well. Setting nocow turns off
> both compression (if you otherwise have compression on) and checksumming,
> thus killing two other major btrfs features, including its realtime file
> integrity validation via checksumming.
>
> So there are definitely negatives to nocow that must be weighed before
> setting it. But it's worth keeping in mind that all of these features
> are really practical due to cow in the first place, the reason other
> filesystems don't tend to have them, and that while there is definitely a
> tradeoff to cow vs. nocow, setting nocow doesn't turn off features you'd
> have in conventional filesystems anyway, so it's not as if you're losing
> features you'd have if you weren't using btrfs with its cow by default,
> in the first place.
>
> --
> Duncan - List replies preferred. No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master." Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
