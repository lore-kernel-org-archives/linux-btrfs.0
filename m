Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:45942 "EHLO
        mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbdKOMwS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 07:52:18 -0500
Received: by mail-io0-f174.google.com with SMTP id z74so1436271iof.12
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Nov 2017 04:52:17 -0800 (PST)
Subject: Re: Tiered storage?
To: waxhead@dirtcellar.net, Roy Sigurd Karlsbakk <roy@karlsbakk.net>,
        linux-btrfs@vger.kernel.org
References: <2093578773.146320.1510707691482.JavaMail.zimbra@karlsbakk.net>
 <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <45d19817-ebf8-65ae-693f-2324ba637a67@gmail.com>
Date: Wed, 15 Nov 2017 07:52:13 -0500
MIME-Version: 1.0
In-Reply-To: <08cbefb3-43eb-8d76-1dd6-191e2709bdc7@dirtcellar.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-15 02:11, waxhead wrote:
> As a regular BTRFS user I can tell you that there is no such thing as 
> hot data tracking yet. Some people seem to use bcache together with 
> btrfs and come asking for help on the mailing list.
Bcache works fine recently.  It was only with older versions that there 
were issues.  dm-cache similarly works fine on recent versions.  In both 
cases though, you need to be sure you know what you're doing, otherwise 
you are liable to break things.
> 
> Raid5/6 have received a few fixes recently, and it *may* soon me worth 
> trying out raid5/6 for data, but keeping metadata in raid1/10 (I would 
> rather loose a file or two than the entire filesystem).
> I had plans to run some tests on this a while ago, but forgot about it.
> As call good citizens, remember to have good backups. Last time I tested 
> for Raid5/6 I ran into issues easily. For what it's worth - raid1/10 
> seems pretty rock solid as long as you have sufficient disks (hint: you 
> need more than two for raid1 if you want to stay safe)
Parity profiles (raid5 and raid6) still have issues, although there are 
fewer than there were, with most of the remaining issues surrounding 
recovery.  I would still recommend against it for production usage.

Simple replication (raid1) is pretty much rock solid as long as you keep 
on top of replacing failing hardware and aren't stupid enough to run the 
array degraded for any extended period of time (converting to a single 
device volume instead of leaving things with half a volume is vastly 
preferred for multiple reasons).

Striped replication (raid10) is generally fine, but you can get much 
better performance by running BTRFS with a raid1 profile on top of two 
MD/LVM/Hardware RAID0 volumes (BTRFS still doesn't do a very good job of 
parallelizing things).
> 
> As for dedupe there is (to my knowledge) nothing fully automatic yet. 
> You have to run a program to scan your filesystem but all the 
> deduplication is done in the kernel.
> duperemove works apparently quite well when I tested it, but there may 
> be some performance implications.
Correct, there is nothing automatic (and there are pretty significant 
arguments against doing automatic deduplication in most cases), but the 
off-line options (via the EXTENT_SAME ioctl) are reasonably reliable. 
Duperemove in particular does a good job, though it may take a long time 
for large data sets.

As far as performance, it's no worse than large numbers of snapshots. 
The issues arise from using very large numbers of reflinks.
> 
> Roy Sigurd Karlsbakk wrote:
>> Hi all
>>
>> I've been following this project on and off for quite a few years, and 
>> I wonder if anyone has looked into tiered storage on it. With tiered 
>> storage, I mean hot data lying on fast storage and cold data on slow 
>> storage. I'm not talking about cashing (where you just keep a copy of 
>> the hot data on the fast storage).
>>
>> And btw, how far is raid[56] and block-level dedup from something 
>> useful in production?
>>
>> Vennlig hilsen
>>
>> roy
>> -- 
>> Roy Sigurd Karlsbakk
>> (+47) 98013356
>> http://blogg.karlsbakk.net/
>> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
>> -- 
>> Hið góða skaltu í stein höggva, hið illa í snjó rita.

