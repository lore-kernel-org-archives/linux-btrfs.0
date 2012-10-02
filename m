Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59491 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab2JBOZm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 10:25:42 -0400
Date: Tue, 2 Oct 2012 16:25:38 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
Message-ID: <20121002142538.GV14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Sep 24, 2012 at 04:02:59PM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -571,6 +571,7 @@ struct btrfs_path {
>  	unsigned int skip_locking:1;
>  	unsigned int leave_spinning:1;
>  	unsigned int search_commit_root:1;
> +	unsigned int shecantgoanyfarthercapt:1;

so you did not make it to LWN's quote of the week, can you please rename
it to something sensible?

thanks,
david
