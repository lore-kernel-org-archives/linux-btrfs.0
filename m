Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:13871 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965456Ab3HIJNw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 Aug 2013 05:13:52 -0400
Message-ID: <5204B278.4010506@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 17:12:24 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, sensille@gmx.net, miaox@cn.fujitsu.com
Subject: Re: [PATCH 1/3] Btrfs: fix oops when writing dirty qgroups to disk
References: <1375852351-11919-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <20130808132033.GD16712@localhost.localdomain>
In-Reply-To: <20130808132033.GD16712@localhost.localdomain>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/08/2013 09:20 PM, Josef Bacik wrote:
> On Wed, Aug 07, 2013 at 01:12:29PM +0800, Wang Shilong wrote:
>> When disabling quota, we should clear out list 'dirty_qgroups',otherwise,
>> we will get oops if enabling quota again. Fix this by abstracting similar
>> code from del_qgroup_rb().
>>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> 
> Can we get an xfstest for this, or at the very least a generic xfstest to
> exercise qgroups in general so I can be sure all these qgroup patches I take
> don't cause regressions?  Thanks,

Yeah, we have a test suite ourself for btrfs qgroup, and i wil change it integrated into
xfstest later.

Thanks,
Wang
> 
> Josef
> 

