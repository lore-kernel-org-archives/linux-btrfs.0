Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:41122 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933030Ab3HNUA1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Aug 2013 16:00:27 -0400
Message-ID: <520BE1FF.10403@sgi.com>
Date: Wed, 14 Aug 2013 15:01:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: btrfs/002, another send regression test
References: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1376334802-18960-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/12/2013 02:13 PM, Josef Bacik wrote:
> This is a regression test for a problem we had where we'd assume we had created
> a directory if it only had subvols inside of it.  This was happening because
> subvols would have lower inode numbers than our current send progress because
> their inode numbers are based off of a different counter.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>   tests/btrfs/002     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/002.out |    2 +
>   tests/btrfs/group   |    1 +
>   3 files changed, 88 insertions(+), 0 deletions(-)
>   create mode 100755 tests/btrfs/002
>   create mode 100644 tests/btrfs/002.out

Thanks for the patch Josef, this has been committed:

commit 6ef348f857ee2912b034ab0148bab7cdb814c0e7
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Aug 12 19:13:22 2013 +0000

     xfstests: btrfs/008, another send regression test

     This is a regression test for a problem we had where we'd assume we 
had created
     a directory if it only had subvols inside of it.  This was 
happening because
     subvols would have lower inode numbers than our current send 
progress because
     their inode numbers are based off of a different counter.  Thanks,

     Signed-off-by: Josef Bacik <jbacik@fusionio.com>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>

     [rjohnston: renumbered test from 002 to 008]

