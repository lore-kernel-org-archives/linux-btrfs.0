Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2860 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbbDGPJe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 11:09:34 -0400
Message-ID: <5523F317.5010007@fb.com>
Date: Tue, 7 Apr 2015 11:09:11 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] fstests: regression test for btrfs file range cloning
References: <1427481068-27414-1-git-send-email-fdmanana@suse.com> <1427971769-13224-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1427971769-13224-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/02/2015 06:49 AM, Filipe Manana wrote:
> Test btrfs file range cloning with the same file as a source and
> destination.
>
> This tests a specific scenario where the extent layout of the file
> confused the clone ioctl implementation making it return -EEXIST to
> userspace. This issue was fixed by the following linux kernel patch:
>
>     Btrfs: fix range cloning when same inode used as source and destination
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
