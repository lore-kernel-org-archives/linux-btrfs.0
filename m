Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934542AbcJ1HWU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 03:22:20 -0400
Date: Fri, 28 Oct 2016 15:22:18 +0800
From: Eryu Guan <eguan@redhat.com>
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: make 17[1-4] work well when btrfs
 compression is enabled
Message-ID: <20161028072218.GH27776@eguan.usersys.redhat.com>
References: <20161026095211.30091-1-wangxg.fnst@cn.fujitsu.com>
 <20161027112527.GE27776@eguan.usersys.redhat.com>
 <5812F8D3.80109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5812F8D3.80109@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 28, 2016 at 03:05:55PM +0800, Wang Xiaoguang wrote:
> hi,
> 
> On 10/27/2016 07:25 PM, Eryu Guan wrote:
> > On Wed, Oct 26, 2016 at 05:52:11PM +0800, Wang Xiaoguang wrote:
> > > When enabling btrfs compression, original codes can not fill fs
> > > correctly, here we introduce _fill_fs() in common/rc, which'll keep
> > > creating and writing files until enospc error occurs. Note _fill_fs
> > > is copied from tests/generic/256, but with some minor modifications.
> > > 
> > > Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
> > Looks fine to me overall, generic/17[1-4] and generic/256 passed on xfs,
> > btrfs and btrfs with compress. But I'd like Darrick to review it as well :)
> Could you please give me your btrfs's kernel version?
> When enabling btrfs compression run these 4 test cases, I often got
> enospc error, it seems that you didn't run into enospc errors.

I'm using 4.9-rc1 kernel, with both test_dev and scratch_dev 15G in
size, btrfs-progs v4.6

Thanks,
Eryu
