Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:53949 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759214Ab3HMWbf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 18:31:35 -0400
Message-ID: <520AB3C1.7050805@sgi.com>
Date: Tue, 13 Aug 2013 17:31:29 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Jan Schmidt <list.xfs@jan-o-sch.net>, <sbehrens@giantdisaster.de>,
        <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH v4 0/2] xfstest btrfs/316: test send / receive
References: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net> <520A7BEC.3010301@sandeen.net>
In-Reply-To: <520A7BEC.3010301@sandeen.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/13/2013 01:33 PM, Eric Sandeen wrote:
> On 8/13/13 12:24 PM, Jan Schmidt wrote:
>> These two patches add the announced tests for btrfs send / receive. As
>> requested, the fssum tool is now included.
>
>
> Thanks for the updates.
>
> Both:
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>
Thanks Jan, this has been committed.

--Rich

commit af86f5668eb164d1db52d1bf65673ba51d6fc75a
Author: Jan Schmidt <list.xfs@jan-o-sch.net>
Date:   Tue Aug 13 17:24:18 2013 +0000

     xfstests btrfs/007: test send / receive

     Basic send / receive functionality test for btrfs. Requires current
     version of fsstress built (-x support). Relies on fssum tool but can
     skip the test if it failed to build.

     Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
     Reviewed-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     [rjohnston: renumbered test from 316 to 007]

commit df0fd18101b625aad690d4cd3bb4ba7e7d1d99dc
Author: Jan Schmidt <list.xfs@jan-o-sch.net>
Date:   Tue Aug 13 17:24:17 2013 +0000

     xfstests: add fssum tool

     fssum is a tool to build a recursive checksum for a file system. 
The home
     repository of fssum is

         git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git

     Signed-off-by: Jan Schmidt <list.xfs@jan-o-sch.net>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>



