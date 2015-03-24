Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54014 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbbCXOB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Mar 2015 10:01:57 -0400
Date: Tue, 24 Mar 2015 15:01:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: Re: [PATCH] btrfs: explicitly set control file's private_data
Message-ID: <20150324140155.GU20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1427132053-410-1-git-send-email-tomvanbraeckel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1427132053-410-1-git-send-email-tomvanbraeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 23, 2015 at 06:34:13PM +0100, Tom Van Braeckel wrote:
> The private_data member of the Btrfs control device file
> (/dev/btrfs-control) is used to hold the current transaction and needs
> to be initialized to NULL to signify that no transaction is in progress.
> 
> We explicitly set the control file's private_data to NULL to be
> independent of whatever value the misc subsystem initializes it to.
> 
> Backstory:
> ----------
> 
> The misc subsystem (which is used by /dev/btrfs-control) initializes
> a file's private_data to point to the misc device when a driver has
> registered a custom open file operation and initializes it to NULL
> when a custom open file operation has *not* been provided.
> 
> This subtle quirk is confusing, to the point where kernel code registers
> *empty* file open operations to have private_data point to the misc
> device structure.
> 
> And it leads to bugs, where the addition or removal of a custom open
> file operation surprisingly changes the initial contents of a file's
> private_data structure.
> 
> To simplify things in the misc subsystem, a patch [1] has been proposed
> to *always* set private_data to point to the misc device instead of
> only doing this when a custom open file operation has been registered.
> 
> But before we can fix this in the misc subsystem itself, we need to
> modify the (few) drivers that rely on this very subtle behavior.
> 
> [1] https://lkml.org/lkml/2014/12/4/939
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> Signed-off-by: Tom Van Braeckel <tomvanbraeckel@gmail.com>

Thanks for the explanation.

Acked-by: David Sterba <dsterba@suse.cz>

> +static int btrfs_control_open(struct inode *inode, struct file *file)
> +{
> +	/* The control file's private_data is used to hold the
> +	 * transaction when it is started and is used to keep
> +	 * track of whether a transaction is already in progress.
> +	 */

That's not the common comment style (newline after /* ) but I'm never
sure whether I should nitpick about such things or just say yes to
fixes.

> +	file->private_data = NULL;
> +	return 0;
> +}
