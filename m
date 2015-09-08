Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754089AbbIHLwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Sep 2015 07:52:23 -0400
Date: Tue, 8 Sep 2015 13:51:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Sheng Yong <shengyong1@huawei.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: trival fix of __btrfs_set_acl error handling
Message-ID: <20150908115137.GA8891@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1441702002-109706-1-git-send-email-shengyong1@huawei.com>
 <55EEA159.5060306@cn.fujitsu.com>
 <55EEA428.4080006@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55EEA428.4080006@huawei.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2015 at 05:02:32PM +0800, Sheng Yong wrote:
> Hi, Qu
> 
> On 9/8/2015 4:50 PM, Qu Wenruo wrote:
> > Sheng Yong wrote on 2015/09/08 08:46 +0000:
> >> * If the allocation failed, don't free to free it, even though kfree
> >>    allows to free a NULL pointer.
> >> * If posix_acl_to_xattr() failed, cleanup the allocation and return
> >>    the error directly.
> > So, what's the point?
> > For me, I didn't see the pros of the change.
> > As kfree() allow NULL pointer, why not use it?
> In fact, there is no semantic changes. It's just because when I walk through
> the code, and find there is no need to call kfree(), and could be cleaned up.
> It's fine to keep as it is :)

I agree with Qu. In this case it's not performance critical and conforms
to the widely used pattern of single return point from branches.
However, the acl functions are not consistent in that respect. It's more
a matter of style that gets unified eventually.
