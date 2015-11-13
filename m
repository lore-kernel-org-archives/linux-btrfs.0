Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782AbbKMQvc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 11:51:32 -0500
Date: Fri, 13 Nov 2015 17:49:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs-progs: cleanup cmd_device_usage
Message-ID: <20151113164955.GP6445@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com>
 <0000e758dcc9eee7e01c6e19e417f2b393d9e42c.1447063147.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0000e758dcc9eee7e01c6e19e417f2b393d9e42c.1447063147.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 09, 2015 at 05:59:38PM +0800, Zhao Lei wrote:
> 1: Remove more_than_one variant, use iterator's value instead
> 2: Remove "out" mark, use break instead.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
