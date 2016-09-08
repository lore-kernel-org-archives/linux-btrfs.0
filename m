Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41219 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S966061AbcIHREC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Sep 2016 13:04:02 -0400
Subject: Re: [PULL] Btrfs fixes for 4.8-rc
To: David Sterba <dsterba@suse.com>
References: <cover.1473353605.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <8ce5deed-19e1-3bda-03ad-b6da29d0c2d7@fb.com>
Date: Thu, 8 Sep 2016 13:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1473353605.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/08/2016 12:57 PM, David Sterba wrote:
> Hi,
>
> here are two fixups for the new space handling code introduced in 4.8.
> Please pull.
>
> ----------------------------------------------------------------
> The following changes since commit cb887083d084d74421ae7bb18acca40568da791f:
>
>   Merge tag 'for-chris' of git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux into for-linus-4.8 (2016-09-01 17:29:34 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris
>
> for you to fetch changes up to ce129655c9d9aaa7b3bcc46529db1b36693575ed:
>
>   btrfs: introduce tickets_id to determine whether asynchronous metadata reclaim work makes progress (2016-09-06 16:31:43 +0200)
>
> ----------------------------------------------------------------
> Wang Xiaoguang (2):
>       btrfs: do not decrease bytes_may_use when replaying extents
>       btrfs: introduce tickets_id to determine whether asynchronous metadata reclaim work makes progress

Thanks Dave, I pulled these yesterday along with my list_del_init for 
the logging code.  Testing is looking good so far, so I expect to send 
to Linus on Friday.

-chris

