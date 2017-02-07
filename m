Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33455 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752702AbdBGUgZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 15:36:25 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cbCUs-0004ab-Bt
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 21:36:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: BTRFS for OLTP Databases
Date: Tue, 7 Feb 2017 21:36:14 +0100
Message-ID: <20170207213614.5fd40981@jupiter.sol.kaishome.de>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
        <20170207140058.GA4249@carfax.org.uk>
        <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Tue, 7 Feb 2017 09:13:25 -0500
schrieb Peter Zaitsev <pz@percona.com>:

> Hi Hugo,
> 
> For the use case I'm looking for I'm interested in having snapshot(s)
> open at all time.  Imagine  for example snapshot being created every
> hour and several of these snapshots  kept at all time providing quick
> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
> think you also describe)  nodatacow  does not provide any advantage.

Out of curiosity, I see one problem here:

If you're doing snapshots of the live database, each snapshot leaves
the database files like killing the database in-flight. Like shutting
the system down in the middle of writing data.

This is because I think there's no API for user space to subscribe to
events like a snapshot - unlike e.g. the VSS API (volume snapshot
service) in Windows. You should put the database into frozen state to
prepare it for a hotcopy before creating the snapshot, then ensure all
data is flushed before continuing.

I think I've read that btrfs snapshots do not guarantee single point in
time snapshots - the snapshot may be smeared across a longer period of
time while the kernel is still writing data. So parts of your writes
may still end up in the snapshot after issuing the snapshot command,
instead of in the working copy as expected.

How is this going to be addressed? Is there some snapshot aware API to
let user space subscribe to such events and do proper preparation? Is
this planned? LVM could be a user of such an API, too. I think this
could have nice enterprise-grade value for Linux.

XFS has xfs_freeze and xfs_thaw for this, to prepare LVM snapshots. But
still, also this needs to be integrated with MySQL to properly work. I
once (years ago) researched on this but gave up on my plans when I
planned database backups for our web server infrastructure. We moved to
creating SQL dumps instead, although there're binlogs which can be used
to recover to a clean and stable transactional state after taking
snapshots. But I simply didn't want to fiddle around with properly
cleaning up binlogs which accumulate horribly much space usage over
time. The cleanup process requires to create a cold copy or dump of the
complete database from time to time, only then it's safe to remove all
binlogs up to that point in time.

-- 
Regards,
Kai

Replies to list-only preferred.

