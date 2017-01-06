Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44170 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752119AbdAFUr7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Jan 2017 15:47:59 -0500
Subject: Re: [Regression 4.7-rc1] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
To: Joseph Salisbury <joseph.salisbury@canonical.com>, <luke@dashjr.org>
References: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
CC: <luke-jr+git@utopios.org>, <jbacik@fb.com>, <dsterba@suse.com>,
        <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-btrfs@vger.kernel.org>, <1619918@bugs.launchpad.net>
From: Chris Mason <clm@fb.com>
Message-ID: <0ea8d8ad-b410-b81b-5732-b5d6beca1d10@fb.com>
Date: Fri, 6 Jan 2017 15:46:38 -0500
MIME-Version: 1.0
In-Reply-To: <a555bec3-f0c8-b973-52e0-02bc2e3b5b29@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/06/2017 12:22 PM, Joseph Salisbury wrote:
> Hi Luke,
>
> A kernel bug report was opened against Ubuntu [0].  This bug was fixed
> by the following commit in v4.7-rc1:
>
>
> commit 4c63c2454eff996c5e27991221106eb511f7db38
>
> Author: Luke Dashjr <luke@dashjr.org>
> Date:   Thu Oct 29 08:22:21 2015 +0000
>
>     btrfs: bugfix: handle FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in
> btrfs_ioctl
>
>
> However, this commit introduced a new regression.  With this commit
> applied, "btrfs fi show" no longer works and the btrfs snapshot
> functionality breaks.
>
>
>
> I was hoping to get your feedback, since you are the patch author.  Do
> you think gathering any additional data will help diagnose this issue,
> or would it be best to submit a revert request?

This is working for me, could you please include an strace of the problem?

Thanks!

-chris

