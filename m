Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42154 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752156AbdCNNbb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Mar 2017 09:31:31 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE9BAAD45
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Mar 2017 13:31:29 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: Change qgroup_meta_rsv to 64bit
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170314102509.10648-1-rgoldwyn@suse.de>
 <20170314123042.GX14605@twin.jikos.cz>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <4a12caba-15d3-ec94-86e0-3b196c56aaba@suse.de>
Date: Tue, 14 Mar 2017 08:31:26 -0500
MIME-Version: 1.0
In-Reply-To: <20170314123042.GX14605@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/14/2017 07:30 AM, David Sterba wrote:
> On Tue, Mar 14, 2017 at 05:25:09AM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Using an int value is causing qg->reserved to become negative and
>> exclusive -EDQUOT to be reached prematurely.
> 
> V1 had a reproducer, I think it's fine to keep it here so I'll copy it.
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 

I am adding a testcase in (x)fstests which covers both qgroup issues for
which I have sent the patches. I am fine either ways.

-- 
Goldwyn
