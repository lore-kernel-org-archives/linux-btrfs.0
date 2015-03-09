Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38316 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbbCIPio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Mar 2015 11:38:44 -0400
Date: Mon, 9 Mar 2015 16:38:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        bo.li.liu@oracle.com, Eryu Guan <guaneryu@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs oops while mounting fuzzed btrfs image
Message-ID: <20150309153841.GF5841@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150305070933.GB17015@dhcp-13-216.nay.redhat.com>
 <20150305094611.GA4147@localhost.localdomain>
 <20150305101354.GC17015@dhcp-13-216.nay.redhat.com>
 <20150305102701.GE4147@localhost.localdomain>
 <54F90937.70309@cn.fujitsu.com>
 <20150306100113.GA26485@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150306100113.GA26485@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 06, 2015 at 02:01:13AM -0800, Omar Sandoval wrote:
> +
> +		if (ret && btrfs_super_generation(disk_sb) < 10) {
> +			printk(KERN_WARNING "btrfs: super block crcs don't match, older mkfs detected\n");
> +			ret = 0;
> +		}

> I'm not sure that this is exactly what's happening with Eryu's image,
> but it's definitely an issue. I also don't know whether it's safe to get
> rid of that special case. It looks like it's needed for btrfs-progs
> before v3.12 (November 2013). Chris? David?

We might remove the special case in the future. The superblock checks
were enhanced so the low generation number does not let an otherwise
heavily damaged superblock.
