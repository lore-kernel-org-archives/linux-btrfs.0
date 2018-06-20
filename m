Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52045 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754557AbeFTTeV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 15:34:21 -0400
Subject: Re: [PATCH 3/3] btrfs: use timespec64 for i_otime
To: dsterba@suse.cz, Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        y2038@lists.linaro.org, Omar Sandoval <osandov@fb.com>,
        Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180620143448.44388-1-arnd@arndb.de>
 <20180620143448.44388-3-arnd@arndb.de> <20180620163804.GE24375@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <263b1bc6-0efb-8803-fb9a-68a1393d35b2@suse.com>
Date: Wed, 20 Jun 2018 22:34:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180620163804.GE24375@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20.06.2018 19:38, David Sterba wrote:
> On Wed, Jun 20, 2018 at 04:34:34PM +0200, Arnd Bergmann wrote:
>> While the regular inode timestamps all use timespec64 now, the
>> i_otime field is btrfs specific and still needs to be converted
>> to correctly represent times beyond 2038.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> This patch addresses the remaining type conversions, so I'm going to
> merge it, thanks.
> 

Actually for the sake of consistency we might want to merge this series
altogether. As it stands we now use ktime_get_seconds and
ktime_get_real_seconds (from Allen's patch). I haven't dug to see what's
the difference (if any) between the two .
