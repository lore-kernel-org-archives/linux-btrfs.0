Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59090 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757640Ab3A1SF1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 13:05:27 -0500
Date: Mon, 28 Jan 2013 19:04:29 +0100
From: David Sterba <dave@jikos.cz>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net, miaox@cn.fujitsu.com
Subject: Re: [PATCH 05/10] Btrfs-progs: add function btrfs_get_subvol to get
 root_info of a subvol
Message-ID: <20130128180429.GB16594@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-1-git-send-email-anand.jain@oracle.com>
 <1359350559-25671-6-git-send-email-anand.jain@oracle.com>
 <5107531E.8060708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5107531E.8060708@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 28, 2013 at 08:42:06PM -0800, Wang Shilong wrote:
> > +	rbn = rb_first(&rl.root);
> > +	while(rbn) {
> > +		ri = rb_entry(rbn, struct root_info, rb_node);
> > +		resolve_root(&rl, ri, root_id);
>      
>   Here subvolume/snapshot deletion may happen,add a check here...
>   if resolve_root return -ENOENT..it means deletion happens...
> 
>   ret = reslove_root(&rl, ri, root_id);
>   if (ret)
>       goto again;
> 
[...]
>                    
>  again???
> > +		rbn = rb_next(rbn);
> > +	}

Then it looks like a for (...) { } pattern with 'continue' instead of
'goto'.

david
