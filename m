From: Sankar P <sankar.curiosity@gmail.com>
Subject: Re: [PATCH] Spelling fix in btrfs code comment
Date: Mon, 18 May 2009 12:23:48 +0530
Message-ID: <108af1800905172353g5692d340g1c389fbec7116c10@mail.gmail.com>
References: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
	 <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	trivial@kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.0905111746100.22712@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2009 at 9:16 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Sat, 9 May 2009, Sankar P wrote:
>
>> Fix a trivial spelling error in a comment
>>
>> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
>>
>> ---
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index e496644..3e2c7c7 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_i=
nfo *info, u64 bytenr)
>> =A0}
>>
>> =A0/*
>> - * return the block group that contains teh given bytenr
>> + * return the block group that contains the given bytenr
>> =A0 */
>> =A0struct btrfs_block_group_cache *btrfs_lookup_block_group(
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0struct btrfs_fs_info *info,
>
> Appplied to trivial tree. If it has been already applied to btrfs pil=
eup,
> please let me know so that I could drop it.

This is now available in the btrfs tree and Linus' tree. Thanks.

>
> Thanks,
>
> --
> Jiri Kosina
> SUSE Labs
>

--
Sankar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
