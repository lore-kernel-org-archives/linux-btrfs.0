Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36033 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbcHURzv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Aug 2016 13:55:51 -0400
Received: by mail-oi0-f41.google.com with SMTP id f189so124170599oig.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Aug 2016 10:54:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$3c68e$c7a03ce$dfc0806f$7216696d@cox.net>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
 <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
 <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com>
 <CAJCQCtTuhTKBK=zjXsq3o0mFnU6T7hYsLLr2VD0N7gqJ7vX0FQ@mail.gmail.com> <pan$3c68e$c7a03ce$dfc0806f$7216696d@cox.net>
From: Ivan Sizov <sivan606@gmail.com>
Date: Sun, 21 Aug 2016 20:54:09 +0300
Message-ID: <CAMG9ccyPduc+eSspQUG04c12N2hiUik9ts7x25Wm-MkJF4QPKw@mail.gmail.com>
Subject: Re: Strange behavior after "rm -rf //"
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan, you was right. The commit didn't happen and nothing was
deleted except ext4 /boot. the System booted normally after GRUB2 and
kernel recovery.

Thank you much.

P.S. I'm sorry for the late answer.

2016-08-09 23:30 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
> Chris Murphy posted on Tue, 09 Aug 2016 11:10:08 -0600 as excerpted:
>
>> On Mon, Aug 8, 2016 at 12:38 PM, Ivan Sizov <sivan606@gmail.com> wrote:
>>> 2016-08-08 20:13 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
>>>> Just a wild guess, the deletions may be in the tree log and haven't
>>>> been applied to the other trees (fs tree, extent tree, etc). So yes
>>>> I'd expect they get deleted on a rw mount.
>>>>
>>>> This is what kernel? Because kernel 4.6 offers mount option
>>>> "nologreplay" which suggests even if you do mount -r that log replay
>>>> happens, so you shouldn't see these deleted files unless you mount ro
>>>> *and* use nologreplay mount option.
>>>
>>> Live USB has kernel 4.5.7. Maybe I should try to run "btrfs rescue
>>> zero-log" and then mount RW? Will the files safe in that case?
>>
>> Depends on what's in the log that you're zeroing out. It's entirely
>> possible other things are lost, not just the incomplete deletion. And
>> also I have no idea if the deletion is entirely contained in only the
>> tree log.
>
> It's worth noting a critical difference between btrfs replay logs and
> conventional filesystem replay logs, however, with the result being that
> there's a fair chance the log replay has absolutely nothing to do with
> this case at all, and that it's simply commit vs. crash timing.
>
> Btrfs is copy-on-write, with commits designed to be atomic -- changes
> work their way up the tree until a root commit finalizes them, and if a
> crash occurs, all changes since the last successful commit (with a commit
> every 30 seconds by default, and a mount option to change that) are
> normally lost.  Because the filesystem is copy-on-write, that means the
> filesystem should be consistent at that commit, and changes made after
> that will be in different locations that haven't made it into the tree
> yet, since the next commit wasn't able to happen due to the crash.  Thus,
> the stuff that conventional filesystems log simply doesn't apply to btrfs
> at all.
>
> By contrast, conventional filesystems rewrite a lot of data and metadata
> in-place, and logging lets them write out to a temporary area the changes
> they intend to make before they actually write them to the permanent
> location, so that in the event of a crash, any data partially written to
> the permanent location will be replayed from the log, while if the crash
> happened when writing the log so it's corrupt, that record won't be
> replayed, and the old content will remain in place.
>
> Tho of course writing all data twice tends to hit performance rather
> hard, so what most event logging filesystems do is only log the metadata,
> not the actual data.  This lets them be much faster than if they were
> logging the data, and normally protects the filesystem structure, but
> there's some chance that files rewritten in-place will be corrupt if a
> crash happens at the wrong moment.  But it limits the damage to only the
> file being written at the time, and does away with the requirement to fsck
> the entire filesystem after every crash.
>
> So what /does/ the btrfs log do, then?  Good question! =:^)  Rather
> simply, keeping in mind that commits only normally trigger every 30
> seconds, the btrfs log tracks fsyncs (individual file syncs, as opposed
> to whole filesystem syncs), recording them in a replay log, so the
> filesystem can return success on the fsync, that the file was actually
> synced to permanent storage (often ssds these days, so not always "disk"
> as it used to be), without having to either wait upto 30 seconds for the
> next root tree commit, or forcing a full filesystem sync and commit,
> possibly including many other files, when only the one was requested.
>
> So with btrfs, it's *only* fsyncs that are logged to the replay log, and
> that only to be able to truthfully return that the file was written to
> permanent storage, not normal filesystem operations, which are already
> atomic due to the copy-on-write semantics, and thus don't need logged.
>
> So then, the question becomes one of whether rm -rf, or whatever other
> actual command was used to do the deletes, called fsync, or not.  If the
> command didn't call fsync, then it would have been the normal btrfs
> commit mechanism, again, every 30 seconds by default, that would have
> been in play here, and the btrfs log replay wouldn't have anything to do
> with it.
>
> Which I actually strongly suspect to be the case.  It's likely that the
> last commit wasn't completed, so the btrfs reverted to the last atomic
> commit.  That would also explain why a read-only mount /without/ the
> nologreplay option still showed the files, since read-only does normally
> still replay that fsync log, so if the files were caught in it, they
> shouldn't show up at all.
>
>
> Meanwhile, back to the original scenario, just another demonstration of
> what every good sysadmin knows, often from hard experience, admin fat-
> fingering -- the human factor --  PEBKAC -- is as much of a danger to the
> data and the system, if not more, than device or software failure.  If
> would-be backups can't protect from that, they're not backups.  Which is
> why simple RAID fails as a backup method, even if it can protect against
> device failure.  And of course, there's only two cases for the value of
> the data, it's either worth the hassle and resources to backup, or it's
> not, and if it's not backed up, by definition of not having that backup,
> you're defining it as the latter, no matter any claims to the contrary.
> In this case, as too many unfortunate people eventually find out,
> actions, or the lack of them, speak louder than words, and if the data is
> lost due to not having a backup, well, the only thing to do is to be
> happy that the thing your actions defined as worth more than that data,
> the time/hassle/resources necessary to do it, was saved.
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
Ivan Sizov
