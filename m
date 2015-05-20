Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38091 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbbETIDX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 May 2015 04:03:23 -0400
Received: by wichy4 with SMTP id hy4so50260905wic.1
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2015 01:03:21 -0700 (PDT)
In-Reply-To: <555BD45F.6070509@cn.fujitsu.com>
References: <1431508536-7275-1-git-send-email-quwenruo@cn.fujitsu.com> <1431508536-7275-5-git-send-email-quwenruo@cn.fujitsu.com> <20150513161823.GQ23255@twin.jikos.cz> <CALOYprV-dyji_5UFm3K-qmw0K2i5u7d14rwX7OPMFS29aY9ZVA@mail.gmail.com> <555BD45F.6070509@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to avoid btrfs-progs crash.
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
Date: Wed, 20 May 2015 09:03:07 +0100
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        lukas.lueg@gmail.com
Message-ID: <DE5D4407-6728-453E-92F9-534EA0944635@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20 May 2015 01:25:03 BST, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>Yes, I also find the problem and already sent the fixing patch:
>https://patchwork.kernel.org/patch/6411191/
>
>The problem is that my previous check patch is too restrict, making DUP
>
>chunk with only 1 stripe invalid.
>
>Fixing patch will allow degraded chunk to exist and fix the bug.
>
>Thanks,
>Qu
>
>-------- Original Message  --------
>Subject: Re: [PATCH 4/4] btrfs-progs: Add extra chunk item check to 
>avoid btrfs-progs crash.
>From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
>To: David Sterba <dsterba@suse.cz>, Qu Wenruo
><quwenruo@cn.fujitsu.com>, 
>linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>, 
><lukas.lueg@gmail.com>
>Date: 2015年05月20日 00:30
>
>> Hi guys,
>>
>> Following a bisect, it appears that this patch breaks fsck test 006:
>>
>> $ git checkout f146c40c65e0142b52418a0a1cbaf2808e658d76
>> HEAD is now at f146c40... btrfs-progs: Add extra chunk item check to
>> avoid btrfs-progs crash.
>> ...autogen, configure, make..
>> $ make test-fsck
>>      [TEST]   fsck-tests.sh
>>      [TEST]   001-bad-file-extent-bytenr
>>      [TEST]   002-bad-transid
>> parent transid verify failed on 29360128 wanted 9 found 755944791
>> parent transid verify failed on 29360128 wanted 9 found 755944791
>> Ignoring transid failure
>>      [TEST]   003-shift-offsets
>>      [TEST]   004-no-dir-index
>>      [TEST]   005-bad-item-offset
>>      [TEST]   006-bad-root-items
>> failed: /home/wormzy/btrfs-progs-unstable/btrfs check --repair
>test.img
>> test failed for case 006-bad-root-items
>> Makefile:169: recipe for target 'test-fsck' failed
>> make: *** [test-fsck] Error 1
>>
>> Does this test just need updating?
>>
>> Cheers,
>>
>>
>> WorMzy
>>
>> On 13 May 2015 at 17:18, David Sterba <dsterba@suse.cz
>> <mailto:dsterba@suse.cz>> wrote:
>>
>>     On Wed, May 13, 2015 at 05:15:36PM +0800, Qu Wenruo wrote:
>>     > Adds extra check when reading a chunk item:
>>     > 1) Check chunk type.
>>     > Don't allow any unsupported type/profile bit.
>>     >
>>     > 2) Check num_stripes
>>     > Any chunk item should contain at least one stripe.
>>     > For system chunk, the chunk item size(calculated by
>btrfs_stripe size *
>>     > (num_stripes - 1) + btrfs_chunk size) should not exceed
>>     > BTRFS_SYSTEM_CHUNK_SIZE(2048).
>>     > For normal chunk, the chunk item size(calculated) should match
>the chunk
>>     > item size.
>>     >
>>     > 3) Check num_stripes/sub_stripes against chunk profile.
>>     > Num_stripes/sub_stripes must meet its lower limit for its chunk
>profile.
>>     >
>>     > Reported-by: Lukas Lueg <lukas.lueg@gmail.com
><mailto:lukas.lueg@gmail.com>>
>>     > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com
><mailto:quwenruo@cn.fujitsu.com>>
>>
>>     Applied, thanks.
>>     --
>>     To unsubscribe from this list: send the line "unsubscribe
>>     linux-btrfs" in
>>     the body of a message to majordomo@vger.kernel.org
>>     <mailto:majordomo@vger.kernel.org>
>>     More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>>

Thanks Qu, I missed that patch. 

Cheers, 


WorMzy 
