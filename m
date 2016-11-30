Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:43991 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758022AbcK3QJK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Nov 2016 11:09:10 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: Wilson Meier <wilson.meier@gmail.com>
Cc: Duncan <1i5t5.duncan@cox.net>, <linux-btrfs@vger.kernel.org>
Subject: Re: Convert from RAID 5 to 10
Date: Wed, 30 Nov 2016 17:09:07 +0100
MIME-Version: 1.0
Message-ID: <c7b2b4e8-ccc0-4b00-858f-d634b37612a9@linuxsystems.it>
In-Reply-To: <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
References: <10bbbf97-7f43-c972-a832-4a8cf054d5e5@xgm.de>
 <fce2df8b-0775-1ecf-c08d-960018822c20@googlemail.com>
 <20161130103808.74e5ae95@natsu> <3713990.abIjkpnqyF@merkaba>
 <73d0d10c-7a06-b282-ee76-4512aaed5723@googlemail.com>
 <pan$7a75f$e48f1aa5$204a0630$9d1c1cc4@cox.net>
 <b13f13a4-639d-d460-7642-c8f8fe646832@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I completely agree, the whole wiki status is simply *FRUSTRATING*.

Niccolò Belli

On mercoledì 30 novembre 2016 14:12:36 CET, Wilson Meier wrote:
> Am 30/11/16 um 11:41 schrieb Duncan:
>> Wilson Meier posted on Wed, 30 Nov 2016 09:35:36 +0100 as excerpted:
>>  ...
> Hi Duncan,
>
> i understand your arguments but cannot fully agree.
> First of all, i'm not sticking with old stale versions of whatever as i
> try to keep my system up2date.
> My kernel is 4.8.4 (Gentoo) and btrfs-progs is 4.8.4.
> That being said, i'm quite aware of the heavy development status of
> btrfs but pointing the finger on the users saying that they don't fully
> understand the status of btrfs without giving the information on the
> wiki is in my opinion not the right way. Heavy development doesn't mean
> that features marked as ok are "not" or "mostly" ok in the context of
> overall btrfs stability.
> There is no indication on the wiki that raid1 or every other raid
> (except for raid5/6) suffers from the problems stated in this thread.
> If there are know problems then the stability matrix should point them
> out or link to a corresponding wiki entry otherwise one has to assume
> that the features marked as "ok" are in fact "ok".
> And yes, the overall btrfs stability should be put on the wiki.
>
> Just to give you a quick overview of my history with btrfs.
> I migrated away from MD Raid and ext4 to btrfs raid6 because of its CoW
> and checksum features at a time as raid6 was not considered fully stable
> but also not as badly broken.
> After a few months i had a disk failure and the raid could not recover.
> I looked at the wiki an the mailing list and noticed that raid6 has been
> marked as badly broken :(
> I was quite happy to have a backup. So i asked on the btrfs IRC channel
> (the wiki had no relevant information) if raid10 is usable or suffers
> from the same problems. The summary was "Yes it is usable and has no
> known problems". So i migrated to raid10. Now i know that raid10 (marked
> as ok) has also problems with 2 disk failures in different stripes and
> can in fact lead to data loss.
> I thought, hmm ok, i'll split my data and use raid1 (marked as ok). And
> again the mailing list states that raid1 has also problems in case of
> recovery.
>
> It is really disappointing to not have this information in the wiki
> itself. This would have saved me, and i'm quite sure others too, a lot
> of time.
> Sorry for being a bit frustrated.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

