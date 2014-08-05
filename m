Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48490 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbaHEBRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 21:17:41 -0400
Message-ID: <53E030AC.2030804@fb.com>
Date: Mon, 4 Aug 2014 21:17:32 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>, Miao Xie <miaox@cn.fujitsu.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: integration tree updated
References: <53D1B595.7070908@fb.com> <53DB585F.8040400@oracle.com>
In-Reply-To: <53DB585F.8040400@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/01/2014 05:05 AM, Anand Jain wrote:
> 
> 
> Hi Chris,
> 
>  Looks like you missed Miao update (on 17 Jul) to back out the bad
>  patch (below), and your integration branch (published on 25 Jul)
>  still contains the same.
> 
> [PATCH 2/2] Btrfs: fix wrong total device counter after removing a seed
> device
> 
>  You should remove it.
> 
>  Simple test cases on your integration branch (like btrfs dev del OR
>  btrfs/003) is failing due to this and I (+ others would) spend some
>  time digging it out

Thanks Anand, I'll fix this up along with the other fixes from the last
week and push out a new branch.

-chris
