Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbcBXNGs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 08:06:48 -0500
Date: Wed, 24 Feb 2016 14:06:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Alexander Fougner <fougner89@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: introduce inspect-internal dump-super
Message-ID: <20160224130635.GE23746@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456311154-32703-1-git-send-email-fougner89@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456311154-32703-1-git-send-email-fougner89@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 11:52:33AM +0100, Alexander Fougner wrote:
> The long-term plan is to merge the features of standalone tools
> into the btrfs binary, reducing the number of shipped binaries.

Applied, thanks.

> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -70,7 +70,8 @@ objects = ctree.o disk-io.o radix-tree.o extent-tree.o print-tree.o \
>  	  extent-cache.o extent_io.o volumes.o utils.o repair.o \
>  	  qgroup.o raid6.o free-space-cache.o list_sort.o props.o \
>  	  ulist.o qgroup-verify.o backref.o string-table.o task-utils.o \
> -	  inode.o file.o find-root.o free-space-tree.o help.o cmds-inspect-dump-tree.o
> +	  inode.o file.o find-root.o free-space-tree.o help.o \
> +	  cmds-inspect-dump-tree.o cmds-inspect-dump-super.o

the objects belong to cmds_objects but needed some further changes to
pass the specific objects to the standalone utilities.
