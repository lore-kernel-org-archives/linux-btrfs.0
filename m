Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbcF1Fax (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jun 2016 01:30:53 -0400
Date: Tue, 28 Jun 2016 13:30:51 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: btrfs: Regression test for leaking data
 reserved space
Message-ID: <20160628053051.GX23649@eguan.usersys.redhat.com>
References: <20160628015451.13903-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160628015451.13903-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 28, 2016 at 09:54:51AM +0800, Qu Wenruo wrote:
> When btrfs hits EDQUOTA when reserving data space, it will leak already
> reserved data space.
> 
> This test case will check it by using more restrict enospc_debug mount
> option to trigger kernel warning at umount time.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>

Looks good to me. Tested on x86_64 and ppc64 hosts, x86_64 host failed
the test as expected, ppc64 host didn't though.

Reviewed-by: Eryu Guan <eguan@redhat.com>
