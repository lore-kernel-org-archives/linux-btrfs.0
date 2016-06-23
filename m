Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34949 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbcFWKD6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 06:03:58 -0400
Received: by mail-wm0-f44.google.com with SMTP id v199so119693515wmv.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 03:03:57 -0700 (PDT)
Subject: Re: On shrinkable caches
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
References: <5767D2D4.4090709@kyup.com> <20160623094347.GX4915@twin.jikos.cz>
From: Nikolay Borisov <kernel@kyup.com>
Message-ID: <576BB40A.8030408@kyup.com>
Date: Thu, 23 Jun 2016 13:03:54 +0300
MIME-Version: 1.0
In-Reply-To: <20160623094347.GX4915@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2016 12:43 PM, David Sterba wrote:
> On Mon, Jun 20, 2016 at 02:26:12PM +0300, Nikolay Borisov wrote:
>> I have a question regarding the SLAB_RECLAIM_ACCOUNT flag with which
>> BTRFS caches are created. Currently there isn't a single usage of
>> register_shrinker under fs/btrfs.
> 
> The SLAB_RECLAIM_ACCOUNT flag has been there since the first versions in
> 2007 (when shrinkeres did not exist) but I can't find any specific
> reason why.
> 
>> Apart from the inode cache which is
>> being shrunk from the generic super_cache_scan I don't think the memory
>> used for those caches should be accounted as reclaimable?
> 
> I agree, in most cases I don't see any possibility to reclaim the
> objects earlier than the explicit free.

If that's the case, then I'll be happy to send a patch.

