Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47752 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163867AbdEZHjr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 03:39:47 -0400
Subject: Re: [PATCH] btrfs: btrfs_decompress_bio() could accept compressed_bio
 instead
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20170524030151.29085-1-anand.jain@oracle.com>
 <1c9682a6-466e-e993-149d-35e25a864b1e@suse.com>
Cc: dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <e76f54b7-51a7-3884-74f1-977f042bd02b@oracle.com>
Date: Fri, 26 May 2017 15:45:40 +0800
MIME-Version: 1.0
In-Reply-To: <1c9682a6-466e-e993-149d-35e25a864b1e@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>
> Can you take this idea one notch further and refactor also
> zlib_decompress_bio and lzo_decompress_bio functions as well?

  Done. Added in v2.

Thanks, Anand
