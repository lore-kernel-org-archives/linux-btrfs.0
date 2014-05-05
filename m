Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38131 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932395AbaEENys (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 May 2014 09:54:48 -0400
Message-ID: <53679811.1020001@fb.com>
Date: Mon, 5 May 2014 09:54:25 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: Using mount -o bind vs mount -o subvol=vol
References: <20140504004732.GE9061@merlins.org>
In-Reply-To: <20140504004732.GE9061@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2014 08:47 PM, Marc MERLIN wrote:
> Is there any functional difference between
>
> mount -o subvol=usr /dev/sda1 /usr
> and
> mount /dev/sda1 /mnt/btrfs_pool
> mount -o bind /mnt/btrfs_pool/usr /usr

The internal implementation of mount -o subvol is a bind mount.  The 
only real difference is having /mnt/btrfs_pool hanging around.

-chris

