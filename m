Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbaIVMBU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 08:01:20 -0400
Date: Mon, 22 Sep 2014 14:01:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 3/4] btrfs: export __btrfs_set_prop
Message-ID: <20140922120119.GK9715@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <541BED3D.5020803@jp.fujitsu.com>
 <541BEDF8.7010009@jp.fujitsu.com>
 <541BEEC1.9030606@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <541BEEC1.9030606@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 19, 2014 at 05:52:17PM +0900, Satoru Takeuchi wrote:
> @@ -99,7 +99,7 @@ find_prop_handler(const char *name,
>  	return NULL;
>  }
>  
> -static int __btrfs_set_prop(struct btrfs_trans_handle *trans,
> +int __btrfs_set_prop(struct btrfs_trans_handle *trans,

It's common for static helpers to use the __ prefix, but please drop it
for an exported function(s).
