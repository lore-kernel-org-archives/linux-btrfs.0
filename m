Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbcC3OUu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 10:20:50 -0400
Date: Wed, 30 Mar 2016 16:20:15 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: fix an error when using DUP on
 multidev fs
Message-ID: <20160330142015.GD27917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458834973-3199-1-git-send-email-dsterba@suse.com>
 <56F49A96.70808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56F49A96.70808@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 25, 2016 at 10:55:34AM +0900, Satoru Takeuchi wrote:
> To accept DUP on multidev fs, in addition to the following
> commit, we need to mark DUP as an allowed data/metadata
> profile.
> 
> commit 42f1279bf8e9 ("btrfs-progs: mkfs: allow DUP on multidev fs, only warn")
> 
> * actual result
> 
>   =============================================
>   # ./mkfs.btrfs -f -m DUP -d DUP /dev/sdb1 /dev/sdb2
>   btrfs-progs v4.5-24-ga35b7e6
>   See http://btrfs.wiki.kernel.org for more information.
> 
>   WARNING: DUP is not recommended on filesystem with multiple devices
>   ERROR: unable to create FS with metadata profile DUP (have 2 devices but 1 devices are required)
>   =============================================
> 
> * expected result
> 
>   =============================================
>   # ./mkfs.btrfs -f -m dup -d dup /dev/sdb1 /dev/sdb2
>   WARNING: DUP is not recommended on filesystem with multiple devices
>   btrfs-progs v4.5-25-g1a10a3c
>   See http://btrfs.wiki.kernel.org for more information.
> 
>   Label:              (null)
>   UUID:               010d72ff-c87c-4516-8916-5e635719d110
>   Node size:          16384
>   Sector size:        4096
>   Filesystem size:    28.87GiB
>   Block group profiles:
>     Data:             DUP               1.01GiB
>     Metadata:         DUP               1.01GiB
>     System:           DUP              12.00MiB
>   SSD detected:       no
>   Incompat features:  extref, skinny-metadata
>   Number of devices:  2
>   Devices:
>      ID        SIZE  PATH
>       1   953.00MiB  /dev/sdb1
>       2    27.94GiB  /dev/sdb2
> 
>   ==================================================
> 
> Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Applied, mkfs tests updated. Thanks.
