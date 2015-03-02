Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64600 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754657AbbCBWKh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 Mar 2015 17:10:37 -0500
Message-ID: <54F4DFD7.4000405@fb.com>
Date: Mon, 2 Mar 2015 17:10:31 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/9] btrfs: qgroup: inherit limit info from srcgroup in
 creating snapshot.
References: <1423563803-8996-1-git-send-email-yangds.fnst@cn.fujitsu.com> <1423563803-8996-5-git-send-email-yangds.fnst@cn.fujitsu.com>
In-Reply-To: <1423563803-8996-5-git-send-email-yangds.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2015 05:23 AM, Dongsheng Yang wrote:
> Currently, when we snapshot a subvol, snapshot will not copy the limits
> from srcqgroup.
>
> This patch make the qgroup in snapshot inherit the limit info when create
> a snapshot.
>
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
