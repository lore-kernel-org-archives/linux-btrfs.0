Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47822 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbeBIUgL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Feb 2018 15:36:11 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
Date: Fri, 9 Feb 2018 21:36:08 +0100
MIME-Version: 1.0
In-Reply-To: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/09/2018 05:45 PM, Ellis H. Wilson III wrote:
> 
> I am trying to better understand how the cleaner kthread (btrfs-cleaner)
> impacts foreground performance, specifically during snapshot deletion.
> My experience so far has been that it can be dramatically disruptive to
> foreground I/O.
> 
> Looking through the wiki at kernel.org I have not yet stumbled onto any
> analysis that would shed light on this specific problem.  I have found
> numerous complaints about btrfs-cleaner online, especially relating to
> quotas being enabled.  This has proven thus far less than helpful, as
> the response tends to be "use less snapshots," or "disable quotas," both
> of which strike me as intellectually unsatisfying answers

Well, sometimes those answers help. :) "Oh, yes, I disabled qgroups, I
didn't even realize I had those, and now the problem is gone."

>, especially
> the former in a filesystem where snapshots are supposed to be
> "first-class citizens."

Throwing complaints around is also not helpful.

> The 2007 and 2013 Rodeh papers don't do the thorough practical snapshot
> performance analysis I would expect to see given the assertions in the
> latter that "BTRFS...supports efficient snapshots..."  The former is
> sufficiently pre-BTRFS that while it does performance analysis of btree
> clones, it's unclear (to me at least) if the results can be
> forward-propagated in some way to real-world performance expectations
> for BTRFS snapshot creation/deletion/modification.

I don't really think they can.

> Has this analysis been performed somewhere else and I'm just missing it?
>  Also, I'll be glad to comment on my specific setup, kernel version,
> etc, and discuss pragmatic work-arounds, but I'd like to better
> understand the high-level performance implications first.

The "performance implications" are highly dependent on your specific
setup, kernel version, etc, so it really makes sense to share:

* kernel version
* mount options (from /proc/mounts|grep btrfs)
* is it ssd? hdd? iscsi lun?
* how big is the FS
* how many subvolumes/snapshots? (how many snapshots per subvolume)

And what's essential to look at is what your computer is doing while you
are throwing a list of subvolumes into the cleaner.

* is it using 100% cpu?
* is it showing 100% disk read I/O utilization?
* is it showing 100% disk write I/O utilization? (is it writing lots and
lots of data to disk?)

Since you could be looking at any combination of answers on all those
things, there's not much specific to tell.

-- 
Hans van Kranenburg
