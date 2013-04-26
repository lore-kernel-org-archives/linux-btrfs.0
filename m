Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516Ab3DZP3J (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 11:29:09 -0400
Date: Fri, 26 Apr 2013 17:29:06 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        wangshilong1991@gmail.com, dsterba@suse.cz
Subject: Re: [PATCH v4 3/3] Btrfs: automatic rescan after "quota enable"
 command
Message-ID: <20130426152906.GO16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366905892-7880-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366905892-7880-4-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366905892-7880-4-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 06:04:52PM +0200, Jan Schmidt wrote:
> @@ -1520,6 +1524,13 @@ int btrfs_run_qgroups(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
>  
> +	if (!ret && start_rescan_worker) {
> +		ret = btrfs_qgroup_rescan(fs_info);
> +		if (ret)
> +			pr_err("btrfs: start rescan quota failed: %d\n", ret);

This will print the error even in the -EINPROGRESS case, that's not IMO
an error or worth reporting iff rescan is in progress.

It's probably a rare event, but even then, an ERROR syslog message
causes only false alerts.

> +		ret = 0;
> +	}
> +
