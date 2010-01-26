From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 4/4] btrfs: remove tree_search() in extent_map.c
Date: Tue, 26 Jan 2010 16:51:41 -0500
Message-ID: <20100126215141.GG2770@think>
References: <4B273299.5040309@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B273299.5040309@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 15, 2009 at 02:54:17PM +0800, Miao Xie wrote:
> This patch removes tree_search() in extent_map.c because it is not called by
> anything.

Thank you, I've queued this one up.

-chris
