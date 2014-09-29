Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37340 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342AbaI2QX5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 12:23:57 -0400
Date: Mon, 29 Sep 2014 18:23:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2 3/4] btrfs: Rename and export __btrfs_set_prop to be
 called from running transaction
Message-ID: <20140929162356.GE11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <541BED3D.5020803@jp.fujitsu.com>
 <541BEDF8.7010009@jp.fujitsu.com>
 <541BEEC1.9030606@jp.fujitsu.com>
 <20140922120119.GK9715@twin.jikos.cz>
 <5423AE51.8060701@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5423AE51.8060701@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 25, 2014 at 02:55:29PM +0900, Satoru Takeuchi wrote:
> Since "__" prefix means static helper, rename __btrfs_set_prop() to
> btrfs_set_prop_trans.
> 
> Signed-off-by: Naohiro Aota <naota@elisp.net>
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
