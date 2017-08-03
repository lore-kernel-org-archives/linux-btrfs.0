Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.55]:44332 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdHCSJD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Aug 2017 14:09:03 -0400
Reply-To: waxhead@dirtcellar.net
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>, linux-btrfs@vger.kernel.org
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
From: waxhead <waxhead@dirtcellar.net>
Message-ID: <fb2cf0a6-12b2-9356-657a-ffd58b375c75@dirtcellar.net>
Date: Thu, 3 Aug 2017 20:08:59 +0200
MIME-Version: 1.0
In-Reply-To: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide wrote:
> The title seems alarmist to me - and I suspect it is going to be 
> misconstrued. :-/
>
> From the release notes at 
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/7.4_Release_Notes/chap-Red_Hat_Enterprise_Linux-7.4_Release_Notes-Deprecated_Functionality.html
>
> "Btrfs has been deprecated
>
> The Btrfs file system has been in Technology Preview state since the 
> initial release of Red Hat Enterprise Linux 6. Red Hat will not be 
> moving Btrfs to a fully supported feature and it will be removed in a 
> future major release of Red Hat Enterprise Linux.
>
> The Btrfs file system did receive numerous updates from the upstream 
> in Red Hat Enterprise Linux 7.4 and will remain available in the Red 
> Hat Enterprise Linux 7 series. However, this is the last planned 
> update to this feature.
>
> Red Hat will continue to invest in future technologies to address the 
> use cases of our customers, specifically those related to snapshots, 
> compression, NVRAM, and ease of use. We encourage feedback through 
> your Red Hat representative on features and requirements you have for 
> file systems and storage technology."
>
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
First of all I am not a BTRFS dev, but I use it for various projects and 
have high hopes for what it can become.

Now, the fact that Red Hat depreciate BTRFS does not mean that BTRFS is 
depreciated. It not removed from the kernel and so far BTRFS offers 
features that other filesystems don't have. ZFS is something that people 
brag about all the time as a viable alternative, but for me it seems to 
be a pain to manage properly. E.g. grow, add/remove devices, shrink 
etc... good luck doing that right!

BTRFS biggest problem is not that there are some bits and pieces that 
are thoroughly screwed up (raid5/6 (which just got some fixes by the 
way)), but  the fact that the documentation is rather dated.

There is a simple status page here 
https://btrfs.wiki.kernel.org/index.php/Status

As others have pointed out already the explanations on the status page 
is not exactly good. For example compression (that was also mentioned) 
is as of writing this marked as 'Mostly ok'  '(needs verification and 
source) - auto repair and compression may crash'

Now, I am aware that many use compression without trouble. I am not sure 
how many that has compression with disk issues and don't have trouble , 
but I would at least expect to see more people yelling on the mailing 
list if that where the case. The problem here is that this message is 
rather scary and certainly does NOT sound like 'mostly ok' for most people.

What exactly needs verification and source? the mostly ok statement or 
something else?! A more detailed explanation would be required here to 
avoid scaring people away.

Same thing with the trim feature that is marked OK . It clearly says 
that is has performance implications. It is marked OK so one would 
expect it to not cause the filesystem to fail, but if the performance 
becomes so slow that the filesystem gets practically unusable it is of 
course not "OK". The relevant information is missing for people to make 
a decent choice and I certainly don't know how serious these performance 
implications are, if they are at all relevant...

Most people interested in BTRFS are probably a bit more paranoid and 
concerned about their data than the average computer user. What people 
tend to forget is that other filesystems either have NO redundancy, 
auto-repair and other fancy features that BTRFS have. So for the 
compression example above... if you run compressed files on ext4 and 
your disk gets some corruption you are in a no better state than what 
you would be with btrfs either (in fact probably worse). Also nothing is 
stopping you from putting btrfs DUP on a mdadm raid5 or 6 which mean you 
should be VERY safe.

Simple documentation is the key so HERE ARE MY DEMANDS!!!..... ehhh.... 
so here is what I think should be done:

1. The documentation needs to either be improved (or old non-relevant 
stuff simply removed / archived somewhere)
2. The status page MUST always be up to date for the latest kernel 
release (It's ok so far , let's hope nobody sleeps here)
3. Proper explanations must be given so the layman and reasonably 
technical people understand the risks / issues for non-ok stuff.
4. There should be links to roadmaps for each feature on the status page 
that clearly stats what is being worked on for the NEXT kernel release





