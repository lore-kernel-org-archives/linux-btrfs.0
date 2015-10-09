Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34624 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbbJIUYK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Oct 2015 16:24:10 -0400
Received: by iow1 with SMTP id 1so103227511iow.1
        for <linux-btrfs@vger.kernel.org>; Fri, 09 Oct 2015 13:24:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1443641013-26765-1-git-send-email-rruede+git@gmail.com>
References: <1443641013-26765-1-git-send-email-rruede+git@gmail.com>
Date: Fri, 9 Oct 2015 21:24:10 +0100
Message-ID: <CAL3q7H7AYV_BEkT+_gg5qYK1Yvk=dMo9Xoi5cnZx97g=w7qKpQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix resending received snapshot with parent
From: Filipe Manana <fdmanana@gmail.com>
To: Robin Ruede <r.ruede@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Robin Ruede <rruede+git@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30, 2015 at 8:23 PM, Robin Ruede <r.ruede@gmail.com> wrote:
> This fixes a regression introduced by 37b8d27d between v4.1 and v4.2.
>
> When a snapshot is received, its received_uuid is set to the original
> uuid of the subvolume. When that snapshot is then resent to a third
> filesystem, it's received_uuid is set to the second uuid
> instead of the original one. The same was true for the parent_uuid.
> This behaviour was partially changed in 37b8d27d, but in that patch
> only the parent_uuid was taken from the real original,
> not the uuid itself, causing the search for the parent to fail in
> the case below.
>
> This happens for example when trying to send a series of linked
> snapshots (e.g. created by snapper) from the backup file system back to the original one.
>
> The following commands reproduce the issue in v4.2.1
> (no error in 4.1.6)
>
>     # setup three test file systems
>     for i in 1 2 3; do
>             truncate -s 50M fs$i
>             mkfs.btrfs fs$i
>             mkdir $i
>             mount fs$i $i
>     done
>     echo "content" > 1/testfile
>     btrfs su snapshot -r 1/ 1/snap1
>     echo "changed content" > 1/testfile
>     btrfs su snapshot -r 1/ 1/snap2
>
>     # works fine:
>     btrfs send 1/snap1 | btrfs receive 2/
>     btrfs send -p 1/snap1 1/snap2 | btrfs receive 2/
>
>     # ERROR: could not find parent subvolume
>     btrfs send 2/snap1 | btrfs receive 3/
>     btrfs send -p 2/snap1 2/snap2 | btrfs receive 3/
>
> Signed-off-by: Robin Ruede <rruede+git@gmail.com>
Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks for fixing this.
I've added this to my integration branch [1] and will send soon a pull
request to Chris for 4.4, including this fix plus a few others for
send/receive, after some more testing.

I've also made an xfstest for it [1, 2]

[1] http://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/log/?h=integration-4.3
[2] https://patchwork.kernel.org/patch/7363681/
[3] https://patchwork.kernel.org/patch/7363661/

> ---
>  fs/btrfs/send.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> index aa72bfd..890933b 100644
> --- a/fs/btrfs/send.c
> +++ b/fs/btrfs/send.c
> @@ -2351,8 +2351,14 @@ static int send_subvol_begin(struct send_ctx *sctx)
>         }
>
>         TLV_PUT_STRING(sctx, BTRFS_SEND_A_PATH, name, namelen);
> -       TLV_PUT_UUID(sctx, BTRFS_SEND_A_UUID,
> -                       sctx->send_root->root_item.uuid);
> +
> +       if (!btrfs_is_empty_uuid(sctx->send_root->root_item.received_uuid))
> +               TLV_PUT_UUID(sctx, BTRFS_SEND_A_UUID,
> +                           sctx->send_root->root_item.received_uuid);
> +       else
> +               TLV_PUT_UUID(sctx, BTRFS_SEND_A_UUID,
> +                           sctx->send_root->root_item.uuid);
> +
>         TLV_PUT_U64(sctx, BTRFS_SEND_A_CTRANSID,
>                     le64_to_cpu(sctx->send_root->root_item.ctransid));
>         if (parent_root) {
> --
> 2.6.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
