Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34514 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522AbaA1N4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 08:56:40 -0500
Message-ID: <52E7B707.4070707@fb.com>
Date: Tue, 28 Jan 2014 08:56:23 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: add test for btrfs incremental send data corruption
References: <1390873242-8723-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390873242-8723-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/27/2014 08:40 PM, Filipe David Borba Manana wrote:
> Btrfs incremental send had an issue where it would detect a non-existent
> file hole and then overwrite the file section that hole covers with zeroes,
> overriding file data that it shouldn't.
>
> The respective btrfs kernel patch that fixed this issue is titled:
>
>     Btrfs: fix send file hole detection leading to data corruption
>     (https://patchwork.kernel.org/patch/3544831/)
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
Thanks for this

Reviewed-by: Josef Bacik <jbacik@fb.com>

Josef
