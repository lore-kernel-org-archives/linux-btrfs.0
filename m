Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755518AbdCGPec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Mar 2017 10:34:32 -0500
Date: Tue, 7 Mar 2017 16:19:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com
Subject: Re: [PATCH 1/9] btrfs: qgroup: Add trace point for qgroup reserved
 space
Message-ID: <20170307151947.GU4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170227071039.8335-1-quwenruo@cn.fujitsu.com>
 <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170227071039.8335-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 27, 2017 at 03:10:31PM +0800, Qu Wenruo wrote:
> +TRACE_EVENT(qgroup_update_reserve,
...
> +	TP_printk_btrfs("qgid = %llu, cur_reserved = %llu, diff = %lld",
> +		__entry->qgid, __entry->cur_reserved, __entry->diff)

> +);
> +
> +TRACE_EVENT(qgroup_meta_reserve,
...
> +	TP_printk_btrfs("refroot = %llu, diff = %lld",
> +		__entry->refroot, __entry->diff)
> +);

Please update the format strings,
https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints
