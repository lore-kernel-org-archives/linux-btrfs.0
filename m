Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaACRwL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jan 2014 12:52:11 -0500
Message-ID: <52C6F8C7.9080902@redhat.com>
Date: Fri, 03 Jan 2014 11:52:07 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] btrfs: Add missing pairing mount options.
References: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1388729434-19799-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/3/14, 12:10 AM, Qu Wenruo wrote:
> Some options should be paired to support triggering different functions
> when remounting.
> 
> This patchset add these missing pairing mount options.

I think this really would benefit from a regression test which
ensures that every remount transition works properly...

Thanks,
-Eric

> changelog:
> v1: Initial commit with only barrier option
> v2: Add other missing pairing options
> 
> Qu Wenruo (11):
>   btrfs: Add "barrier" option to support "-o remount,barrier"
>   btrfs: Add noautodefrag mount option.
>   btrfs: Add nocheck_int mount option.
>   btrfs: Add nodiscard mount option.
>   btrfs: Add noenospc_debug mount option.
>   btrfs: Add noflushoncommit mount option.
>   btrfs: Add noinode_cache mount option.
>   btrfs: Add acl mount option.
>   btrfs: Add datacow mount option.
>   btrfs: Add datasum mount option.
>   btrfs: Add treelog mount option.
> 
>  Documentation/filesystems/btrfs.txt | 56 ++++++++++++++++++----------
>  fs/btrfs/super.c                    | 74 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 110 insertions(+), 20 deletions(-)
> 

