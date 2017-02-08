Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from net.its-24.pl ([5.63.185.56]:43535 "EHLO adrb.pl"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754292AbdBHOtl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Feb 2017 09:49:41 -0500
Subject: Re: BTRFS for OLTP Databases
To: Martin Raiber <martin@urbackup.org>, Peter Zaitsev <pz@percona.com>,
        linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij3yQ83HQzN8VfzAaku6+HTcXEz+iqu5nV1=UVX6Gc4ddw@mail.gmail.com>
 <0102015a1da5be24-3fd02799-c4e0-461b-92d2-82131016432e-000000@eu-west-1.amazonses.com>
From: Adrian Brzezinski <linux-btrfs@adrb.pl>
Message-ID: <13c04fa3-3318-10d6-5664-f4bdb2c095b4@adrb.pl>
Date: Wed, 8 Feb 2017 14:00:38 +0100
MIME-Version: 1.0
In-Reply-To: <0102015a1da5be24-3fd02799-c4e0-461b-92d2-82131016432e-000000@eu-west-1.amazonses.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

W dniu 2017-02-08 o 13:14 PM, Martin Raiber pisze:
> Hi,
>
> On 08.02.2017 03:11 Peter Zaitsev wrote:
>> Out of curiosity, I see one problem here:
>> If you're doing snapshots of the live database, each snapshot leaves
>> the database files like killing the database in-flight. Like shutting
>> the system down in the middle of writing data.
>>
>> This is because I think there's no API for user space to subscribe to
>> events like a snapshot - unlike e.g. the VSS API (volume snapshot
>> service) in Windows. You should put the database into frozen state to
>> prepare it for a hotcopy before creating the snapshot, then ensure all
>> data is flushed before continuing.
>>
>> I think I've read that btrfs snapshots do not guarantee single point in
>> time snapshots - the snapshot may be smeared across a longer period of
>> time while the kernel is still writing data. So parts of your writes
>> may still end up in the snapshot after issuing the snapshot command,
>> instead of in the working copy as expected.
>>
>> How is this going to be addressed? Is there some snapshot aware API to
>> let user space subscribe to such events and do proper preparation? Is
>> this planned? LVM could be a user of such an API, too. I think this
>> could have nice enterprise-grade value for Linux.
>>
>> XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. But
>> still, also this needs to be integrated with MySQL to properly work. I
>> once (years ago) researched on this but gave up on my plans when I
>> planned database backups for our web server infrastructure. We moved to
>> creating SQL dumps instead, although there're binlogs which can be used
>> to recover to a clean and stable transactional state after taking
>> snapshots. But I simply didn't want to fiddle around with properly
>> cleaning up binlogs which accumulate horribly much space usage over
>> time. The cleanup process requires to create a cold copy or dump of the
>> complete database from time to time, only then it's safe to remove all
>> binlogs up to that point in time.
> little bit off topic, but I for one would be on board with such an
> effort. It "just" needs coordination between the backup
> software/snapshot tools, the backed up software and the various snapshot
> providers. If you look at the Windows VSS API, this would be a
> relatively large undertaking if all the corner cases are taken into
> account, like e.g. a database having the database log on a separate
> volume from the data, dependencies between different components etc.
>
> You'll know more about this, but databases usually fsync quite often in
> their default configuration, so btrfs snapshots shouldn't be much behind
> the properly snapshotted state, so I see the advantages more with
> usability and taking care of corner cases automatically.
>
> Regards,
> Martin Raiber

xfs_freeze works also for BTRFS...


-- 

Adrian Brzeziński

