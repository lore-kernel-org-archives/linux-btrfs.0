Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1575 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbaA1OwJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 09:52:09 -0500
Message-ID: <52E7C403.5020700@fb.com>
Date: Tue, 28 Jan 2014 09:51:47 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: make test btrfs/025 more robust
References: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390920396-20311-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/28/2014 09:46 AM, Filipe David Borba Manana wrote:
> Make the test btrfs/025 not depend on the output of the btrfs tools
> subvolume, send, receive and filesystem commands output. The output
> of these commands has changed several times in the past, and it can
> change again in the future. Therefore just test for failure/success
> and not for the exact output on the success case.
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Wow sorry didn't realize this already got taken, but still a good change 
to have anyway.

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
