Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53999 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab2GRBEN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 21:04:13 -0400
Message-ID: <50060B74.7010706@cn.fujitsu.com>
Date: Wed, 18 Jul 2012 09:03:48 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] Btrfs: kill root from btrfs_is_free_space_inode
References: <1341919719-13825-1-git-send-email-liubo2009@cn.fujitsu.com> <1341919719-13825-2-git-send-email-liubo2009@cn.fujitsu.com> <20120717134342.GF11226@twin.jikos.cz>
In-Reply-To: <20120717134342.GF11226@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2012 09:43 PM, David Sterba wrote:

> On Tue, Jul 10, 2012 at 07:28:39PM +0800, Liu Bo wrote:
>> Since root can be fetched via BTRFS_I macro directly, we can save an args
>> for btrfs_is_free_space_inode().
> 
> I see a great opportunity to rename the function :) It does not cover
> just the free space inode anymore and it'll be more confusing with the
> btree inode case.
> 
> I don't have a better name than btrfs_is_special_inode, but am not
> completely satisfied.
> 


Hi David,

Seems that my patch's title is confusing you...

I made these patches to make this function return true if the inode is a free space inode
or an inode cache inode, but not the btree inode.

Or am I missing something? :)

thanks,
liubo

> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


