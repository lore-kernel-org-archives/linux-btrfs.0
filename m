Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50776 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbcBOV3s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 16:29:48 -0500
Date: Mon, 15 Feb 2016 16:29:42 -0500
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: change max_inline default to 2048
Message-ID: <20160215212942.el5kd2r32mp7ajtt@floor.thefacebook.com>
References: <1455209730-22811-1-git-send-email-dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1455209730-22811-1-git-send-email-dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 11, 2016 at 05:55:30PM +0100, David Sterba wrote:
> The current practical default is ~4k on x86_64 (the logic is more complex,
> simplified for brevity), the inlined files land in the metadata group and
> thus consume space that could be needed for the real metadata.
> 
> The inlining brings some usability surprises:
> 
> 1) total space consumption measured on various filesystems and btrfs
>    with DUP metadata was quite visible because of the duplicated data
>    within metadata
> 
> 2) inlined data may exhaust the metadata, which are more precious in case
>    the entire device space is allocated to chunks (ie. balance cannot
>    make the space more compact)
> 
> 3) performance suffers a bit as the inlined blocks are duplicate and
>    stored far away on the device.
> 
> Proposed fix: set the default to 2048
> 
> This fixes namely 1), the total filesysystem space consumption will be on
> par with other filesystems.
> 
> Partially fixes 2), more data are pushed to the data block groups.
> 
> The characteristics of 3) are based on actual small file size
> distribution.
> 
> The change is independent of the metadata blockgroup type (though it's
> most visible with DUP) or system page size as these parameters are not
> trival to find out, compared to file size.

This is a good compromise, and people that want higher numbers can
always use the mount option.

-chris
