Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bay004-omc2s14.hotmail.com ([65.54.190.89]:55675 "EHLO
	BAY004-OMC2S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbaHAQiK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Aug 2014 12:38:10 -0400
Message-ID: <BAY172-W3107E205E3560A0B251803B0E70@phx.gbl>
From: Kyle Gates <kylegates@hotmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH] btrfs-progs: mkfs: remove experimental tag
Date: Fri, 1 Aug 2014 11:38:09 -0500
In-Reply-To: <1406809294-24702-1-git-send-email-dsterba@suse.cz>
References: <1406809294-24702-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



----------------------------------------
> From: dsterba@suse.cz
> To: linux-btrfs@vger.kernel.org
> CC: dsterba@suse.cz
> Subject: [PATCH] btrfs-progs: mkfs: remove experimental tag
> Date: Thu, 31 Jul 2014 14:21:34 +0200
>
> Make it consistent with kernel status and documentation.
>
> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
> mkfs.c | 5 ++---
> 1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/mkfs.c b/mkfs.c
> index 16e92221a547..538b6e6837b2 100644
> --- a/mkfs.c
> +++ b/mkfs.c
> @@ -1439,8 +1439,8 @@ int main(int ac, char **av)
> }
>
> /* if we are here that means all devs are good to btrfsify */
> - printf("\nWARNING! - %s IS EXPERIMENTAL\n", BTRFS_BUILD_VERSION);
> - printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
> + printf("%s\n", BTRFS_BUILD_VERSION);
> + printf("See http://btrfs.wiki.kernel.org for more\n\n");

The sentence/thought isn't complete. I was left thinking "more what?"
perhaps add: information, documentation

Thanks.
>
> dev_cnt--;
>
> @@ -1597,7 +1597,6 @@ raid_groups:
> label, first_file, nodesize, leafsize, sectorsize,
> pretty_size(btrfs_super_total_bytes(root->fs_info->super_copy)));
>
> - printf("%s\n", BTRFS_BUILD_VERSION);
> btrfs_commit_transaction(trans, root);
>
> if (source_dir_set) {
> --
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  