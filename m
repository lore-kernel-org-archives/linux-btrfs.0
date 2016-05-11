Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbcEKJOf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 05:14:35 -0400
Subject: Re: About in-band dedupe for v4.7
To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160510221119.GD7633@wotan.suse.de>
 <23ec14b4-deb3-4294-348c-1f0e4a7db169@cn.fujitsu.com>
 <20160511025211.GF7633@wotan.suse.de>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <592df217-85a3-2b60-0dce-a3742686c4bc@cn.fujitsu.com>
Date: Wed, 11 May 2016 17:14:26 +0800
MIME-Version: 1.0
In-Reply-To: <20160511025211.GF7633@wotan.suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> Solve the hard problems first (dedupe with a disk backend, make in-memory
> perform), then come asking for inclusion of your feature. Again, this I
> would say about the patches regardless of whose name is on them.
> 	--Mark
>

David has already agreed on the idea to merge in-memory backend first.
And the original idea of BTRFS_DEBUG (I prefer to use independent 
Kconfig though) also comes from him.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/54704/focus=54784

We have also expressed the idea to merge in-memory dedupe backend frist 
in v9 patchset cover letter.

Thanks,
Qu




