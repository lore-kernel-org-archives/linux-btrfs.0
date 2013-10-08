Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab3JHPGw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 11:06:52 -0400
Date: Tue, 8 Oct 2013 17:06:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 02/12] Btrfs-progs: introduces '-p' option to print
 the ID of the parent qgroups
Message-ID: <20131008150637.GC4322@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
 <1381130508-8458-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381130508-8458-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 03:21:38PM +0800, Wang Shilong wrote:
> +static void print_parent_column(struct btrfs_qgroup *qgroup)
> +{
> +	struct btrfs_qgroup_list *list = NULL;
> +
> +	list_for_each_entry(list, &qgroup->qgroups, next_qgroup) {
> +		printf("%llu/%llu", (list->qgroup)->qgroupid >> 48,
> +		      ((1ll << 48) - 1) & (list->qgroup)->qgroupid);

Please use a wrapper for the >> 48 calculations everywhere (another
patch).

thanks,
david
