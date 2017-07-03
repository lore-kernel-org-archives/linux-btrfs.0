Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34329 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753581AbdGCJuZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 05:50:25 -0400
Received: by mail-qk0-f194.google.com with SMTP id 91so23247883qkq.1
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Jul 2017 02:50:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1a0c4fe6-517a-49f3-2873-61797bc9d818@gmail.com>
References: <20170616014323.13170-1-quwenruo@cn.fujitsu.com> <1a0c4fe6-517a-49f3-2873-61797bc9d818@gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Mon, 3 Jul 2017 11:50:23 +0200
Message-ID: <CAPmG0jYX1aCK7B68kuSZiMFqsR3Rk9XmeN+Wiyrn-O5o0mhAvQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] btrfs-progs: Fix false alert about EXTENT_DATA
 shouldn't be hole
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: dsterba@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 19, 2017 at 1:26 PM, Henk Slager <eye1tm@gmail.com> wrote:
> On 16-06-17 03:43, Qu Wenruo wrote:
>> Since incompat feature NO_HOLES still allow us to have explicit hole
>> file extent, current check is too restrict and will cause false alert
>> like:
>>
>> root 5 EXTENT_DATA[257, 0] shouldn't be hole
>>
>> Fix it by removing the restrict hole file extent check.
>>
>> Reported-by: Henk Slager <eye1tm@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>  cmds-check.c | 6 +-----
>>  1 file changed, 1 insertion(+), 5 deletions(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index c052f66e..7bd57677 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -4841,11 +4841,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_key *fkey,
>>       }
>>
>>       /* Check EXTENT_DATA hole */
>> -     if (no_holes && is_hole) {
>> -             err |= FILE_EXTENT_ERROR;
>> -             error("root %llu EXTENT_DATA[%llu %llu] shouldn't be hole",
>> -                   root->objectid, fkey->objectid, fkey->offset);
>> -     } else if (!no_holes && *end != fkey->offset) {
>> +     if (!no_holes && *end != fkey->offset) {
>>               err |= FILE_EXTENT_ERROR;
>>               error("root %llu EXTENT_DATA[%llu %llu] interrupt",
>>                     root->objectid, fkey->objectid, fkey->offset);
>
>
> Thanks for the patch, I applied it on v4.11 btrfs-progs and re-ran the check:
> # btrfs check -p --readonly /dev/mapper/smr
While looking at new kernel+progs releases  and my script logs, I see
I made copy-paste error; of course it is the lowmem mode:
# btrfs check -p --mode lowmem --readonly /dev/mapper/smr
> on filesystem mentioned in:
> https://www.spinics.net/lists/linux-btrfs/msg66374.html
>
> and now the "shouldn't be hole" errors don't show up anymore.
>
> Tested-by: Henk Slager <eye1tm@gmail.com>
>
