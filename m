Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56291 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3KVH43 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Nov 2013 02:56:29 -0500
Date: Fri, 22 Nov 2013 08:56:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, jbacik@fusionio.com
Subject: Re: [PATCH v4 2/3] btrfs-progs: fs show should handle if subvol(s)
 mounted
Message-ID: <20131122075627.GI5007@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1384514735-24761-1-git-send-email-anand.jain@oracle.com>
 <1384514735-24761-2-git-send-email-anand.jain@oracle.com>
 <20131120141856.GH5007@twin.jikos.cz>
 <528D7ED4.1000300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <528D7ED4.1000300@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 21, 2013 at 11:32:36AM +0800, Anand Jain wrote:
> On 11/20/2013 10:18 PM, David Sterba wrote:
> >On Fri, Nov 15, 2013 at 07:25:34PM +0800, Anand Jain wrote:
> >>  static int btrfs_scan_kernel(void *search)
> >>  {
> >>-	int ret = 0, fd;
> >>-	FILE *f;
> >>-	struct mntent *mnt;
> >>-	struct btrfs_ioctl_fs_info_args fs_info_arg;
> >>-	struct btrfs_ioctl_dev_info_args *dev_info_arg = NULL;
> >>-	struct btrfs_ioctl_space_args *space_info_arg;
> >>+	int ret = 0;
> >>  	char label[BTRFS_LABEL_SIZE];
> >>-
> >>-	f = setmntent("/proc/self/mounts", "r");
> >>-	if (f == NULL)
> >>-		return 1;
> >>-
> >>-	memset(label, 0, sizeof(label));
> >>-	while ((mnt = getmntent(f)) != NULL) {
> >>-		if (strcmp(mnt->mnt_type, "btrfs"))
> >>+	char mnt[BTRFS_PATH_NAME_MAX + 1];
> >>+	struct btrfs_ioctl_fslist *fslist;
> >>+	struct btrfs_ioctl_fslist *fslist_saved;
> >
> >     [CC]     cmds-send.o
> >cmds-filesystem.c: In function ‘btrfs_scan_kernel’:
> >cmds-filesystem.c:461:29: warning: variable ‘fslist_saved’ set but not used [-Wunused-but-set-variable]
> 
>  Thanks David. That was something for later todo which I missed.
>  sorry my mistake. Sent out v5.

Thanks, patch replaced.
