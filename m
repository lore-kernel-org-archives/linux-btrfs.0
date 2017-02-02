Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:34448 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751488AbdBBMt5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Feb 2017 07:49:57 -0500
Received: by mail-it0-f68.google.com with SMTP id o185so5661928itb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Feb 2017 04:49:57 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id l31sm826689iod.17.2017.02.02.04.49.54
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Feb 2017 04:49:55 -0800 (PST)
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
To: linux-btrfs@vger.kernel.org
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
 <07bba687-64c3-6713-6f6a-c8da183cbd3d@gmail.com>
 <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
 <20170201115530.l2ce5afcqld2kzi4@angband.pl>
 <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
Date: Thu, 2 Feb 2017 07:49:50 -0500
MIME-Version: 1.0
In-Reply-To: <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-01 17:48, Duncan wrote:
> Adam Borowski posted on Wed, 01 Feb 2017 12:55:30 +0100 as excerpted:
>
>> On Wed, Feb 01, 2017 at 05:23:16AM +0000, Duncan wrote:
>>> Hans Deragon posted on Tue, 31 Jan 2017 21:51:22 -0500 as excerpted:
>>>> But the current scenario makes it difficult for me to put redundancy
>>>> back into service!  How much time did I waited until I find the
>>>> mailing list, subscribe to it, post my email and get an answer?
>>>> Wouldn't it be better if the user could actually add the disk at
>>>> anytime, mostly ASAP?
>>>>
>>>> And to fix this, I have to learn how to patch and compile the kernel.
>>>> I have not done this since the beginning of the century.  More
>>>> delays,
>>>> more risk added to the system (what if I compile the kernel with the
>>>> wrong parameters?).
>>>
>>> The patch fixing the problem and making return from degraded not the
>>> one-
>>> shot thing it tends to be now will eventually be merged
>>
>> Not anything like the one I posted to this thread -- this one merely
>> removes a check that can't handle this particular (common) case of an
>> otherwise healthy RAID that lost one device then was mounted degraded
>> twice.  We need instead a better check, one that sees whether every
>> block group is present.
>>
>> This can be done quite easily, as as far as I know, the list of block
>> group is at that moment fully present in memory, but someone actually
>> has to code that, and I for one don't know btrfs internals (yet?).
>
> I didn't mention it because you spared me the trouble with your hack-
> patch that did the current job, but FWIW, there's actually a patch that
> does per-chunk testing as you indicate, but it got merged into a longer
> running feature-add project (hot-spares, IIRC), and thus isn't likely to
> be mainline-merged until that project is merged.
>
> But who knows when that might be?  Could be years before it is considered
> ready.
>
> Meanwhile, perhaps it's simply because I'm not a dev and am not
> appreciating the complexities of some detail or other, but as
> demonstrated by the people who have local-merged that patch to get out of
> just this sort of jam, as well as the continuing saga of more and more
> people appearing here with the same problem, it could be an arguably high
> priority fix on its own, and should have been reviewed and ultimately
> mainline-merged on its own merits, instead of being stuck in someone's
> feature-add project queue for potentially years, while more and more
> people who could have definitely used it have to either suffer without it
> or go and find and local-merge it themselves.  Even if this feature is
> critical to the longer term feature, merge of this little one now would
> make the final patch set for the longer term feature that much smaller.
Agreed, it should have been mainlined.  I have no issue with the 
hot-spare patches depending on it, but it's a severe bug.
>
> But that's a btrfs-using sysadmin's viewpoint, not a developer viewpoint,
> and it's the developer's doing the work, so they get to define when and
> how it gets merged, and us non-devs must either simply live with it, or
> if the circumstances allow, fund some dev to have our specific interests
> as their priority and take care of it for us.
I don't care in this case if I draw some flak from the developers, but 
this particular developer viewpoint is wrong.  If this was a commercial 
software product, the person responsible would at least be facing some 
serious reprimand, and depending on the company, possibly would be out 
of a job.  This is a severe bug that makes a not all that uncommon 
(albeit bad) use case fail completely.  The fix had no dependencies 
itself and
>
> Meanwhile, perhaps I should have bookmarked that patch at least as it
> appeared on-list, but I didn't, so while I know it exists, I too would
> have to go looking to actually find it, should I end up needing it.  In
> my defense, I /thought/ the immediate benefit was obvious enough that it
> would be mainline-merged by now, not hoovered-up into some long-term
> project with no real hint as to /when/ it might be merged.  Oh, well...
I think (although I'm not sure about it) that this:
http://www.spinics.net/lists/linux-btrfs/msg47283.html
is the first posting of the patch series.
