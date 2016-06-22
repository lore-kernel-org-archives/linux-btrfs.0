Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57630 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbcFVHQT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 03:16:19 -0400
Date: Tue, 21 Jun 2016 23:24:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix disk_i_size update bug when fallocate() fails
Message-ID: <20160622062403.GA16380@infradead.org>
References: <1466560621-18133-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466560621-18133-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 22, 2016 at 09:57:01AM +0800, Wang Xiaoguang wrote:
> And below test case can reveal this bug:

Please wire this up for xfstests, thanks!
