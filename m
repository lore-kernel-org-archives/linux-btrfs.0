Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56712 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752330AbdHPSJT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 14:09:19 -0400
Date: Wed, 16 Aug 2017 20:07:55 +0200
From: David Sterba <dsterba@suse.cz>
To: waxhead <waxhead@dirtcellar.net>
Cc: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
Message-ID: <20170816180755.GK2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 03, 2017 at 08:08:59PM +0200, waxhead wrote:
> BTRFS biggest problem is not that there are some bits and pieces that 
> are thoroughly screwed up (raid5/6 (which just got some fixes by the 
> way)), but  the fact that the documentation is rather dated.
> 
> There is a simple status page here 
> https://btrfs.wiki.kernel.org/index.php/Status
> 
> As others have pointed out already the explanations on the status page 
> is not exactly good. For example compression (that was also mentioned) 
> is as of writing this marked as 'Mostly ok'  '(needs verification and 
> source) - auto repair and compression may crash'
> 
> Now, I am aware that many use compression without trouble. I am not sure 
> how many that has compression with disk issues and don't have trouble , 
> but I would at least expect to see more people yelling on the mailing 
> list if that where the case. The problem here is that this message is 
> rather scary and certainly does NOT sound like 'mostly ok' for most people.
> 
> What exactly needs verification and source? the mostly ok statement or 
> something else?! A more detailed explanation would be required here to 
> avoid scaring people away.
> 
> Same thing with the trim feature that is marked OK . It clearly says 
> that is has performance implications. It is marked OK so one would 
> expect it to not cause the filesystem to fail, but if the performance 
> becomes so slow that the filesystem gets practically unusable it is of 
> course not "OK". The relevant information is missing for people to make 
> a decent choice and I certainly don't know how serious these performance 
> implications are, if they are at all relevant...

I'll try to restructure the page so it reflects status of the features
from more aspects, like overall/performance/"known bad scenarios". The
in-row notes are proably bad idea as they are short on details, the
section under table will be better for that.

> Most people interested in BTRFS are probably a bit more paranoid and 
> concerned about their data than the average computer user. What people 
> tend to forget is that other filesystems either have NO redundancy, 
> auto-repair and other fancy features that BTRFS have. So for the 
> compression example above... if you run compressed files on ext4 and 
> your disk gets some corruption you are in a no better state than what 
> you would be with btrfs either (in fact probably worse). Also nothing is 
> stopping you from putting btrfs DUP on a mdadm raid5 or 6 which mean you 
> should be VERY safe.
> 
> Simple documentation is the key so HERE ARE MY DEMANDS!!!..... ehhh.... 
> so here is what I think should be done:
> 
> 1. The documentation needs to either be improved (or old non-relevant 
> stuff simply removed / archived somewhere)

Agreed, this happens from time.

> 2. The status page MUST always be up to date for the latest kernel 
> release (It's ok so far , let's hope nobody sleeps here)

I'm watching over the page. It's been locked from edits so there's a
mandatory review of the new contents, the update process is documented
on the page.

> 3. Proper explanations must be given so the layman and reasonably 
> technical people understand the risks / issues for non-ok stuff.

This can be hard, the audience are both technical and non-technical
users. The page is supposed to give quick overview, the more detailed
information is either in the notes or on separate pages linked from
there. I believe this structure should be able to cover what you need,
but the acutal contents hasn't been written and there are not enough
people willing/capable of writing it.

> 4. There should be links to roadmaps for each feature on the status page 
> that clearly stats what is being worked on for the NEXT kernel release

We've tried something like that in the past, the page got out of sync
with reality over time and was deleted.
