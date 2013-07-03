Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:53937 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3GCR0B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Jul 2013 13:26:01 -0400
Received: by mail-bk0-f53.google.com with SMTP id e11so213141bkh.40
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Jul 2013 10:26:00 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130703170959.GQ18204@twin.jikos.cz>
References: <1372593106-6593-1-git-send-email-fdmanana@gmail.com>
	<1372593106-6593-2-git-send-email-fdmanana@gmail.com>
	<20130703170959.GQ18204@twin.jikos.cz>
Date: Wed, 3 Jul 2013 18:25:59 +0100
Message-ID: <CAL3q7H6s-7Qk_CFXeSpb94YZUuDOTSDOBh6CjUcAUMYc4smtMA@mail.gmail.com>
Subject: Re: [PATCH 1/3] Btrfs-progs: add missing write check for mkfs
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 3, 2013 at 6:09 PM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Jun 30, 2013 at 12:51:44PM +0100, Filipe David Borba Manana wrote:
>> Assert that the write of the device tree root succeeds.
>> This verification is currently done for all other tree
>> roots, however it was missing for the device tree root.
>>
>> Would this tree root write fail, but all others succeed,
>> it would lead to a corrupted/incomplete btrfs filesystem.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> ---
>>  utils.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/utils.c b/utils.c
>> index 7b4cd74..43d93f1 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -381,6 +381,7 @@ int make_btrfs(int fd, const char *device, const char *label,
>>       btrfs_set_header_nritems(buf, nritems);
>>       csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>>       ret = pwrite(fd, buf->data, leafsize, blocks[4]);
>> +     BUG_ON(ret != leafsize);
>
> Please fix also the 2nd instance where the return value check is
> missing

Good catch, thanks. Adding it now.

>
>  344         btrfs_set_header_bytenr(buf, blocks[3]);
>  345         btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
>  346         btrfs_set_header_nritems(buf, nritems);
>  347         csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
>  348         ret = pwrite(fd, buf->data, leafsize, blocks[3]);
>  349
>  350         /* create the device tree */
>  351         memset(buf->data+sizeof(struct btrfs_header), 0,
>  352                 leafsize-sizeof(struct btrfs_header));
>
>>
>>       /* create the FS root */
>>       memset(buf->data+sizeof(struct btrfs_header), 0,
>
> Also, replacing the BUG_ON with something else would be nice of course.

If you don't mind, I would prefer to do that as a different patch,
since the BUG_ON() use is what is currently done everywhere in this
function at least.

thanks

>
> thanks,
> david



--
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
