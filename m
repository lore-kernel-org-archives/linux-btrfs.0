Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37516 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750940AbcIMU2k (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Sep 2016 16:28:40 -0400
Received: by mail-wm0-f41.google.com with SMTP id c131so132747849wmh.0
        for <linux-btrfs@vger.kernel.org>; Tue, 13 Sep 2016 13:28:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160909140059.GT16983@twin.jikos.cz>
References: <CAJF-kYmnBt6yRLJ+R3HdJ03oqp_ptwXpat40vXoD_b=MUvJZUw@mail.gmail.com>
 <20160909140059.GT16983@twin.jikos.cz>
From: Lukas Lueg <lukas.lueg@gmail.com>
Date: Tue, 13 Sep 2016 22:28:18 +0200
Message-ID: <CAJF-kYnXjz_dg2eev3WUqg3=XTBX=W8e2qnLQKtpnC6cCHvR+Q@mail.gmail.com>
Subject: Re: State of the fuzzer
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've booted another instance with btrfs-progs checked out to 2b7c507
and collected some bugs which remained from the run before the current
one. The current run discovered what qgroups are just three days ago
and will spend some time on that. I've also added UBSAN- and
MSAN-logging to my setup and there were three bugs found so far (one
is already fixed). I will boot a third instance to run lowmem-mode
exclusively in the next few days.

There are 11 bugs open at the moment, all have a reproducing image
attached to them. The whole list is at

https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&component=btrfs&email1=lukas.lueg%40gmail.com&emailreporter1=1&emailtype1=exact&list_id=858441&query_format=advanced


2016-09-09 16:00 GMT+02:00 David Sterba <dsterba@suse.cz>:
> On Tue, Sep 06, 2016 at 10:32:28PM +0200, Lukas Lueg wrote:
>> I'm currently fuzzing rev 2076992 and things start to slowly, slowly
>> quiet down. We will probably run out of steam at the end of the week
>> when a total of (roughly) half a billion BTRFS-images have passed by.
>> I will switch revisions to current HEAD and restart the whole process
>> then. A few things:
>>
>> * There are a couple of crashes (mostly segfaults) I have not reported
>> yet. I'll report them if they show up again with the latest revision.
>
> Ok.
>
>> * The coverage-analysis shows assertion failures which are currently
>> silenced. An assertion failure is technically a worse disaster
>> successfully prevented, it still constitutes unexpected/unusable
>> behaviour, though. Do you want assertions to be enabled and images
>> triggering those assertions reported? This is basically the same
>> conundrum as with BUG_ON and abort().
>
> Yes please. I'd like to turn most bugons/assertions into a normal
> failure report if it would make sense.
>
>> * A few endless loops entered into by btrfsck are currently
>> unmitigated (see bugs 155621, 155571, 155551 and 155151). It would be
>> nice if those had been taken care of by next week if possible.
>
> Two of them are fixed, the other two need more work, updating all
> callers of read_node_slot and the callchain. So you may still see that
> kind of looping in more images. I don't have an ETA for the fix, I won't
> be available during the next week.
>
> At the moment, the initial sanity checks should catch most of the
> corrupted values, so I'm expecting that you'll see different classes of
> problems in the next rounds.
>
> The testsuite now contains all images that you reported and we have a
> fix in git. There are more utilities run on the images, there may be
> more problems for us to fix.
