Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:40557 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751740AbdC0Am6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Mar 2017 20:42:58 -0400
Subject: Re: Qgroups are not applied when snapshotting a subvol?
To: Moritz Sichert <moritz+linux@sichert.me>, <linux-btrfs@vger.kernel.org>
References: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <279513f7-5297-cf2f-aa94-35bef1f674aa@cn.fujitsu.com>
Date: Mon, 27 Mar 2017 08:39:37 +0800
MIME-Version: 1.0
In-Reply-To: <4428fdc3-157a-a98e-8ca3-e3701c6c1c80@sichert.me>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/26/2017 06:03 AM, Moritz Sichert wrote:
> Hi,
>
> I tried to configure qgroups on a btrfs filesystem but was really surprised that when you snapshot a subvolume, the snapshot will not be assigned to the qgroup the subvolume was in.
>
> As an example consider the small terminal session in the attachment: I create a subvol A, assign it to qgroup 1/1 and set a limit of 5M on that qgroup. Then I write a file into A and eventually get "disk quota exceeded". Then I create a snapshot of A and call it B. B will not be assigned to 1/1 and writing a file into B confirms that no limits at all are imposed for B.
>
> I feel like I must be missing something here. Considering that creating a snapshot does not require root privileges this would mean that any user can just circumvent any quota and therefore make them useless.
>
> Is there a way to enforce quotas even when a user creates snapshots?
>

Yes, there is always method to attach the subvolume/snapshot to 
specified higher level qgroup.

Just use "btrfs subvolume snapshot -i 1/1".

Thanks,
Qu

>
> Moritz
>
>


