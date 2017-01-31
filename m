Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:56394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750809AbdAaJ4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 31 Jan 2017 04:56:24 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 27BA5200DC
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 09:54:44 +0000 (UTC)
Received: from mail-it0-f44.google.com (mail-it0-f44.google.com [209.85.214.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B0BC20225
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 09:54:42 +0000 (UTC)
Received: by mail-it0-f44.google.com with SMTP id c7so121348550itd.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jan 2017 01:54:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170131010245.GA2552@vader.DHCP.thefacebook.com>
References: <1485583592-25555-1-git-send-email-fdmanana@kernel.org> <20170131010245.GA2552@vader.DHCP.thefacebook.com>
From: Filipe Manana <fdmanana@kernel.org>
Date: Tue, 31 Jan 2017 09:54:41 +0000
Message-ID: <CAL3q7H73eY11AHb8Shy+JK4dLFKbPDRkSE0H_-padu+rJ+h_5w@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: bulk delete checksum items in the same leaf
To: Omar Sandoval <osandov@osandov.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 31, 2017 at 1:02 AM, Omar Sandoval <osandov@osandov.com> wrote:
> On Sat, Jan 28, 2017 at 06:06:32AM +0000, fdmanana@kernel.org wrote:
>> From: Filipe Manana <fdmanana@suse.com>
>>
>> Very often we have the checksums for an extent spread in multiple items
>> in the checksums tree, and currently the algorithm to delete them starts
>> by looking for them one by one and then deleting them one by one, which
>> is not optimal since each deletion involves shifting all the other items
>> in the leaf and when the leaf reaches some low threshold, to move items
>> off the leaf into its left and right neighbor leafs. Also, after each
>> item deletion we release our search path and start a new search for other
>> checksums items.
>>
>> So optimize this by deleting in bulk all the items in the same leaf that
>> contain checksums for the extent being freed.
>>
>> Signed-off-by: Filipe Manana <fdmanana@suse.com>
>> ---
>>  fs/btrfs/file-item.c | 28 +++++++++++++++++++++++++++-
>>  1 file changed, 27 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
>> index e97e322..d7d6d4a 100644
>> --- a/fs/btrfs/file-item.c
>> +++ b/fs/btrfs/file-item.c
>> @@ -643,7 +643,33 @@ int btrfs_del_csums(struct btrfs_trans_handle *trans,
>>
>>               /* delete the entire item, it is inside our range */
>>               if (key.offset >= bytenr && csum_end <= end_byte) {
>> -                     ret = btrfs_del_item(trans, root, path);
>> +                     int del_nr = 1;
>> +
>> +                     /*
>> +                      * Check how many csum items preceding this one in this
>> +                      * leaf correspond to our range and then delete them all
>> +                      * at once.
>> +                      */
>> +                     if (key.offset > bytenr && path->slots[0] > 0) {
>> +                             int slot = path->slots[0] - 1;
>> +
>> +                             while (slot >= 0) {
>> +                                     struct btrfs_key pk;
>> +
>> +                                     btrfs_item_key_to_cpu(leaf, &pk, slot);
>> +                                     if (pk.offset < bytenr ||
>> +                                         pk.type != BTRFS_EXTENT_CSUM_KEY ||
>> +                                         pk.objectid !=
>> +                                         BTRFS_EXTENT_CSUM_OBJECTID)
>> +                                             break;
>> +                                     path->slots[0] = slot;
>> +                                     del_nr++;
>> +                                     key.offset = pk.offset;
>> +                                     slot--;
>> +                             }
>> +                     }
>> +                     ret = btrfs_del_items(trans, root, path,
>> +                                           path->slots[0], del_nr);
>>                       if (ret)
>>                               goto out;
>>                       if (key.offset == bytenr)
>
> Hmm, this seems like the kind of operation that could use a helper.
> btrfs_del_item_range() or something like that, which takes the maximum
> key to delete. What do you think?

I think it's not necessary. This is a very simple and isolated case
with the specific pattern of iterating backwards and returning the
last valid key (first in the range to delete). Shall another very
similar case pop up, then it's ok (even though it's a very simple and
small logic).
