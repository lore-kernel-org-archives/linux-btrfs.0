Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5819 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445AbbIAT2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 15:28:33 -0400
Subject: Re: [PATCH 3/6] Btrfs: introduce the free space B-tree on-disk format
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1441131625.git.osandov@fb.com>
 <463b9e483192445e2fa0d258a2289f96b31018a3.1441131625.git.osandov@fb.com>
CC: Omar Sandoval <osandov@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55E5FC5D.2030701@fb.com>
Date: Tue, 1 Sep 2015 15:28:29 -0400
MIME-Version: 1.0
In-Reply-To: <463b9e483192445e2fa0d258a2289f96b31018a3.1441131625.git.osandov@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2015 03:02 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> The on-disk format for the free space tree is straightforward. Each
> block group is represented in the free space tree by a free space info
> item that stores accounting information: whether the free space for this
> block group is stored as bitmaps or extents and how many extents of free
> space exist for this block group (regardless of which format is being
> used in the tree). Extents are (start, FREE_SPACE_EXTENT, length) keys
> with no corresponding item, and bitmaps instead have the
> FREE_SPACE_BITMAP type and have a bitmap item attached, which is just an
> array of bytes.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
