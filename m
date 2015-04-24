Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755052AbbDXPYa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Apr 2015 11:24:30 -0400
Date: Fri, 24 Apr 2015 17:24:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: David Sterba <dsterba@suse.cz>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/3] btrfs-progs: separate the overwrite check.
Message-ID: <20150424152428.GS4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <55392221.6090502@gmail.com>
 <55392315.8040306@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55392315.8040306@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 12:51:33PM -0400, Dan Merillat wrote:
> +/* returns:
> + *  0 if the file exists and should be skipped.
> + *  1 if the file does NOT exist
> + *  2 if the file exists but is OK to overwrite
> + */
> +
> +static int overwrite_ok(const char * path)
> +{
> +	static int warn = 0;
> +	struct stat st;
> +	int ret;
> +
> +	/* don't be fooled by symlinks */
> +	ret = fstatat(-1, path_name, &st, AT_SYMLINK_NOFOLLOW);

Is the filedescriptor -1 correct? Previously, stat was used that uses
AT_FDCWD for the dirfd, which is -100. -1 could be intepreted as a bad
filedescriptor (EBADF).
