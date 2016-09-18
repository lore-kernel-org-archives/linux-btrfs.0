Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45565 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752725AbcIRIcw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Sep 2016 04:32:52 -0400
Subject: RAID1 availability issue[2], Hot-spare and auto-replace
To: dsterba@suse.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
 <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
 <20160917203519.GE933@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f1b74a5d-1fdf-2970-86fc-206a4bb26d78@oracle.com>
Date: Sun, 18 Sep 2016 16:34:41 +0800
MIME-Version: 1.0
In-Reply-To: <20160917203519.GE933@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


(updated the subject, was [1])

> IMO the hot-spare feature makes most sense with the raid56,

   Why. ?

> which is stuck where it is, so we need to get it working first.


   We need at least one RAID which does not have the availability
   issue. We could achieve that with raid1, there are patches
   which needs maintainer time.


-Anand

[1]
Re: [RFC] Preliminary BTRFS Encryption

[2]
References:
btrfs: Do per-chunk check for mount time check
  OR
btrfs: create degraded-RAID1 chunks
(needs review).
