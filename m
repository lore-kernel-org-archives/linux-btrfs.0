Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:46856 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206Ab3KTSh5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 13:37:57 -0500
Received: by mail-oa0-f43.google.com with SMTP id i7so318863oag.30
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Nov 2013 10:37:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <528CF9D6.1000903@suse.com>
References: <528c09f9.S0ecVwNN2c+fnUkv%fengguang.wu@intel.com>
	<CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com>
	<20131120040551.GB4201@localhost>
	<20131120173044.5312.44850@localhost.localdomain>
	<528CF9D6.1000903@suse.com>
Date: Wed, 20 Nov 2013 10:37:56 -0800
Message-ID: <CAGXu5jJoo-XBpuu4DS_9zRH5p9tx3BgtrzrXu2J3nLSLY8EQfw@mail.gmail.com>
Subject: Re: fs/btrfs/extent-tree.c:8430:9: error: format not a string literal
 and no format arguments
From: Kees Cook <keescook@chromium.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Chris Mason <chris.mason@fusionio.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Josef Bacik <JBacik@fusionio.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 10:05 AM, Jeff Mahoney <jeffm@suse.com> wrote:
> On 11/20/13, 12:30 PM, Chris Mason wrote:
>> Quoting Fengguang Wu (2013-11-19 23:05:51)
>>> On Tue, Nov 19, 2013 at 07:56:35PM -0800, Kees Cook wrote:
>>>> Hi!
>>>>
>>>> Which tree is 'devel-snb'? I don't see that on the kernel.org trees.
>>>
>>> It's my local merge branch, based on the latest upstream release.
>>>
>>> Let's CC the btrfs developers for this warning. :)
>>>
>>> Thanks,
>>> Fengguang
>>>
>>>> On Tue, Nov 19, 2013 at 5:01 PM, kbuild test robot
>>>> <fengguang.wu@intel.com> wrote:
>>>>> tree:    devel-snb-x86_64-201311200240
>>>>> head:   1a985a0807ea34f37a4c5287089abd1cd2f65049
>>>>> commit: a9b93a3684dd6ebfb7cfa173f78a79c09de81207 Merge 'kees/format-security' into devel-snb-x86_64-201311200240
>>>>> date:   6 hours ago
>>>>> config: make ARCH=x86_64 allmodconfig
>>>>>
>>>>> All error/warnings:
>>>>>
>>>>>    fs/btrfs/extent-tree.c:6201:12: sparse: symbol 'get_raid_name' was not declared. Should it be static?
>>>>>    fs/btrfs/extent-tree.c:2469:28: sparse: context imbalance in 'run_clustered_refs' - unexpected unlock
>>>>>    fs/btrfs/extent-tree.c:8304:9: sparse: context imbalance in 'btrfs_put_block_group_cache' - wrong count at exit
>>>>>    fs/btrfs/extent-tree.c: In function '__link_block_group':
>>>>>>> fs/btrfs/extent-tree.c:8430:9: error: format not a string literal and no format arguments [-Werror=format-security]
>>>>>             get_raid_name(index));
>>
>> This comes from the btrfs-next tree, with Jeff's sysfs patches, so I've
>> added Jeff.

Ah, found it:
http://git.kernel.org/cgit/linux/kernel/git/josef/btrfs-next.git/tree/fs/btrfs/extent-tree.c

>
> Thanks for the heads up. I have a few other fixes that need to go into
> that patch set WRT cleanup too.

It looks like gcc is being stupid (const strings again). If you don't
want to change the call from

kobject_init_and_add(..., get_raid_name(index));

to

kobject_init_and_add(..., "%s", get_raid_name(index));

that's fine -- I can whitelist it since it's a string constant. But
since it's not critical path, it would be nice to gain the "%s" just
to be defensive if get_raid_name ever changes, etc.

Thanks for taking a look!

-Kees

-- 
Kees Cook
Chrome OS Security
