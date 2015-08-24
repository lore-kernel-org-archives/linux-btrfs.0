Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35893 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbbHXNnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 09:43:47 -0400
Received: by igcse8 with SMTP id se8so47196717igc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Aug 2015 06:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtFHURyckNtbeq0ifwSL6-53+x2M+3_2FcxJ6iCAVsHx-H8hQ@mail.gmail.com>
References: <CAJtFHUQukRC9m+Bq85CN7v_tCk6ybGvParax5ixcMJwKHRUFCQ@mail.gmail.com>
	<55D546C5.7000202@oracle.com>
	<CAJtFHURyckNtbeq0ifwSL6-53+x2M+3_2FcxJ6iCAVsHx-H8hQ@mail.gmail.com>
Date: Mon, 24 Aug 2015 09:43:47 -0400
Message-ID: <CAJtFHUSrHBmW_vfucKTJ2igOP_K3QmcdMHN0+K1eqCV6qzx-ZA@mail.gmail.com>
Subject: Re: Kernel 4.1.4 btrfs forced read-only during rsync
From: E V <eliventer@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, unmounted the filesystem and it checked clean:
# btrfs check /dev/sdd
Checking filesystem on /dev/sdd
UUID: 550c0f77-8f75-40f3-a64e-42c87a0c8e8d
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 116808409085477 bytes used err is 0
total csum bytes: 113927723420
total tree bytes: 146420203520
total fs tree bytes: 19490373632
total extent tree bytes: 6762332160
btree space waste bytes: 9826655374
file data blocks allocated: 117763247816704
 referenced 121374972489728
btrfs-progs v4.1.2

mounted again no problems, deleted a couple of snapshots to make it
free something and now rsync is running again fine.

On Thu, Aug 20, 2015 at 10:07 AM, E V <eliventer@gmail.com> wrote:
> Thanks for looking, let me know if you need any other info. I haven't
> touched the system yet, but it appears I'll need to unmount to btrfs
> check or mount rw,recovery to try and get it working again. Who knows
> what will happen then? I can leave it as if for a few days if it will
> help any diagnosis. Thanks again.
>
> On Wed, Aug 19, 2015 at 11:17 PM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>> two to dig more..
>>
>>> Aug 16 04:41:31 [1082957.226817] BTRFS: error (device sdb) in
>>> __btrfs_free_extent:6235: errno=-28 No space left
>>> Aug 16 04:41:31 [1082957.226819] BTRFS info (device sdb): forced readonly
>>
>>
>> ::
>>
>>> Aug 16 04:41:31 [1082957.289289] BTRFS: error (device sdb) in
>>> cleanup_transaction:1692: errno=-5 IO failure
>>
>>
>> 1.
>>  We probably need to understand what kicked in readonly. is it
>>  -28 (No space left) OR -5 (EIO).
>>
>> 2.
>>  There are no media errors from the block layer, hope we are not
>>  fabricating the EIO in the FS layer... thats wrong.
>>
>> digging more.
>>
>> Thanks,  Anand
