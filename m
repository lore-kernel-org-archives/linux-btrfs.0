Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:37184 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753562AbeBKSDs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 13:03:48 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: "Ellis H. Wilson III" <ellisw@panasas.com>, linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
 <bd443816-88e6-acd8-599b-8e34de1ac88c@panasas.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b5b7fa86-0fa3-84e2-13c8-f63f1b219148@mendix.com>
Date: Sun, 11 Feb 2018 19:03:46 +0100
MIME-Version: 1.0
In-Reply-To: <bd443816-88e6-acd8-599b-8e34de1ac88c@panasas.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/11/2018 05:15 PM, Ellis H. Wilson III wrote:
> Thanks Hans.  Sorry for the top-post, but I'm boiling things down here
> so I don't have a clear line-item to respond to.  The take-aways I see
> here to my original queries are:
> 
> 1. Nobody has done a thorough analysis of the impact of snapshot
> manipulation WITHOUT qgroups enabled on foreground I/O performance
> 2. Nobody has done a thorough analysis of the impact of snapshot
> manipulation WITH qgroups enabled on foreground I/O performance

It's more that there is no simple list of clear-cut answers that apply
to every possible situation and type/pattern of work that you can throw
at a btrfs filesystem.

> 3. I need to look at the code to understand the interplay between
> qgroups, snapshots, and foreground I/O performance as there isn't
> existing architecture documentation to point me to that covers this

Well, the excellent write-up of Qu this morning shows some explanation
from the design point of view.

> 4. I should be cautioned that CoW in BTRFS can exhibit pathological (if
> expected) capacity consumption for very random-write-oriented datasets
> with or without snapshots, and nocow (or in my case transparently
> absorbing and coalescing writes at a higher tier) is my friend.

nocow only keeps the cows on a distance as long as you don't start
snapshotting (or cp --reflink) those files... If you take a snapshot,
then you force btrfs to keep the data around that is referenced by the
snapshot. So, that means that every next write will be cowed once again,
moo, so small writes will be redirected to a new location, causing
fragmentation again. The second and third write can go in the same (new)
location of the first new write, but as soon as you snapshot again, this
happens again.

> 5. I should be cautioned that CoW is broken across snapshots when
> defragmentation is run.
> 
> I will update a test system to the most recent kernel and will perform
> tests to answer #1 and #2.  I will plan to share it when I'm done.  If I
> have time to write-up my findings for #3 I will similarly share that.
> 
> Thanks to all for your input on this issue.

Have fun!

-- 
Hans van Kranenburg
