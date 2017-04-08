Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:51282 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751747AbdDHLfU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Apr 2017 07:35:20 -0400
Subject: Re: btrfs filesystem keeps allocating new chunks for no apparent
 reason
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <572D0C8B.8010404@mendix.com>
 <89a684c7-364e-f409-5348-bc0077fd438c@cn.fujitsu.com>
 <5b642448-951e-5b5e-1343-0299a950089c@mendix.com>
 <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
Cc: Josef Bacik <jbacik@fb.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <a3f590f3-80ed-fc7b-865e-aa730caed0be@mendix.com>
Date: Sat, 8 Apr 2017 13:35:19 +0200
MIME-Version: 1.0
In-Reply-To: <51778c0f-2720-1c2d-aba2-e22e5f4d3a3a@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2017 01:16 PM, Hans van Kranenburg wrote:
> On 04/07/2017 11:25 PM, Hans van Kranenburg wrote:
>> Ok, I'm going to revive a year old mail thread here with interesting new
>> info:
>>
>> [...]
>>
>> Now, another surprise:
>>
>> From the exact moment I did mount -o remount,nossd on this filesystem,
>> the problem vanished.
>>
>> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-07-ichiban-munin-nossd.png
>>
>> I don't have a new video yet, but I'll set up a cron tonight and post it
>> later.
>>
>> I'm going to send another mail specifically about the nossd/ssd
>> behaviour and other things I found out last week, but that'll probably
>> be tomorrow.
> 
> Well, there it is:
> 
> https://syrinx.knorrie.org/~knorrie/btrfs/keep/2017-04-08-ichiban-walk-nossd.mp4
> 
> Amazing... :) I'll update the file later with extra frames.

By the way,

1. For the log files in /var/log... logrotate behaves as a defrag tool
of course. The small free space gaps left behind when scraping the
current log file together and rewriting it as 1 big gzipped file can be
reused throughout the next day or whatever interval by the slow writes
again.

2. For the /var/spool/postfix... small files come and go, and that's
fine now.

3. For the mailman mbox files, which get appended all the time... They
can either stay where they are, having some more extents scattered
around, or, an entry in the monthly cron to point defrag at the files of
last month (which will never change again) will solve that efficiently.

All of that doesn't sound like abnormal things to do when punishing the
filesystem with a 'slow small write' workload.

I'm happy to be able to keep this thing on btrfs. When moving all the
mailman stuff over from a previous VM, I first made it ext4 again, then
immediately ended up with no inodes left (of course!) while copying the
mailman archive, and then thought .. arg .. mkfs.btrfs, yay, unlimited
inodes! :) I was almost at the point of converting it back to ext4 after
all because of the exploding unused free space problems, but now that's
prevented just in time. :D

Moo,
-- 
Hans van Kranenburg
