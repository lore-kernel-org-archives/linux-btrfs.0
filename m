Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42093 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753202AbeFTPPv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 11:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <20180620143655.GD24375@twin.jikos.cz>
References: <20180620143448.44388-1-arnd@arndb.de> <20180620143448.44388-2-arnd@arndb.de>
 <20180620143655.GD24375@twin.jikos.cz>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 20 Jun 2018 17:15:49 +0200
Message-ID: <CAK8P3a3=Obi3MS0bdrLRPJ2FE2igmzNkOM47mqtco0UwyW60sw@mail.gmail.com>
Subject: Re: [PATCH 2/3] btrfs: use 64-bit timestamps for struct btrfs_dev_replace_item
To: David Sterba <dsterba@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Allen Pais <allen.lkml@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 4:36 PM, David Sterba <dsterba@suse.cz> wrote:
> On Wed, Jun 20, 2018 at 04:34:33PM +0200, Arnd Bergmann wrote:
>> The structure already has 64-bit fields for the timestamps, but
>> calling get_seconds() may truncate and risk overflow on 32-bit
>> architectures.
>>
>> This changes the dev-replace code to use ktime_get_real_seconds()
>> instead, which always returns 64-bit timestamps.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Thanks but there's a patch already fixng that, sent a few days ago
>
> https://patchwork.kernel.org/patch/10473195/
>
> and added to patch queue for the next dev cycle as it does not appear to
> urgent for 4.18.

Ok, sounds good.
I had missed that Allen has independently sent out some of the
same patches that I created in the last weeks.

Allen, do you have more patches pending? I have sent out most of what
I did (around 80 patches I think), with just ext4, ceph, nfs and xfs pending
at the moment. It seems we also sent identical patches for procfs and
I have something pending for ceph that duplicates another patch you did.

      Arnd
