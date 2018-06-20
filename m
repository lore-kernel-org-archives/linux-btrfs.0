Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:42381 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932154AbeFTTlq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 15:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <263b1bc6-0efb-8803-fb9a-68a1393d35b2@suse.com>
References: <20180620143448.44388-1-arnd@arndb.de> <20180620143448.44388-3-arnd@arndb.de>
 <20180620163804.GE24375@twin.jikos.cz> <263b1bc6-0efb-8803-fb9a-68a1393d35b2@suse.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 20 Jun 2018 21:41:44 +0200
Message-ID: <CAK8P3a01n5shWS9x6q8Camd0WyuSfSRftthmUBQHYgPLOBUTWQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] btrfs: use timespec64 for i_otime
To: Nikolay Borisov <nborisov@suse.com>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        y2038 Mailman List <y2038@lists.linaro.org>,
        Omar Sandoval <osandov@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2018 at 9:34 PM, Nikolay Borisov <nborisov@suse.com> wrote:
>
>
> On 20.06.2018 19:38, David Sterba wrote:
>> On Wed, Jun 20, 2018 at 04:34:34PM +0200, Arnd Bergmann wrote:
>>> While the regular inode timestamps all use timespec64 now, the
>>> i_otime field is btrfs specific and still needs to be converted
>>> to correctly represent times beyond 2038.
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>
>> This patch addresses the remaining type conversions, so I'm going to
>> merge it, thanks.
>>
>
> Actually for the sake of consistency we might want to merge this series
> altogether. As it stands we now use ktime_get_seconds and
> ktime_get_real_seconds (from Allen's patch). I haven't dug to see what's
> the difference (if any) between the two .

I just checked again and see that Allen's patch addresses the first two
of my three patches, but he picked a different approach for
transaction_kthread(): My patch moved to CLOCK_MONOTONIC,
while his version only changed the to time64_t but kept the
CLOCK_REALTIME behavior. It's a small difference, but I think
my version is slightly better. My patch 2/3 is identical to his version.

If you like, I can also rebase my patch 1/3 on top of his patch and
change it to CLOCK_MONOTONIC.

         Arnd
