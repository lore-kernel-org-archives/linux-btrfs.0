Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58898 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3JAOFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Oct 2013 10:05:50 -0400
Received: by mail-pb0-f54.google.com with SMTP id ro12so7158010pbb.41
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Oct 2013 07:05:49 -0700 (PDT)
Content-Type: text/plain; charset=GB2312
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could free
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20131001133919.GE18291@twin.jikos.cz>
Date: Tue, 1 Oct 2013 22:05:44 +0800
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Message-Id: <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com>
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On Sun, Sep 29, 2013 at 11:25:36PM +0800, Anand Jain wrote:
>> It needs a lot more information about the snapshots if
>> snapshot's life cycle has to be all auto managed by
>> scripts _some day_.  this patch is a step towards that.
>> 
>> This patch provides the size which would be freed
>> if the subvol/snapshot is deleted.
>> preview:
>> ---------------------
>> btrfs su show /btrfs/sv1
>> ::
>> 	Unshared space: 	89.09MiB
> 
> Useful information, but it takes time to calculate the number. The tree
> search ioctl has significant overhead and seeking all over the extent
> tree can be also lengthy. I've tried it on a random subvolume on a SSD
> disk and it's been running 10 minutes already, one cpu is at 100%.

No wonder Anand's approach is inefficient.In Anand's approach:

Search Every EXTENT_DATA
	Search every extent's refs in extent tree.

If we want to speed up this progress, i think we can split it into two parts:

1. First to search inline extent_data
2. Secondly search in extent tree to calculate (extent refs=1)

This will avoid n*n rather than n+n which is better¡­

Thanks,
Wang
> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

