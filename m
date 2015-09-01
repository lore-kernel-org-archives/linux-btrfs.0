Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58352 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057AbbIATvS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Sep 2015 15:51:18 -0400
Subject: Re: [PATCH 6/6] Btrfs: add free space tree mount option
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
References: <cover.1441131625.git.osandov@fb.com>
 <508d5b51b22371362ee49047afbfe536bee8ce84.1441131625.git.osandov@fb.com>
CC: Omar Sandoval <osandov@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55E6015A.2070104@fb.com>
Date: Tue, 1 Sep 2015 15:49:46 -0400
MIME-Version: 1.0
In-Reply-To: <508d5b51b22371362ee49047afbfe536bee8ce84.1441131625.git.osandov@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/01/2015 03:05 PM, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> Now we can finally hook up everything so we can actually use free space
> tree. On the first mount with the free_space_tree mount option, the free
> space tree will be created and the FREE_SPACE_TREE read-only compat bit
> will be set. Any time the filesystem is mounted from then on, we will
> use the free space tree.
>
> Having both the free space cache and free space trees enabled is
> nonsense, so we don't allow that to happen. Since mkfs sets the
> superblock cache generation to -1, this means that the filesystem will
> have to be mounted with nospace_cache,free_space_tree to create the free
> space trees on first mount. Once the FREE_SPACE_TREE bit is set, the
> cache generation is ignored when mounting. This is all a little more
> complicated than would be ideal, but at some point we can presumably
> make the free space tree the default and stop setting the cache
> generation in mkfs.
>
> Signed-off-by: Omar Sandoval <osandov@fb.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

