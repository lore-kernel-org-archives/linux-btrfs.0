Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:20890 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3KFRVz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Nov 2013 12:21:55 -0500
Message-ID: <527A7A6F.7080407@jan-o-sch.net>
Date: Wed, 06 Nov 2013 18:20:47 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz, dustymabe@gmail.com
Subject: Re: [PATCH] Btrfs: fix negative qgroup tracking from owner accounting
 (bug #61951)
References: <1382620926-8513-1-git-send-email-list.btrfs@jan-o-sch.net> <20131104174230.GK16855@localhost.localdomain>
In-Reply-To: <20131104174230.GK16855@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 
On Mon, November 04, 2013 at 18:42 (+0100), Josef Bacik wrote:
> On Thu, Oct 24, 2013 at 03:22:06PM +0200, Jan Schmidt wrote:
>> btrfs_dec_ref() queued a delayed ref for owner of a tree block. The qgroup
>> tracking is based on delayed refs. The owner of a tree block is set when a
>> tree block is allocated, it is never updated.
>>
>> When you allocate a tree block and then remove the subvolume that did the
>> allocation, the qgroup accounting for that removal is correct. However, the
>> removal was accounted again for each subvolume deletion that also referenced
>> the tree block, because accounting was erroneously based on the owner.
>>
>> Instead of queueing delayed refs for the non-existent owner, we now
>> queue delayed refs for the root being removed. This fixes the qgroup
>> accounting.
>>
>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>> Tested-by: <dustymabe@gmail.com>
> 
> This breaks btrfs/003, I'm kicking it out.

Can you be a bit more specific? Works fine here.

-Jan
