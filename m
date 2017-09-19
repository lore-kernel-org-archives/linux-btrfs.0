Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:60340 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdISEki (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 00:40:38 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1duAKi-0002JI-B8
        for linux-btrfs@vger.kernel.org; Tue, 19 Sep 2017 06:40:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: difference between -c and -p for send-receive?
Date: Tue, 19 Sep 2017 04:40:22 +0000 (UTC)
Message-ID: <pan$20f4$7c35f3ca$81a749bf$c4b2102e@cox.net>
References: <CAH=dxU5NfenfKfsuXuZ8uBYKBb5a0VOEqan6taAwZTT0oM8xcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave posted on Mon, 18 Sep 2017 20:41:45 -0400 as excerpted:

>> Well, I do not immediately see why -c must imply incremental send. We
>> want to reduce amount of data that is transferred, so reuse data from
>> existing snapshots, but it is really orthogonal to whether we send full
>> subvolume or just changes since another snapshot.
>>
>>
> Starting months ago when I began using btrfs serious, I have been
> reading,
> rereading and trying to understand this:
> 
> FAQ - btrfs Wiki
> https://btrfs.wiki.kernel.org/index.php/
FAQ#What_is_the_difference_between_-c_and_-p_in_send.3F
> 
> The comment above suddenly gives me another clue...
> 
> However, I still don't understand terms like "clone range ioctl",
> although I can guess it is something like a hard link.
> 
> Would it be correct to say the following?
> 
> 1. "-c" causes (appropriate) files in the newly transferred snapshot to
> be "hard linked" to existing files in another snapshot on the
> destination.

Technically, it's not a hard link but a reflink.  However, it's a 
reasonably accurate analogy for understanding the process, it's just at a 
different layer.

> Doesn't "-p" do something equivalent though?

Yes.  See below for the difference.

> 2. The -c and -p options can be used together or individually.

Yes.

> Questions:
> 
> If "-c" "will send all of the metadata of @B.1, but will leave out the
> data for @B.1/bigfile, because it's already in the backups filesystem,
> and can be reflinked from there" what will -p do in contrast?
> 
> Will "-p" not send all the metadata?
> 
> Will "-p" also leave out the data for @B.1/bigfile, when it's also
> already in the backups?

-c is less strict than -p, and sends more metadata over the wire as a 
result, but where the data is the same (reflink points to the same 
extent), it won't be sent in either case.  See below.

> What would make me choose one of these options over the other? I still
> struggle to see the difference.

What -p does is tell send that the named snapshot is a snapshot of an 
earlier state of the snapshot being sent, and that said earlier-state 
snapshot exists on both the send and receive end, so only the changes 
(both data and metadata) from the earlier snapshot must be sent.

Put a different way, the snapshot being sent is the parent, plus any 
changes since then, so to recreate the new snapshot, only the operations 
needed to update the state from the previous to the new state must be 
sent, and done by receive on the other end.

-c is less strict than -p.  It doesn't consider the named snapshot to be 
an earlier state of the snapshot being sent, but simply says that the two 
may have some data in common, as defined by reflinks to the same shared 
extents.

So -c will send more over the wire, in particular, it'll send much more 
metadata, I believe (being no dev or expert, just a list regular) 
essentially all metadata, because no claim as to the relationship of the 
metadata between the snapshot being sent and the clone is assumed.  But 
it can and does still assume that any extents reflinked in common can be 
simply sent by reference, instead of sending the literal data in that 
extent, because -c says the other end already has the snapshot named as a 
clone and that it can simply reflink it there, as well.

The wording of the manpage description for -c suggests that it picks one 
(and only one if there's more than one) -c clone and considers it a 
parent, which would allow it to shortcut sending the metadata in common 
for it as well, but not being a dev, I haven't looked at the code to be 
sure, and in any case, there can be only one parent, so it can do it for 
only one clone, even if there's more than one -c snapshot supplied.


So -p is primarily for the case where the named snapshot is an earlier 
state of the one being sent, and should be much more efficient than -c in 
that case.  However, the less strict -c should also work, and if the 
wording of the manpage can be believed, a single named -c snapshot will 
be treated as -p anyway.  But -c can also be used for snapshots that 
aren't related with one being an earlier state of the other, where 
there's simply some reflinks in common, perhaps due to dedup.  It should 
still result in the data with the common reflinks being only sent by 
reference, but much more metadata will be sent, and if there's not a lot 
of reflinks in common, it's likely to require enough additional 
processing that the relatively trivial amount of common reflinked data it 
might save may not be worth it, compared to simply sending a full non-
incremental snapshot.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

