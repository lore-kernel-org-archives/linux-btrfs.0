Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33290 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934058AbcKJQQw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 11:16:52 -0500
Subject: Re: [PATCH] f2fs: support multiple devices
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Andreas Dilger <adilger@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20161109205653.70061-1-jaegeuk@kernel.org>
 <0D1876A8-BB77-4C1A-BE4F-B4A0E81DD4EA@dilger.ca>
 <4ec4d8f2-da23-762d-ba81-12e76ed09793@cn.fujitsu.com>
 <749156c9-2b3e-4210-a89b-2d664f9d2fc2@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Lustre Development <lustre-devel@lists.lustre.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <b68b3de1-3036-fce6-b27c-dbf78e6469b8@oracle.com>
Date: Fri, 11 Nov 2016 00:19:12 +0800
MIME-Version: 1.0
In-Reply-To: <749156c9-2b3e-4210-a89b-2d664f9d2fc2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



(this is deviating from the subject, sorry about that)

>  Pretty much, if you're using just raid1 mode, without
> compression, on reasonable storage devices, things are rock-solid
> relative to the rest of BTRFS.

IMO, BTRFS volume manger feature is incomplete and there is RAID1
critical bug which affects availability, so its not suitable for 
enterprise solutions yet. However it should be fine in a setup
where dedicated sysadmin and maintenance downtime is a choice.
