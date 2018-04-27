Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43829 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758276AbeD0QIq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 12:08:46 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C6DEEAC07
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 16:08:45 +0000 (UTC)
Subject: Re: [PATCH 3/3] btrfs: qgroup, don't try to insert status item after
 ENOMEM in rescan worker
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180426192351.473-3-jeffm@suse.com>
 <471d8f08-ee33-80c7-67be-d35d5df6f166@suse.com>
 <20180427154425.GB21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <b688d761-ff7f-2fe8-484d-f29eac58a0b5@suse.com>
Date: Fri, 27 Apr 2018 12:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <20180427154425.GB21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/27/18 11:44 AM, David Sterba wrote:
> On Thu, Apr 26, 2018 at 11:39:50PM +0300, Nikolay Borisov wrote:
>> On 26.04.2018 22:23, jeffm@suse.com wrote:
>>> From: Jeff Mahoney <jeffm@suse.com>
>>>
>>> If we fail to allocate memory for a path, don't bother trying to
>>> insert the qgroup status item.  We haven't done anything yet and it'll
>>> fail also.  Just print an error and be done with it.
>>>
>>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>>
>> nit: So the code is correct however, having the out label there is
>> really ugly. What about on path alloc failure just have the print in the
>> if branch do goto done?
> 
> Yeah, I don't like jumping to the inner blocks either. I saw this in the
> qgroup code so we should clean it up and not add new instances.
> 
> In this case, only the path allocation failure jumps to the out label,
> so printing the message and then jump to done makes sense to me.
> However, the message would have to be duplicated in the end, and I don't
> see a better way without further restructuring the code.
> 

It doesn't require major surgery.  The else can be disconnected.

-Jeff

-- 
Jeff Mahoney
SUSE Labs
