Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51895 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3A1FT4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 00:19:56 -0500
Message-ID: <51060BF7.20000@oracle.com>
Date: Mon, 28 Jan 2013 13:26:15 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 10/10] Btrfs-progs: add show subcommand to subvol cli
In-Reply-To: <51025947.60208@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1359106239-20870-1-git-send-email-anand.jain@oracle.com>
 <1359106239-20870-11-git-send-email-anand.jain@oracle.com>
 <51025947.60208@giantdisaster.de>



Stefan,

  Thanks for the review.

> if (sv_id == BTRFS_FS_TREE_OBJECTID) {

oh yes.

> The common way to handle it is:
> static int cmd_subvol_show(int argc, char **argv)
> {
> 	int mntfd = -1;
> 	int fd = -1;
> 	char *mnt = NULL;
> 	char *fullpath = NULL;
>
> 	... everywhere, in case of errors, just goto out;
>
> 	mntfd = open...();
> 	if (mntfd < 0) {
> 		fprintf...
> 		goto out;
> 	}
>
> out:
> 	if (mntfd >= 0)
> 		close(mntfd);
> 	if (fd >= 0)
> 		close(fd);
> 	free(mnt);
> 	free(fullpath);
> 	return ret;
> }
>
> Wherever an error happens inside the function, just goto out. When the
> char pointers are not yet allocated, they are still NULL and thus
> ignored by free(). If open() failed or the files are not yet opened, the
> descriptors are still -1 and close() is not called.
>
> It's basically impossible to add errors if you do it like this :)
>

Looks cleaner. will get this.

Anand
