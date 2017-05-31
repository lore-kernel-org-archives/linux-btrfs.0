Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdEaKJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 06:09:57 -0400
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com [209.85.223.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED6E623A0B
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 10:09:55 +0000 (UTC)
Received: by mail-io0-f173.google.com with SMTP id p24so13233455ioi.0
        for <linux-btrfs@vger.kernel.org>; Wed, 31 May 2017 03:09:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170530205057.GA11921@vader.DHCP.thefacebook.com>
References: <20170528163153.31962-1-fdmanana@kernel.org> <20170530205057.GA11921@vader.DHCP.thefacebook.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Wed, 31 May 2017 11:09:54 +0100
Message-ID: <CAL3q7H7RGod2ytegL3YnxJ=bbitsQg7UEC2kk_p7UuHzCuwwKA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix invalid extent maps due to hole punching
To: Omar Sandoval <osandov@osandov.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 30, 2017 at 9:50 PM, Omar Sandoval <osandov@osandov.com> wrote:
> On Sun, May 28, 2017 at 05:31:53PM +0100, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>
> [snip]
>
> Hey, Filipe,
>
> I saw this warning and tried to apply your patch, but it doesn't apply
> cleanly (seems to conflict with 9986277e0e4c ("Btrfs: handle only
> applicable errors returned by btrfs_get_extent")).

Yes, it was based on an older branch.
I'll rebase it. Thanks.

>
>> Fixes: d77815461f04 ("btrfs: Avoid trucating page or punching hole in a already existed hole.")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/file.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
>> index f7d022bc7998..2645d820422c 100644
>> --- a/fs/btrfs/file.c
>> +++ b/fs/btrfs/file.c
>> @@ -2390,10 +2390,12 @@ static int fill_holes(struct btrfs_trans_handle *trans,
>>   */
>>  static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
>>  {
>> +     struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
>>       struct extent_map *em;
>>       int ret = 0;
>>
>> -     em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start, *len, 0);
>> +     em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, *start,
>> +                           round_up(*len, fs_info->sectorsize), 0);
>>       if (IS_ERR_OR_NULL(em)) {
>>               if (!em)
>>                       ret = -ENOMEM;
>> --
>> 2.11.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
