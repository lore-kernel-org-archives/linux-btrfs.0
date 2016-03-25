Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbcCYOEL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Mar 2016 10:04:11 -0400
Date: Fri, 25 Mar 2016 22:04:09 +0800
From: Eryu Guan <eguan@redhat.com>
To: fdmanana@kernel.org
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH v2] fstests: add btrfs test for fsync after snapshot
 deletion
Message-ID: <20160325140409.GB11419@eguan.usersys.redhat.com>
References: <1458839241-12379-1-git-send-email-fdmanana@kernel.org>
 <1458850116-991-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458850116-991-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 08:08:36PM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Test that if we delete a snapshot, delete its parent directory, create
> another directory with the same name as that parent and then fsync either
> the new directory or a file inside the new directory, the fsync succeeds,
> the fsync log is replayable and produces a correct result.
> 
> This is motivated by a bug that is fixed by the following patch for
> btrfs (linux kernel):
> 
>   Btrfs: fix unreplayable log after snapshot deletion and parent
>   re-creation
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Looks good to me, test failed on v4.5 kernel and passed with above patch
(and dependencies) applied .

Reviewed-by: Eryu Guan <eguan@redhat.com>
