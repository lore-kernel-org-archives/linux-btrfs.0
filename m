Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:45221 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaIZQPe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Sep 2014 12:15:34 -0400
Received: by mail-ie0-f179.google.com with SMTP id tp5so11393373ieb.38
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Sep 2014 09:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
References: <8465933.4bvG1Xk5zJ@linuxpc>
	<pan$92371$cf7e2c62$a94a9382$e3e154b@cox.net>
Date: Fri, 26 Sep 2014 18:15:33 +0200
Message-ID: <CAOsFrTfQHZjUbBcMkx9e30x6fdi216PAMPRo+QoVmqAR0pZH1Q@mail.gmail.com>
Subject: Re: Backup: Compare sent snapshots
From: G EO <1g2e3o4@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay I have a couple of questions again regarding the lost local
reference part:

How was the reverse btrfs send/receive meant? should I simply do

"btrfs send /mnt/backup-partition/snapshot_name | btrfs receive
/mnt/root-partition/"

or should I use btrfs send -p and compare to some newly created local
snapshot? When I send back  the lost reference from the backup drive
will that write the incremental part that has changed since then or
will it allocate space the size of the snapshot?

In https://btrfs.wiki.kernel.org/index.php/Incremental_Backup there is
the talk of "Efficiently determining and streaming the differences
between two snapshots if they are either snapshots of the same
underlying subvolume, or have a parent-child relationship." Wont that
required part get lost be reversely sending the last local reference?


What would you do in the case of a new install? You import your last
home snapshot (as your primary home subvolume) using "btrfs send
/mnt/backup-partition/home_timestamp | btrfs receive
/mnt/root-partition/". Now you have imported your snapshot but its
still read only. How to make it writable? I simply did this for now by
making a snapshot of the read only snapshot and renamed that snapshot
to "home". Is that the right way to do it?

Now on the new install we want to continue doing our backups using the
old backup drive. Since we have the readonly snapshot we imported (and
we took a writeable snapshot of it that is now our primary snapshot)
we can simply cotinue doing the incremental step without the bootstrap
step right?


You would really hep me in a great manner if you could answer some of
the questions.

On Mon, Mar 31, 2014 at 12:41 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> GEO posted on Sun, 30 Mar 2014 10:58:13 +0200 as excerpted:
>
>> Hi,
>>
>> I am doing backups regularly following the scheme of
>> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
>
> Be aware that send/receive is getting a lot of attention and bugfixes
> ATM.  To the best of my knowledge, where it completes without error it's
> 100% reliable, but there are various corner-cases where it will presently
> trigger errors.  So I'd have a fallback backup method ready, just in case
> it quits working, and wouldn't rely in it working at this point.  (Altho
> with all the bug fixing it's getting ATM, it should be far more reliable
> in the future.)
>
> FWIW, the problems seem to be semi-exotic cases, like where subdirectory
> A originally had subdir B nested inside it, but then that was reversed,
> so A is now inside B instead of B inside A.  Send/receive can get a bit
> mixed up in that sort of case, still.
>
>> It states we keep a local reference of the read only snapshot we sent to
>> the backup drive, which I understand.
>> But now I have a question:  When I do a read only snapshot of home, send
>> the difference to the backup drive, keep it until the next incremental
>> step, send the difference to the backup drive, remove the old read only
>> snapshot and so on...
>> I wonder what happens if the read only snapshot I keep as a local
>> reference got corrupted somehow.
>> Then maybe too much difference would be sent which would not be
>> dramatic, or too less, which would be.
>
> In general, it wouldn't be a case of too much or too little being sent.
> It would be a case of send or receive saying, "Hey, this no longer makes
> sense, ERROR!"
>
> But as I said above, as long as both ends are completing without error,
> the result should be fully reliable.
>
>> Is there a quick way I could compare the last sent snapshot to the local
>> one, to make sure the local reference is still the same?
>
> A checksum of all content (including metadata), using md5sum or the like,
> on both ends.  Or do a checksum and keep a record of the result,
> comparing a later result to the previous one for the same snapshot.
>
> As for what to actually do that checksum on, I'll let someone with more
> knowledge and experience speak up there.
>
>> Apart from that, imagine I somehow lost the local reference (e.g. delete
>> it by mistake), would there still be a way to sync the difference to the
>> last sent snapshot on the backup device?
>
> Two possibilities:
>
> 1) Reverse the send/receive, sending it from the backup to the working
> instance, thereby recreating the missing snapshot.
>
> 2) Keep more than one snapshot on each end, with the snapshot thinning
> scripts kept in sync.
>
> So if you're doing hourly send/receive, keep the latest three, plus the
> one done at (say) midnight for each of the previous two days, plus the
> midnight snapshot for say Saturday night for the last four weeks, being
> sure to keep the same snapshots on both ends.
>
> That way, if there's a problem with the latest send/receive, you can try
> doing a send/receive against the two hour ago or two day ago base,
> instead of the one from an hour ago.  If that doesn't work, you can try
> reversing the send/receive, sending from the backup.
>
> But as I said, do be prepared for send/receive bugs and the errors they
> trigger.  If you hit one, you may have to fall back to something more
> traditional such as rsync, presumably reporting the bug and keeping the
> last good received snapshots around as a reference so you can try again
> with test patches or after the next kernel upgrade.
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
