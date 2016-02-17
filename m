Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:35603 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933854AbcBQMQA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 07:16:00 -0500
Received: by mail-qk0-f172.google.com with SMTP id o6so4923913qkc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 04:15:59 -0800 (PST)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id q10sm370563qha.25.2016.02.17.04.15.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 17 Feb 2016 04:15:57 -0800 (PST)
Subject: Re: [Docs]? Only one Subvolume with DUP (or different parameters)?
To: linux-btrfs@vger.kernel.org
References: <56C377BB.9020101@knebb.de>
 <pan$17e03$37c598a8$93a246ff$ae65c0fd@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56C46465.4020402@gmail.com>
Date: Wed, 17 Feb 2016 07:15:33 -0500
MIME-Version: 1.0
In-Reply-To: <pan$17e03$37c598a8$93a246ff$ae65c0fd@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-16 23:49, Duncan wrote:
> Christian Völker posted on Tue, 16 Feb 2016 20:25:47 +0100 as excerpted:
>
>> sorry for the simple question and I assume every developer here laughs
>> about this question.
>>
>> Anyway:
>>
>> I have read loads of documents but did not find an answer for sure. Even
>> though I assume I am right.
>>
>> On a btrfs filesystem created; is it possible to have subvolumes with
>> data duplication and another subvolume without (resp. with just metadata
>> duplication)?
>>
>> I have some large filesystems currently with ext4 and I am thinking of
>> changing to btrfs. Some of the data is more important than others. So I
>> want to have data duplication on the important files (sorted in a mount
>> point) and without for the other subvolume.
>>
>> So I want to have the advantage of redundancy of important files
>> combined with the flexibility of the volume manager and shared disk
>> space.
>
> As Hugo mentions, that's not possible at this point, tho the plan is to
> make replication mode a per-subvolume or even per-file property at some
> still-future point.  Given the rate of progress, however, that future
> point is extremely likely to be at least two years out and could well be 5
> + years out -- IOW, it's nothing you could plan for at this point.
>
> However, it's quite possible to do multiple separate btrfs, with each one
> having its own replication mode.  That is, in fact, what I do here, tho
> in my case it's more to keep all my data eggs from being in the same
> filesystem basket, in case btrfs decides to eat a filesystem, than it is
> for different replication (most of mine are raid1 across partitions on
> two devices).  If the filesystem goes, being on a different subvolume
> from whatever triggered the problem isn't going to help much, while being
> on a different filesystem entirely, which might have been mounted
> read-only or not even mounted at all at the time, very likely will, and I
> prefer not having all my data eggs in the same filesystem basket,
> particularly when that filesystem basket is btrfs, which while
> stabilizing, isn't yet full stable and mature yet, even if it means a bit
> more hands-on administration than would simply shoving everything in the
> same basket and hoping the bottom doesn't drop out of it.
>
> Tho that might be just me...
>
It's not just you, I do so myself, and usually make the same 
recommendation to people who ask me about it.  This was in fact the 
usual recommendation on most old UNIX systems as well, although that was 
just as much because of small disks and a lack of logical volume 
management as it was about data safety.  The big difference these days 
is where the splits are made.  Traditional UNIX often had /var, /usr, 
/home, and / as separate filesystems, often with multiple /home 
filesystems on big systems.  Most modern Linux distributions can't 
handle /usr and /var being on separate filesystems from /, so people 
split things differently when the split things at all (the good 
installers usually provide options to easily do common splits like a 
separate /home, but most make assumptions about how you lay things out, 
this is part of the reason I prefer Gentoo, it lets you do things 
however you want as long as you can configure it yourself).  In my case 
for example, I split out stuff that's trivial to recreate (/usr/portage, 
/var/lib/layman, /usr/src), stuff that I don't want backed up for other 
reasons (I have a separate filesystem I use for local copies of public 
VCS repositories for example), and stuff that should just be on a 
separate filesystem regardless (either because it needs different 
replication, or because it needs to be more isolated from the rest of 
the system, back-end storage for the GlusterFS storage cluster I'm 
building being an excellent example).
