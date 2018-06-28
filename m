Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:41664 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965506AbeF1ORb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 10:17:31 -0400
Received: by mail-ot0-f181.google.com with SMTP id d19-v6so6297572oti.8
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Jun 2018 07:17:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
References: <66d30a90-a571-a110-749d-8a3fd6ccb9d5@georgianit.com> <9bbde3a8-2498-a538-5744-c857f5a57947@oracle.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 28 Jun 2018 08:17:30 -0600
Message-ID: <CAJCQCtSuKpcn2Or3LiCYqeFMFFoRU09BFQE_n8FAhQ2Vo+83PA@mail.gmail.com>
Subject: Re: Major design flaw with BTRFS Raid, temporary device drop will
 corrupt nodatacow files
To: Anand Jain <anand.jain@oracle.com>
Cc: Remi Gauvin <remi@georgianit.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The problems are known with Btrfs raid1, but I think they bear
repeating because they are really not OK.

In the exact same described scenario: a simple clear cut drop off of a
member device, which then later clearly reappears (no transient
failure).

Both mdadm and LVM based raid1 would have re-added the missing device
and resynced it because internal bitmap is the default (on > 100G
arrays for mdadm and always with lvm). Only the new data would be
propagated to user space. Both mdadm and lvm have metadata to know
which drive has stale data in this common scenario.

Btrfs does two, maybe three, bad things:
1. No automatic resync. This is a net worse behavior than mdadm and
lvm, putting data at risk.
2. The new data goes in a single chunk; even if the user does a manual
balance (resync) their data isn't replicated. They must know to do a
-dconvert balance to replicate the new data. Again this is a net worse
behavior than mdadm out of the box, putting user data at risk.
3. Apparently if nodatacow, given a file with two copies of different
transid, Btrfs won't always pick the higher transid copy? If true
that's terrible, and again not at all what mdadm/lvm are doing.


Btrfs can do better because it has more information available to make
unambiguous decisions about data. But it needs to always do at least
as good a job as mdadm/lvm and as reported, that didn't happen. So
some tested is needed in particular case #3 above with nodatacow.
That's a huge bug, if it's true.


Chris Murphy
