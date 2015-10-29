Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41951 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbbJ2Rdy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 13:33:54 -0400
Subject: Re: [PATCHv2] btrfs: bugfix: handle
 FS_IOC32_{GETFLAGS,SETFLAGS,GETVERSION} in btrfs_ioctl
To: Luke Dashjr <luke@dashjr.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <trivial@kernel.org>
References: <201510290822.26515.luke@dashjr.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56325870.20506@fb.com>
Date: Thu, 29 Oct 2015 13:33:36 -0400
MIME-Version: 1.0
In-Reply-To: <201510290822.26515.luke@dashjr.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/29/2015 04:22 AM, Luke Dashjr wrote:
> 32-bit ioctl uses these rather than the regular FS_IOC_* versions. They can
> be handled in btrfs using the same code. Without this, 32-bit {ch,ls}attr
> fail.
>

Looks good, thanks,

Reviewed-by: Josef Bacik <jbacik@fb.com>

