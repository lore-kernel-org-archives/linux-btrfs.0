Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:46694 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbeDPIGE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 04:06:04 -0400
Received: by mail-yb0-f180.google.com with SMTP id z16-v6so909710ybk.13
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 01:06:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180412141027.GL21272@twin.jikos.cz>
References: <CAJUuSvEgV0NU8Gu89eM=pM4mnYtKZgyNG31BASeHkiuH6Xj_nA@mail.gmail.com>
 <20180412141027.GL21272@twin.jikos.cz>
From: Ilan Schwarts <ilan84@gmail.com>
Date: Mon, 16 Apr 2018 11:06:03 +0300
Message-ID: <CAJUuSvGYrCmw7yOwNy+amYadi_=Y7HNiGaJwMW1nV4QneFi=4A@mail.gmail.com>
Subject: Re: error: redefinition of 'struct btrfs_ioctl_defrag_range_args
To: dsterba@suse.cz, Ilan Schwarts <ilan84@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks.
If you see no problems, then its probably locally on my machine.

On Thu, Apr 12, 2018 at 5:10 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Apr 11, 2018 at 01:22:23PM +0300, Ilan Schwarts wrote:
>> Hi
>> While trying to compile my kernel module on suse 12.2 kernel
>> 4.4.103-92.53-default
>> I recieve the following warning: error: redefinition of 'struct
>> btrfs_ioctl_defrag_range_args
>> I see that struct is defined in 2 places:
>> /lib/modules/4.4.103-92.53-default/source/fs/btrfs/ctree.h:1985:8
>> /usr/src/linux-4.4.103-92.53/include/uapi/linux/btrfs.h:497:8
>
> Some of the defintions were moved from fs/btrfs/ to uapi, so the sources
> seem to be in a half-state where it exists in both places.
>
>> Why is it defined in 2 places ?
>> No one else is getting that warning (which treated as error for me) ?
>
> I've never seen the warning, but I don't compile the 4.4 distro kernel.



-- 


-
Ilan Schwarts
