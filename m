Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:47489 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3JHIlz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 04:41:55 -0400
Message-ID: <5253C552.7080609@giantdisaster.de>
Date: Tue, 08 Oct 2013 10:41:54 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 02/12] btrfs-progs: check fopen failure in cmds-send
References: <1381182185-10896-1-git-send-email-zab@redhat.com> <1381182185-10896-3-git-send-email-zab@redhat.com>
In-Reply-To: <1381182185-10896-3-git-send-email-zab@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon,  7 Oct 2013 14:42:55 -0700, Zach Brown wrote:
> Check for fopen() failure.  This shows up in static analysis as a
> possible null pointer derference.
> 
> Signed-off-by: Zach Brown <zab@redhat.com>
> ---
>  cmds-send.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/cmds-send.c b/cmds-send.c
> index 374d040..5f6ff86 100644
> --- a/cmds-send.c
> +++ b/cmds-send.c
> @@ -72,6 +72,11 @@ int find_mount_root(const char *path, char **mount_root)
>  	close(fd);
>  
>  	mnttab = fopen("/proc/mounts", "r");
> +	if (!mnttab) {
> +		close(fd);
> +		return -errno;

close() can modify errno.

And close(fd) is already called 4 lines above. You didn't run the static
code analysis again after applying your patch :)


> +	}
> +
>  	while ((ent = getmntent(mnttab))) {
>  		len = strlen(ent->mnt_dir);
>  		if (strncmp(ent->mnt_dir, path, len) == 0) {
> 


