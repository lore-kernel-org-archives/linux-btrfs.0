Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:35210 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729706AbeGQQfz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 12:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <dbbb1882-65bf-dda9-eb26-a6217b240def@gmx.com>
References: <20180717135236.3673195-1-arnd@arndb.de> <dbbb1882-65bf-dda9-eb26-a6217b240def@gmx.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 17 Jul 2018 18:02:31 +0200
Message-ID: <CAK8P3a17Mik-J-PzjP2g7OzX-0ozTGnRxfw8tB4c+pKiRWoEaA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix size_t format string
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 4:33 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
> On 2018年07月17日 21:52, Arnd Bergmann wrote:
>> The newly added check_block_group_item() function causes a build warning
>> on 32-bit architectures:
>>
>> fs/btrfs/tree-checker.c: In function 'check_block_group_item':
>> fs/btrfs/tree-checker.c:404:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
>>
>> The type of a sizeof() expression is size_t, which is correctly printed
>> using the %zu format string.
>>
>> Fixes: 9dc16aad5660 ("btrfs: tree-checker: Verify block_group_item")
>
> My fault again. :(
>
> Is there anyway to make gcc report such problem even under x86_64?

I don't think so. However, if you post a patch to the mainling list, the
0-day bot should report any build regressions within a day.

      Arnd
