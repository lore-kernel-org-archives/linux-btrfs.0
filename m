Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58004 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751142AbeCGMRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 07:17:24 -0500
Subject: Re: [PATCH 2/2] Btrfs: fix fiemap extent SHARED flag error with range
 clone.
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, robbieko <robbieko@synology.com>
Cc: linux-btrfs@vger.kernel.org, linux-btrfs-owner@vger.kernel.org
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a9228371-847b-0ea9-8c5f-230fbdcc350d@suse.com>
Date: Wed, 7 Mar 2018 14:17:21 +0200
MIME-Version: 1.0
In-Reply-To: <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1520410819-32405-3-git-send-email-robbieko@synology.com>
 <2ff9062e-54fa-50dd-8efa-352608746bc5@gmx.com>
 <2f3228e8-af87-d0aa-4f35-69e89873026b@gmx.com>
 <25bec3b50fe42a2f816f1391a438f624@synology.com>
 <81760b06-446f-494f-4b0b-dd5e07c76b35@gmx.com>
 <3b241323-0e2d-7428-ac91-1da3b3221c6a@suse.com>
 <e08ae323-c757-ee37-20de-767836b9104b@gmx.com>



On  7.03.2018 14:14, Qu Wenruo wrote:
> 
> 

<snip>

>>>
>>> SHARED flag is determined after extent map merge, so here we can't rely
>>> on em here.
>>
>> Shouldn't extent maps correspond to 1:1 disk-state. I.e. they are just
>> the memory cache of the extent state. So if we merge them, shouldn't we
>> also merge the on-disk extents as well ?
> 
> Not 1:1.
> 
> In memory one is merged maybe to save memory.
> 
> But on-disk file extents has size limit.
> For compressed one it's 128K and 128M for uncompressed one.

Fair enough, however 4 extents, 16k each should warrant merging on-disk
as well, no ?

<snip>
