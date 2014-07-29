Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbaG2N5E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 09:57:04 -0400
Date: Tue, 29 Jul 2014 15:57:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/4] btrfs-progs: Check fstype in find_mount_root()
Message-ID: <20140729135703.GU1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1406094457-3100-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1406094457-3100-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1406094457-3100-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 23, 2014 at 01:47:35PM +0800, Qu Wenruo wrote:
> --- a/utils.c
> +++ b/utils.c
> @@ -2390,6 +2390,9 @@ int lookup_ino_rootid(int fd, u64 *rootid)
>  	return 0;
>  }
>  
> +/* return 0 if a btrfs mount point if found
> + * return 1 if a mount point is found but not btrfs
> + * return <0 if something goes wrong */
>  int find_mount_root(const char *path, char **mount_root)
>  {
>  	FILE *mnttab;
> @@ -2397,6 +2400,7 @@ int find_mount_root(const char *path, char **mount_root)
>  	struct mntent *ent;
>  	int len;
>  	int ret;
> +	int not_btrfs;

    [CC]     utils.o
utils.c: In function ‘find_mount_root’:
utils.c:2342:6: warning: ‘not_btrfs’ may be used uninitialized in this function

I've initialized to 1 to fix it, no need to resend the patch.
