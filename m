Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25138 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbaBJVc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:32:58 -0500
Message-ID: <52F94582.6040703@fb.com>
Date: Mon, 10 Feb 2014 16:32:50 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH] xfstests: add test for btrfs data corruption when using
 compression
References: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1391874609-19721-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/08/2014 10:50 AM, Filipe David Borba Manana wrote:
> Test for a btrfs data corruption when using compressed files/extents.
> Under certain cases, it was possible for reads to return random data
> (content from a previously used page) instead of zeroes. This also
> caused partial updates to those regions that were supposed to be filled
> with zeroes to save random (and invalid) data into the file extents.
>
> This is fixed by the commit for the linux kernel titled:
>
>     Btrfs: fix data corruption when reading/updating compressed extents
>     (https://urldefense.proofpoint.com/v1/url?u=https://patchwork.kernel.org/patch/3610391/&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=JRaF%2BUY%2F2k%2BBfF9nTx3Iwl5JZWNCwew%2BI%2Fw%2B%2BfuDrgc%3D%0A&s=4a033ea8f3cf1f28794e90fcf16ea553766bb1ea83e10fc904182a8f56435eef)
>

Ran with and without the corresponding fix and all worked as expected. 
You can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
