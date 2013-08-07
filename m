Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab3HGDtg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 23:49:36 -0400
Message-ID: <5201C3CC.8000303@redhat.com>
Date: Tue, 06 Aug 2013 22:49:32 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH 2/2] btrfs-progs: mark static & remove unused from non-kernel
 code
References: <52019C6D.9050308@redhat.com> <52019D5F.3070301@redhat.com>
In-Reply-To: <52019D5F.3070301@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/6/13 8:05 PM, Eric Sandeen wrote:
> Mark many functions as static, and remove any resulting dead code.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
...

Actually, what the heck was this (note, this patch was against kdave's integration tree):

> diff --git a/send-utils.c b/send-utils.c
> index 874f8a5..3d562a4 100644
> --- a/send-utils.c
> +++ b/send-utils.c
> @@ -255,15 +255,6 @@ static int btrfs_subvolid_resolve_sub(int fd, char *path, size_t *path_len,
>  	return 0;
>  }
>  
> -void subvol_uuid_search_add(struct subvol_uuid_search *s,
> -			    struct subvol_info *si)
> -{
> -	if (si) {
> -		free(si->path);
> -		free(si);
> -	}
> -}
> -

That code above came into being with "[PATCH v4 3/5] Btrfs-progs: use UUID tree for send/receive" -

 void subvol_uuid_search_add(struct subvol_uuid_search *s,
 			    struct subvol_info *si)
 {
-	int cnt;
-
-	tree_insert(&s->root_id_subvols, si, subvol_search_by_root_id);
-	tree_insert(&s->path_subvols, si, subvol_search_by_path);
-
-	cnt = count_bytes(si->uuid, BTRFS_UUID_SIZE, 0);
-	if (cnt != BTRFS_UUID_SIZE)
-		tree_insert(&s->local_subvols, si, subvol_search_by_uuid);
-	cnt = count_bytes(si->received_uuid, BTRFS_UUID_SIZE, 0);
-	if (cnt != BTRFS_UUID_SIZE)
-		tree_insert(&s->received_subvols, si,
-				subvol_search_by_received_uuid);
+	if (si) {
+		free(si->path);
+		free(si);
+	}
 }

is that, um, really as intended, or did something get misapplied somewhere?

-Eric
