Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752044AbcKRNye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 08:54:34 -0500
Subject: Re: [PATCH 3/3] Btrfs: remove unused code when creating and merging
 reloc trees
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1479461866-20162-1-git-send-email-fdmanana@kernel.org>
CC: Filipe Manana <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <d9bc9d30-daba-812c-19d4-9706ce801cea@fb.com>
Date: Fri, 18 Nov 2016 08:54:24 -0500
MIME-Version: 1.0
In-Reply-To: <1479461866-20162-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2016 04:37 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> In commit 5bc7247ac47c (Btrfs: fix broken nocow after balance) we started
> abusing the rtransid and otransid fields of root items from relocation
> trees to fix some issues with nodatacow mode. However later in commit
> ba8b0289333a (Btrfs: do not reset last_snapshot after relocation) we
> dropped the code that made use of those fields but did not remove
> the code that sets those fields.
>
> So just remove them to avoid confusion.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
