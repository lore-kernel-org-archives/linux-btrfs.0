Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57634 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936130AbdLSLYW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 06:24:22 -0500
Subject: Re: [RFC PATCH] btrfs: qgroup: Deprecate the ability to manually
 inherit rfer/excl numbers
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20171219104511.3563-1-wqu@suse.com>
 <1dbba47b-2f03-2a65-1384-ba45bc6bc403@suse.com>
 <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4a576fea-4245-702e-01a8-09d5ac359509@suse.com>
Date: Tue, 19 Dec 2017 13:24:20 +0200
MIME-Version: 1.0
In-Reply-To: <7d8cd1a8-fa0f-7b7a-f06b-ccc714b4e42e@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.12.2017 13:20, Qu Wenruo wrote:
> Naming like pad1/2 will make the check in btrfs_qgroup_inherit() look
> quite weird.
> 
> Although I don't have any better idea, so I'm mostly fine with such rename.

Right, I saw the check now, missed it the first time. I think we should
remove it and the code should completely ignore these values. Ideally,
we would have removed them from qgroup_inherit struct as well but this
means breaking the on-disk format. So let's ignore them altogether.

> 
> Thanks,
