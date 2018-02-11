Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-by2nam01on0088.outbound.protection.outlook.com ([104.47.34.88]:57184
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751077AbeBKQPS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Feb 2018 11:15:18 -0500
Subject: Re: btrfs-cleaner / snapshot performance analysis
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <346220b8-d129-1de9-eb28-6344ec0b0d3a@panasas.com>
 <96cd9e57-cde4-5bc4-0312-02b54668e59a@mendix.com>
 <76e7f364-62b9-5ef1-a8ed-f6fb9e534963@panasas.com>
 <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
From: "Ellis H. Wilson III" <ellisw@panasas.com>
Message-ID: <bd443816-88e6-acd8-599b-8e34de1ac88c@panasas.com>
Date: Sun, 11 Feb 2018 11:15:21 -0500
MIME-Version: 1.0
In-Reply-To: <13d35a99-98ef-5861-3b44-17428d999a7c@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hans.  Sorry for the top-post, but I'm boiling things down here 
so I don't have a clear line-item to respond to.  The take-aways I see 
here to my original queries are:

1. Nobody has done a thorough analysis of the impact of snapshot 
manipulation WITHOUT qgroups enabled on foreground I/O performance
2. Nobody has done a thorough analysis of the impact of snapshot 
manipulation WITH qgroups enabled on foreground I/O performance
3. I need to look at the code to understand the interplay between 
qgroups, snapshots, and foreground I/O performance as there isn't 
existing architecture documentation to point me to that covers this
4. I should be cautioned that CoW in BTRFS can exhibit pathological (if 
expected) capacity consumption for very random-write-oriented datasets 
with or without snapshots, and nocow (or in my case transparently 
absorbing and coalescing writes at a higher tier) is my friend.
5. I should be cautioned that CoW is broken across snapshots when 
defragmentation is run.

I will update a test system to the most recent kernel and will perform 
tests to answer #1 and #2.  I will plan to share it when I'm done.  If I 
have time to write-up my findings for #3 I will similarly share that.

Thanks to all for your input on this issue.

ellis
