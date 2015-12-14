Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbbLNQzl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 11:55:41 -0500
Date: Mon, 14 Dec 2015 17:53:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Enhance chunk validation check
Message-ID: <20151214165337.GN4227@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1449565522-7736-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449565522-7736-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 05:05:22PM +0800, Qu Wenruo wrote:
> +#define IS_ALIGNED(x, a)                (((x) & ((typeof(x))(a) - 1)) == 0)
> +

> +static inline int is_power_of_2(unsigned long n)
> +{
> +	return (n != 0 && ((n & (n - 1)) == 0));
> +}

Please move them to kerncompat.h
