Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54286 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaDKRwA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 13:52:00 -0400
Received: by mail-lb0-f173.google.com with SMTP id p9so3759304lbv.18
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Apr 2014 10:51:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140411174923.GH29256@twin.jikos.cz>
References: <1396977943-12427-1-git-send-email-fdmanana@gmail.com>
	<20140411174923.GH29256@twin.jikos.cz>
Date: Fri, 11 Apr 2014 18:51:58 +0100
Message-ID: <CAL3q7H4pf5DW0D+xHNqodARuqedkGTrnDa9S33mBy7QTcMoUtA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: update btrfs_file_extent_inline_len to match
 kernel version
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 11, 2014 at 6:49 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Apr 08, 2014 at 06:25:43PM +0100, Filipe David Borba Manana wrote:
>> The following kernel commit changed the definition of the inline function
>> btrfs_file_extent_inline_len():
>>
>>     commit 514ac8ad8793a097c0c9d89202c642479d6dfa34
>>     Author: Chris Mason <clm@fb.com>
>>     Date:   Fri Jan 3 21:07:00 2014 -0800
>>
>>     Btrfs: don't use ram_bytes for uncompressed inline items
>>
>>     If we truncate an uncompressed inline item, ram_bytes isn't updated to reflect
>>     the new size.  The fixe uses the size directly from the item header when
>>     reading uncompressed inlines, and also fixes truncate to update the
>>     size as it goes.
>>
>> Not having this new definition implies that the restore tool might misbehave when
>> restoring files with an inline extent that got truncated on a kernel older than
>> release 3.14.
>
> FYI, I get a compilation error where one instance of
> btrfs_file_extent_inline_len lacks the slot parameter, fixed by
>
> --- a/cmds-check.c
> +++ b/cmds-check.c
> @@ -1166,7 +1166,7 @@ static int process_file_extent(struct btrfs_root *root,
>         extent_type = btrfs_file_extent_type(eb, fi);
>
>         if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -               num_bytes = btrfs_file_extent_inline_len(eb, fi);
> +               num_bytes = btrfs_file_extent_inline_len(eb, slot, fi);
>                 if (num_bytes == 0)
>                         rec->errors |= I_ERR_BAD_FILE_EXTENT;
>                 rec->found_size += num_bytes;
> ---

Thanks David.
Can you add it please?
I was using an older version of the integration branch.



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
