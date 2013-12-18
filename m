Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21234 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402Ab3LRVqI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 16:46:08 -0500
Message-ID: <52B21797.5010000@fb.com>
Date: Wed, 18 Dec 2013 16:45:59 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Frank Holton <fholton@gmail.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: Re: [PATCH v4] Btrfs: convert printk to btrfs_ and fix BTRFS prefix
References: <1386878261-2348-1-git-send-email-fholton@gmail.com>
In-Reply-To: <1386878261-2348-1-git-send-email-fholton@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 12/12/2013 02:57 PM, Frank Holton wrote:
> Convert all applicable cases of printk and pr_* to the btrfs_* macros.
>
> Fix all uses of the BTRFS prefix.
>
> Signed-off-by: Frank Holton <fholton@gmail.com>

There are tailing whitespaces everywhere.  Please run this through 
checkpatch.pl so you can fix all those up, or use

let c_space_errors = 1

in your .vimrc so you can see them.  Thanks,

Josef
