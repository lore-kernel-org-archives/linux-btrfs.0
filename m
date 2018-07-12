Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-3.server.virginmedia.net ([80.0.253.67]:40762
        "EHLO know-smtprelay-omc-3.server.virginmedia.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732458AbeGLWYD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jul 2018 18:24:03 -0400
Subject: Re: Transaction aborted (error -28)
 btrfs_run_delayed_refs*0x163/0x190
From: Pete <pete@petezilla.co.uk>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <c641cf2f-1b94-f7ed-3bb5-95a0c4bd2493@petezilla.co.uk>
 <44fabb78-f0ec-d79c-be20-8689bd00d2cd@suse.com>
 <881e443e-60fe-9615-dd8e-7f935761d3af@petezilla.co.uk>
 <1ef30bf4-091d-cc4f-c081-9db262ebc7a8@suse.com>
 <b89a3cdc-aaad-a927-1967-d4c32ad66b08@petezilla.co.uk>
Message-ID: <85565a70-9111-0fe7-b1af-80febe5f3c1e@petezilla.co.uk>
Date: Thu, 12 Jul 2018 23:12:27 +0100
MIME-Version: 1.0
In-Reply-To: <b89a3cdc-aaad-a927-1967-d4c32ad66b08@petezilla.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/12/2018 07:07 PM, Pete wrote:
> On 07/12/2018 08:11 AM, Nikolay Borisov wrote:
>>
>>
>> This one shouldn't have gone RO since it has plenty of unallocated and
>> free space. What was the workload at the time it went RO? Hard to say,
>> it's best if you can provide output with the debug patch applied when
>> this issue re-appears.
>>
> 
> I'll respond in a separate email to list, as the above is the more
> important issue and I need to trawl the logs.

Nothing seen, though I recently had the disks go read-only.  I'll wait
and see what happens.

Pete
