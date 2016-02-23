Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33603 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbcBWATe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 19:19:34 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aY0hQ-00050A-Jk
	for linux-btrfs@vger.kernel.org; Tue, 23 Feb 2016 01:19:32 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 01:19:32 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Feb 2016 01:19:32 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fun BTRFS Stuff:
Date: Tue, 23 Feb 2016 00:19:27 +0000 (UTC)
Message-ID: <pan$a88ba$a1bf6bdd$c5860865$1a0b0320@cox.net>
References: <56CB737D.1020403@polarismail.net>
	<20160222211142.GD4913@merlins.org> <20160222211845.GA14504@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 22 Feb 2016 21:18:45 +0000 as excerpted:

> On Mon, Feb 22, 2016 at 01:11:42PM -0800, Marc MERLIN wrote:
>> On Mon, Feb 22, 2016 at 02:45:49PM -0600, Terrance Harris wrote:
>> > Hello,
>> > 
>> > I'm a btrfs novice, but i've been using it for a few years now on
>> > openSUSE Tumblweed.
>> 
>> Howdy.
>> 
>> First, please use the linux-btrfs@vger.kernel.org mailing list
>> 
>> > Is there a way to convert snaBpshots into mountable files using btrfs
>> > send?
>>  
>> I am not sure I'm parsing your question.
>> btrfs send/receive copy read only snapshots between 2 btrfs volumes
>> 
>> If you mean using a non differential btrfs send to a file, and then
>> using that file to act as if it were a filesystem you can read data
>> from, I don't believe this is easily possible currently (it's possible,
>> just no tool exists to do that). You're supposed to send it to btrfs
>> receive, have it saved on a filesystem, and then use that.
> 
>    It's not really possible with any degree of sanity. There's no
> indexing in the send stream, so read acesses would have to scan the
> whole file every time.
> 
>    If you want to read the contents of a send stream in an order other
> than the (arbitrary) one it's sent in, you need to replay it on a
> filesystem with receive.

In that way, btrfs send reminds me very much of the old tape-archive 
backup method.  In general, they were serialized copies of whatever they 
were archiving as well, intended primarily to be replayed as a whole onto 
a new filesystem, after which individual files could be accessed from the 
filesystem, not directly from the tape archive.  Altho with indexing 
files could be read-back/restored directly from tape, neither the format 
nor the media was really designed for it.

I've not seen anyone else explicitly list the following as a practical 
btrfs send/receive backup strategy, but it does rather directly follow 
from the STDOUT/STDIN usage of the tools as practical, at least in 
theory.  My primary worry would be the general one of btrfs maturity, 
that it and the tools including btrfs send and receive are still 
stabilizing and maturing, with occasional bugs being found, and the 
following strategy won't find the receive bugs until restore time, at 
which point you might be depending on it working, so the strategy is 
really only appropriate once btrfs has settled down and matured somewhat 
more.

So here's the idea.  

1) Btrfs send directly to files on some other filesystem, perhaps xfs, 
intended to be used with larger files.  This can either be non-
incremental, or (much like full and incremental tape backups) initial 
full, plus incremental sends.

2) Store the backups as those send files, much like tape backup 
archives.  One option would be to do the initial full send, and then 
incremental sends as new files, until the multi-TB drive containing the 
backups is full, at which point replace it and start with a new full send 
to the fresh xfs or whatever on the new drive.

3) When a restore is needed, then and only then, play back those backups 
to a newly created btrfs using btrfs receive.  If the above initial full 
plus incrementals until the backup media is full strategy is used, the 
incrementals can be played back against the initial full, just as the 
send was originally done.

Seems to me this should work fine, except as I said, that receive errors 
would only be caught at the time receive is actually run, which would be 
on restore.  But as most of those errors tend to be due to incremental 
bugs, doing full sends all the time would eliminate them, at the cost of 
much higher space usage over time, of course.  And if incrementals /are/ 
done, with any luck, replay won't be for quite some time and thus using a 
much newer and hopefully more mature btrfs receive, with fewer bugs due 
to the bugs caught in the intervening time.  Additionally, with any luck, 
several generations of full backup plus incrementals will have been done 
before the need to replay even one set, thus sparing the need to reply 
the intervening sets entirely.

It's an interesting strategy to consider, particularly for long-term 
backups, to say Amazon Glacier for instance, where immediate retrieval 
and/or retrieval of individual files isn't envisioned.  Obviously for 
glacier or similar storage, an intermediate encryption step could be 
added, with encryption to whatever strength deemed appropriate, if 
considered necessary to thwart the NSA and similar nation-level advanced-
persistent-threats on cloud-hosted storage.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

