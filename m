Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f171.google.com ([209.85.217.171]:32797 "EHLO
        mail-ua0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753797AbdBHOsf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 09:48:35 -0500
Received: by mail-ua0-f171.google.com with SMTP id i68so110698396uad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Feb 2017 06:47:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0102015a1de76a82-da5513d7-1cd8-4eff-9e0a-e34aac752e1f-000000@eu-west-1.amazonses.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk> <CA+RUij3yQ83HQzN8VfzAaku6+HTcXEz+iqu5nV1=UVX6Gc4ddw@mail.gmail.com>
 <0102015a1da5be24-3fd02799-c4e0-461b-92d2-82131016432e-000000@eu-west-1.amazonses.com>
 <f96d3dff-97ad-561d-c7ef-cf9b51189bc1@gmail.com> <0102015a1de76a82-da5513d7-1cd8-4eff-9e0a-e34aac752e1f-000000@eu-west-1.amazonses.com>
From: Peter Zaitsev <pz@percona.com>
Date: Wed, 8 Feb 2017 08:38:17 -0500
Message-ID: <CA+RUij3-9=cZBgUbAwOMCTe+kKHjn9tdzxq+sM0AnRowRUwx=Q@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: Martin Raiber <martin@urbackup.org>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When it comes to MySQL I'm not really sure what you're trying to
achieve.  Because MySQL manages its own cache flushing OS cache to the
disk and "freezing" FS does not really do much - it will still need to
do crash recovery when such snapshot is restored.

The reason people would use xfs_freeze with MySQL is when we have the
database spread across different filesystems - typically   log files
placed on the different partition than the data or databases placed on
different partitions.  In this case you need to have consistent single
point in time snapshot across the filesystems for backup to be
recoverable.         More common approach though is to keep it KISS
and have everything on single filesystem.

On Wed, Feb 8, 2017 at 8:26 AM, Martin Raiber <martin@urbackup.org> wrote:
> On 08.02.2017 14:08 Austin S. Hemmelgarn wrote:
>> On 2017-02-08 07:14, Martin Raiber wrote:
>>> Hi,
>>>
>>> On 08.02.2017 03:11 Peter Zaitsev wrote:
>>>> Out of curiosity, I see one problem here:
>>>> If you're doing snapshots of the live database, each snapshot leaves
>>>> the database files like killing the database in-flight. Like shutting
>>>> the system down in the middle of writing data.
>>>>
>>>> This is because I think there's no API for user space to subscribe to
>>>> events like a snapshot - unlike e.g. the VSS API (volume snapshot
>>>> service) in Windows. You should put the database into frozen state to
>>>> prepare it for a hotcopy before creating the snapshot, then ensure all
>>>> data is flushed before continuing.
>>>>
>>>> I think I've read that btrfs snapshots do not guarantee single point in
>>>> time snapshots - the snapshot may be smeared across a longer period of
>>>> time while the kernel is still writing data. So parts of your writes
>>>> may still end up in the snapshot after issuing the snapshot command,
>>>> instead of in the working copy as expected.
>>>>
>>>> How is this going to be addressed? Is there some snapshot aware API to
>>>> let user space subscribe to such events and do proper preparation? Is
>>>> this planned? LVM could be a user of such an API, too. I think this
>>>> could have nice enterprise-grade value for Linux.
>>>>
>>>> XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. But
>>>> still, also this needs to be integrated with MySQL to properly work. I
>>>> once (years ago) researched on this but gave up on my plans when I
>>>> planned database backups for our web server infrastructure. We moved to
>>>> creating SQL dumps instead, although there're binlogs which can be used
>>>> to recover to a clean and stable transactional state after taking
>>>> snapshots. But I simply didn't want to fiddle around with properly
>>>> cleaning up binlogs which accumulate horribly much space usage over
>>>> time. The cleanup process requires to create a cold copy or dump of the
>>>> complete database from time to time, only then it's safe to remove all
>>>> binlogs up to that point in time.
>>>
>>> little bit off topic, but I for one would be on board with such an
>>> effort. It "just" needs coordination between the backup
>>> software/snapshot tools, the backed up software and the various snapshot
>>> providers. If you look at the Windows VSS API, this would be a
>>> relatively large undertaking if all the corner cases are taken into
>>> account, like e.g. a database having the database log on a separate
>>> volume from the data, dependencies between different components etc.
>>>
>>> You'll know more about this, but databases usually fsync quite often in
>>> their default configuration, so btrfs snapshots shouldn't be much behind
>>> the properly snapshotted state, so I see the advantages more with
>>> usability and taking care of corner cases automatically.
>> Just my perspective, but BTRFS (and XFS, and OCFS2) already provide
>> reflinking to userspace, and therefore it's fully possible to
>> implement this in userspace.  Having a version of the fsfreeze (the
>> generic form of xfs_freeze) stuff that worked on individual sub-trees
>> would be nice from a practical perspective, but implementing it would
>> not be easy by any means, and would be essentially necessary for a
>> VSS-like API.  In the meantime though, it is fully possible for the
>> application software to implement this itself without needing anything
>> more from the kernel.
>
> VSS snapshots whole volumes, not individual files (so comparable to an
> LVM snapshot). The sub-folder freeze would be something useful in some
> situations, but duplicating the files+extends might also take too long
> in a lot of situations. You are correct that the kernel features are
> there and what is missing is a user-space daemon, plus a protocol that
> facilitates/coordinates the backups/snapshots.
>
> Sending a FIFREEZE ioctl, taking a snapshot and then thawing it does not
> really help in some situations as e.g. MySQL InnoDB uses O_DIRECT and
> manages its on buffer pool which won't get the FIFREEZE and flush, but
> as said, the default configuration is to flush/fsync on every commit.
>
>
>



-- 
Peter Zaitsev, CEO, Percona
Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
