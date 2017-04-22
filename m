Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47196 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1427090AbdDVVSp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 22 Apr 2017 17:18:45 -0400
Subject: Re: Experiences with metadata balance/convert
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <78d61749-ec9c-1cc3-196f-5330489e2b3e@mendix.com>
 <pan$4a44a$5b70b88a$e087c574$18e5ec69@cox.net>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <2866c3e6-2be9-897b-386a-a3cc1d0ca43a@mendix.com>
Date: Sat, 22 Apr 2017 23:18:42 +0200
MIME-Version: 1.0
In-Reply-To: <pan$4a44a$5b70b88a$e087c574$18e5ec69@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/22/2017 11:17 AM, Duncan wrote:
> Hans van Kranenburg posted on Fri, 21 Apr 2017 12:26:18 +0200 as
> excerpted:
> 
>> So, I used the clone functionality of the underlying iSCSI target to get
>> a writable throw-away version of the filesystem to experiment with
>> (great!).
> 
> Please, I'm rather sure you know all this and have setup your system 
> accordingly, but we need to try to make it explicit any time there's 
> mention of any sort of device or filesystem cloning tool, that we tell 
> others that may happen on the post either just reading the list or via a 
> google or the like...

Ack. [1]

[1]
https://btrfs.wiki.kernel.org/index.php/Gotchas#Block-level_copies_of_devices

> [..... .. .. . ... .. . . .. . ..]
> (Of course the above is an explanation in far more detail than that 
> single-liner, because it's the full topic of the post and I might as 
> well, compared to the simple parenthetical I'm asking for when clone 
> discussions come up.)

Thanks for stressing the fact.

And yes, the cloned iSCSI luns are only visible to a completely separate
server configured in another initiator group of the target, seen by
hardware that is not aware of what's happenning in the production cluster.

-- 
Hans van Kranenburg
