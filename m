Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38147 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbIWIlW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 04:41:22 -0400
Received: by igxx6 with SMTP id x6so24248102igx.1
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 01:41:21 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20150922200435.GL5918@carfax.org.uk>
References: <20150922195219.GA23903@lo.psyced.org>
	<20150922200435.GL5918@carfax.org.uk>
Date: Wed, 23 Sep 2015 09:41:21 +0100
Message-ID: <CAL3q7H7F2k3WYptw5+RQa8_DvmqWRM4Q-tDwHQOHY+FH7qtCVQ@mail.gmail.com>
Subject: Re: btrfs receive bigger than original snapshot?
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>,
        carlo von lynX <lynX@time.to.get.psyced.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 9:04 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Sep 22, 2015 at 09:52:19PM +0200, carlo von lynX wrote:
>> Hello, it's me again. This time I searched the web to make sure
>> I'm not making another beginner's mistake. I'm still not on the
>> list, so please keep me in cc: on replies.
>>
>> I have optimized a btrfs subvolume with a script* that reflinks
>> all files with identical contents, then I did a read-only snap
>> and fed it to send/receive. The bad news: on the receiving
>> side the same snapshot grew from 5.5G to 7.1G.

So that's likely because you have files with holes. Right now when a
hole exists in a file the send stream will contain an instruction to
write zeroes into the file instead of a punch hole instruction. So
imagine a file with a 1Gb hole, the send stream makes the receiver
write 1Gb of zeroes, wasting a lot of space (and time).

There's an over an year old patchset to add hole punching support to
the send stream and a few other features, but it was never picked by
Josef at the time (when he was maintaining the integration branch) nor
Chris.

>
>    That's something I'd definitely expect it to be able to do. If it's
> not doing it, I'd say there's something wrong. cc'ing Filipe, who is,
> I think, currently the local expert on send/receive.
>
>> I assume send/receive does not support one of the coolest
>> btrfs features ever.. reflinks. Didn't find any mention on this
>> on https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
>> or other pages. Is there any documentation that would explain
>> to me why this has to be or is it just a missing feature that
>> someone someday may find the time to add?
>>
>> Generally I find it odd that btrfs receive would not recreate
>> an identical clone of the original snapshot, that would also
>> allow me to continue working on a backup hard disk, then merge
>> the changes back to the main disk. Instead I have to decide
>> which device contains the master copy for all times and never
>> make rw snapshots elsewhere. What if the master disk dies?
>> Then I can turn a backup into the new master but I will have
>> to re-bootstrap all other backups as they will not accept the
>> non-identical parent snapshot.
>
>    That's a known drawback, and one that's been discussed on this list
> already. It's fixable (within some limits), but requires a change to
> the send stream format. (See my analysis below).
>
>> Apparently I'm not the only one that thought this to be a
>> defect rather than a design choice:
>>     http://www.spinics.net/lists/linux-btrfs/msg45175.html
>>
>> This actually confused me (in particular the absence of responses
>> to that mail), that's why I have btrfs-progs 4.0 installed...
>> but in the meantime I figured out that I expected send/receive
>> to be bidirectional. So my question in this case.. is there a
>> higher reasoning for the inexactness of send/receive transfers?
>
>    It's about tracking enough metadata to be sure that the send (or
> the receive) is actually feasible. See
> http://www.spinics.net/lists/linux-btrfs/msg44089.html for my analysis
> of the problem, and (theoretical) suggestions for what the solution
> should look like.
>
>> And another classic: since the output size of the snapshot copy
>> is unpredictable, running out of disk space can be frequent.
>> Wouldn't it be cool if receive could resume rather than restarting
>> from scratch?
>
>    Resuming is a bit tricky -- how do you know where to resume from?
> Bear in mind that send simply writes its results to stdout, so it has
> no knowledge of anything on the receiving side. In fact, the receiving
> side may not even exist at the point that the send stream is created.
>
>    Hugo.
>
>> But maybe I still got it all wrong in my head. If these things
>> are FAQs, please add them to the FAQ document. In particular some
>> criteria to decide when rsync is actually a more suitable tool
>> over send/receive, which apparently under some circumstances is
>> the case. In some other cases, git can be the better suited tool.
>>
>> Still I am very glad that you created a new alternative for data
>> organization between the extremes of reckless rsync and overly
>> accurate git. It's just a steep learning mountain.
>>
>>
>> *) I used fdupes' output ran through a perl script that calls
>>   "cp --reflink" for each match. Would "bedup" or "duperemove"
>>  do a better job? bedup looks like a better long-term solution.
>>
>>
>
> --
> Hugo Mills             | Great oxymorons of the world, no. 3:
> hugo@... carfax.org.uk | Military Intelligence
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
