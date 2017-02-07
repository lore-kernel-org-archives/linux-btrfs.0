Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:35367 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753259AbdBGUzh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:55:37 -0500
Received: by mail-it0-f45.google.com with SMTP id 203so86239146ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 12:55:36 -0800 (PST)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id z125sm10127521iod.23.2017.02.07.12.47.47
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2017 12:47:47 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: linux-btrfs@vger.kernel.org
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <20170207213614.5fd40981@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <7c1a67ce-a62c-36e1-d228-9a1e15e4d16c@gmail.com>
Date: Tue, 7 Feb 2017 15:47:43 -0500
MIME-Version: 1.0
In-Reply-To: <20170207213614.5fd40981@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 15:36, Kai Krakow wrote:
> Am Tue, 7 Feb 2017 09:13:25 -0500
> schrieb Peter Zaitsev <pz@percona.com>:
>
>> Hi Hugo,
>>
>> For the use case I'm looking for I'm interested in having snapshot(s)
>> open at all time.  Imagine  for example snapshot being created every
>> hour and several of these snapshots  kept at all time providing quick
>> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
>> think you also describe)  nodatacow  does not provide any advantage.
>
> Out of curiosity, I see one problem here:
>
> If you're doing snapshots of the live database, each snapshot leaves
> the database files like killing the database in-flight. Like shutting
> the system down in the middle of writing data.
>
> This is because I think there's no API for user space to subscribe to
> events like a snapshot - unlike e.g. the VSS API (volume snapshot
> service) in Windows. You should put the database into frozen state to
> prepare it for a hotcopy before creating the snapshot, then ensure all
> data is flushed before continuing.
Correct.
>
> I think I've read that btrfs snapshots do not guarantee single point in
> time snapshots - the snapshot may be smeared across a longer period of
> time while the kernel is still writing data. So parts of your writes
> may still end up in the snapshot after issuing the snapshot command,
> instead of in the working copy as expected.
Also correct AFAICT, and this needs to be better documented (for most 
people, the term snapshot implies atomicity of the operation).
>
> How is this going to be addressed? Is there some snapshot aware API to
> let user space subscribe to such events and do proper preparation? Is
> this planned? LVM could be a user of such an API, too. I think this
> could have nice enterprise-grade value for Linux.
Ideally, such an API should be in the VFS layer, not just BTRFS. 
Reflinking exists in other filesystems already, it's only a matter of 
time before they decide to do snapshotting too.
>
> XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. But
> still, also this needs to be integrated with MySQL to properly work. I
> once (years ago) researched on this but gave up on my plans when I
> planned database backups for our web server infrastructure. We moved to
> creating SQL dumps instead, although there're binlogs which can be used
> to recover to a clean and stable transactional state after taking
> snapshots. But I simply didn't want to fiddle around with properly
> cleaning up binlogs which accumulate horribly much space usage over
> time. The cleanup process requires to create a cold copy or dump of the
> complete database from time to time, only then it's safe to remove all
> binlogs up to that point in time.
Sadly, freezefs (the generic interface based off of xfs_freeze) only 
works for block device snapshots.  Filesystem level snapshots need the 
application software to sync all it's data and then stop writing until 
the snapshot is complete.

As of right now, the sanest way I can come up with for a database server 
is to find a way to do a point-in-time SQL dump of the database (this 
also has the advantage that it works as a backup, and decouples you from 
the backing storage format).

