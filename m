Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33322 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937727AbdEXIRi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 04:17:38 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH RFC] vfs: add mount umount logs
To: Colin Walters <walters@verbum.org>, linux-fsdevel@vger.kernel.org
References: <20170518100804.25538-1-anand.jain@oracle.com>
 <1495207039.1914347.982172864.5F2F81AA@webmail.messagingengine.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.com, quwenruo@cn.fujitsu.com
Message-ID: <7eef3d6b-38e1-b132-dfa2-0eae774c3ab8@oracle.com>
Date: Wed, 24 May 2017 16:20:54 +0800
MIME-Version: 1.0
In-Reply-To: <1495207039.1914347.982172864.5F2F81AA@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Thanks for comments.

> But that said, I find the log spam today from e.g. docker + devicemapper + xfs
> annoying, and switching to overlay2 fixed that as a side effect which is nice.
> Having overlay2 log would reintroduce that problem.

You are right, docker with overlay2 logs additional 6 lines during 
container run. Though originally I was thinking overlay logs are 
important, now I have to log only FS of type FS_REQUIRES_DEV. With this 
its just two lines, during docker run.

Added this to v2.

Thanks, Anand
