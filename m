Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35979 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbcBYCHO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 21:07:14 -0500
Received: by mail-lf0-f51.google.com with SMTP id 78so23962093lfy.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 18:07:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$a88ba$a1bf6bdd$c5860865$1a0b0320@cox.net>
References: <56CB737D.1020403@polarismail.net>
	<20160222211142.GD4913@merlins.org>
	<20160222211845.GA14504@carfax.org.uk>
	<pan$a88ba$a1bf6bdd$c5860865$1a0b0320@cox.net>
Date: Thu, 25 Feb 2016 03:07:12 +0100
Message-ID: <CAPmG0jYQgWcv1cGS5ZPBXj819OTU97tVzZ+KxRg1sQsCpy+jCQ@mail.gmail.com>
Subject: Re: Fun BTRFS Stuff:
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 23, 2016 at 1:19 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Hugo Mills posted on Mon, 22 Feb 2016 21:18:45 +0000 as excerpted:
>
>> On Mon, Feb 22, 2016 at 01:11:42PM -0800, Marc MERLIN wrote:
>>> On Mon, Feb 22, 2016 at 02:45:49PM -0600, Terrance Harris wrote:
>>> > Hello,
>>> >
>>> > I'm a btrfs novice, but i've been using it for a few years now on
>>> > openSUSE Tumblweed.
>>>
>>> Howdy.
>>>
>>> First, please use the linux-btrfs@vger.kernel.org mailing list
>>>
>>> > Is there a way to convert snaBpshots into mountable files using btrfs
>>> > send?
>>>
>>> I am not sure I'm parsing your question.
>>> btrfs send/receive copy read only snapshots between 2 btrfs volumes
>>>
>>> If you mean using a non differential btrfs send to a file, and then
>>> using that file to act as if it were a filesystem you can read data
>>> from, I don't believe this is easily possible currently (it's possible,
>>> just no tool exists to do that). You're supposed to send it to btrfs
>>> receive, have it saved on a filesystem, and then use that.
>>
>>    It's not really possible with any degree of sanity. There's no
>> indexing in the send stream, so read acesses would have to scan the
>> whole file every time.
>>
>>    If you want to read the contents of a send stream in an order other
>> than the (arbitrary) one it's sent in, you need to replay it on a
>> filesystem with receive.
>
> In that way, btrfs send reminds me very much of the old tape-archive
> backup method.  In general, they were serialized copies of whatever they
> were archiving as well, intended primarily to be replayed as a whole onto
> a new filesystem, after which individual files could be accessed from the
> filesystem, not directly from the tape archive.  Altho with indexing
> files could be read-back/restored directly from tape, neither the format
> nor the media was really designed for it.
>
> I've not seen anyone else explicitly list the following as a practical
> btrfs send/receive backup strategy, but it does rather directly follow
> from the STDOUT/STDIN usage of the tools as practical, at least in
> theory.  My primary worry would be the general one of btrfs maturity,
> that it and the tools including btrfs send and receive are still
> stabilizing and maturing, with occasional bugs being found, and the
> following strategy won't find the receive bugs until restore time, at
> which point you might be depending on it working, so the strategy is
> really only appropriate once btrfs has settled down and matured somewhat
> more.
>
> So here's the idea.
>
> 1) Btrfs send directly to files on some other filesystem, perhaps xfs,
> intended to be used with larger files.  This can either be non-
> incremental, or (much like full and incremental tape backups) initial
> full, plus incremental sends.

I had not thought of the tape-archive method, interesting :)
I am using this more or less, although not fully automated. It looks like:

btrfs send -p snap_base snap_last | tee
/path-on-non-btrfs-fs/snap_base..snap_last.btrfs | btrfs receive
/path-on-btrfs-fs/

The key thing is to keep diff as small as possible to that I can
transport them over ~1 Mbps internet. But sometime the diff is huge,
for example when an upgrade of an OS in a VM has been done. So then I
carry the snap_last.btrfs 'by hand'.

If you mean sort of :  xfs receive /path-on-xfs-fs/  for the last step
in the commadline pipe
then this 'xfs receive'  implementation would face quite some
challenges I think, but not impossible I think

> 2) Store the backups as those send files, much like tape backup
> archives.  One option would be to do the initial full send, and then
> incremental sends as new files, until the multi-TB drive containing the
> backups is full, at which point replace it and start with a new full send
> to the fresh xfs or whatever on the new drive.

The issue here is that at the point you do a new full backup, you will
need more than double the space of the original in order to still have
a valid backup all the time. If it is backing up 'small SSD' to 'big
HDD', then not such an issue

>
> 3) When a restore is needed, then and only then, play back those backups
> to a newly created btrfs using btrfs receive.  If the above initial full
> plus incrementals until the backup media is full strategy is used, the
> incrementals can be played back against the initial full, just as the
> send was originally done.

Yes indeed. My motivation for this method was/is that unpacking (so
doing the  btrfs receive ) takes time if is is a huge number of small
files on a HDD

> Seems to me this should work fine, except as I said, that receive errors
> would only be caught at the time receive is actually run, which would be
> on restore.  But as most of those errors tend to be due to incremental
> bugs, doing full sends all the time would eliminate them, at the cost of
> much higher space usage over time, of course.  And if incrementals /are/
> done, with any luck, replay won't be for quite some time and thus using a
> much newer and hopefully more mature btrfs receive, with fewer bugs due
> to the bugs caught in the intervening time.  Additionally, with any luck,
> several generations of full backup plus incrementals will have been done
> before the need to replay even one set, thus sparing the need to reply
> the intervening sets entirely.

On the other hand, not replaying them makes it that they cannot be
used for a lower performance backup or clone server and there is no
way to check the actual state.  And there could also be silent send
errors.
If you do playback immediately, creating a writable snapshot on master
and clone(s) sides allows online checking potential diffs (rsync -c )
and copying the differences.
Using   btrfs sub find-new , I once then discovered some 100 MB
difference in a multi-TB data set. It were only 2 OS/VM image files,
on different clones. It probably has happened sometime early 2015, but
quite unsure, so not sure which kernel/tools.

> It's an interesting strategy to consider, particularly for long-term
> backups, to say Amazon Glacier for instance, where immediate retrieval
> and/or retrieval of individual files isn't envisioned.  Obviously for
> glacier or similar storage, an intermediate encryption step could be
> added, with encryption to whatever strength deemed appropriate, if
> considered necessary to thwart the NSA and similar nation-level advanced-
> persistent-threats on cloud-hosted storage.
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
