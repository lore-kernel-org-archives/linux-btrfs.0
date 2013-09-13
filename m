Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932301Ab3IMNHj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Sep 2013 09:07:39 -0400
Message-ID: <52330E18.5040405@redhat.com>
Date: Fri, 13 Sep 2013 09:07:36 -0400
From: Ric Wheeler <rwheeler@redhat.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs
References: <20130912153629.16487.88969@localhost.localdomain>
In-Reply-To: <20130912153629.16487.88969@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/2013 11:36 AM, Chris Mason wrote:
> Mark Fasheh's offline dedup work is also here.  In this case offline
> means the FS is mounted and active, but the dedup work is not done
> inline during file IO.   This is a building block where utilities  are
> able to ask the FS to dedup a series of extents.  The kernel takes
> care of verifying the data involved really is the same.  Today this
> involves reading both extents, but we'll continue to evolve the patches.

Nice feature!

Just a note, the "offline" label is really confusing. In other storage products, 
they typically call this "out of band" since you are online but not during the 
actual write in a synchronous way :)

Ric


