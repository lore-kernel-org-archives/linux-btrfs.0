Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36596 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbbB0Phi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Feb 2015 10:37:38 -0500
Date: Fri, 27 Feb 2015 16:37:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] btrfs-progs:correct the return value
Message-ID: <20150227153736.GD8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <1423563803-8996-2-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423563803-8996-2-git-send-email-yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 10, 2015 at 06:23:13PM +0800, Dongsheng Yang wrote:
> From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
> 
> the return values 12 and 13 are not used spectially except as
> return value. No description and definition about them. so I
> change them to generic errno
> 
> Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>

Applied, thanks.
