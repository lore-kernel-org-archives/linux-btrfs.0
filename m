Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:28840 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab3K2Fkz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 00:40:55 -0500
Message-ID: <529828D7.40109@cn.fujitsu.com>
Date: Fri, 29 Nov 2013 13:40:39 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Alin Dobre <alin.dobre@elastichosts.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Subvolume creation returns file exists
References: <528630D6.5090103@elastichosts.com> <5297147B.7030904@elastichosts.com>
In-Reply-To: <5297147B.7030904@elastichosts.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alin,

On 11/28/2013 06:01 PM, Alin Dobre wrote:
> It seems that the problem was that we didn't delete the corresponding 
> qgroup when deleting the subvolume, which was filling the metadata 
> with unused information. Removing all the stale qgroups fixes the 
> problem and allows subsequent subvolume creation without any quota 
> disable/enable action. Also, we are now automatically deleting the 
> corresponding qgroup after the subvolume is removed.
Until now,  we won't delete subvolume's corresponding qgroup 
automactiallly yet. The main reason is:

Deleting subvolume is 'async', we still need to make qgroup accounting 
correct(differ 'rfer' and 'excl').
In theory, we can only remove a qgroup safely when it's referenced goes 
0. This is the main reason
why we don't delete subvolume qgroup directly.

And the point is deleting subvolume won't walk the whole fs tree, and 
qgroup is dependent on this,
now, deleting subvolume may break qgroup accounting.(though qgroup 
rescan can make it right, we
can not rely on this so much).

Anyway, though we don't remove qgroup automactially, it should not 
affect subvolume creation
This is because qgroup is corresponding subvolume, it will not be resued 
since subvolumeid
is although going larger.

Thanks,
Wang
>
> Cheers,
> Alin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

