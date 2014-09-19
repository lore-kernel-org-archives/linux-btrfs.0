Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:15521 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbaISNHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 09:07:21 -0400
Message-ID: <541C2A82.6030402@fb.com>
Date: Fri, 19 Sep 2014 09:07:14 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel integration branch updated
References: <541AE9DF.9030401@fb.com> <541B8AAD.4080305@cn.fujitsu.com>
In-Reply-To: <541B8AAD.4080305@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/18/2014 09:45 PM, Qu Wenruo wrote:
> Hi Chris,
> 
> 
> I'm sorry that the commit 'btrfs: Fix and enhance merge_extent_mapping()
> to insert best fitted extent map'
> has a V2 patch, so the one in tree is not up-to-data.
> 
> Although the v2 change is quite small and it's relevantly dependent, so
> it should not be a pain change.

Thanks, please send the v2 as an incremental.  We'll send both to stable.

-chris
