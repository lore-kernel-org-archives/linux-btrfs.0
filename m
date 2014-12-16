Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31854 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbaLPUQl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Dec 2014 15:16:41 -0500
Received: from pps.filterd (m0044010 [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.14.5/8.14.5) with SMTP id sBGKGYCb006107
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 12:16:41 -0800
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0a-00082601.pphosted.com with ESMTP id 1radkthsc5-11
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 16 Dec 2014 12:16:40 -0800
Message-ID: <54909321.3050000@fb.com>
Date: Tue, 16 Dec 2014 15:16:33 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: separate out the extent root update
References: <1418418077-1223-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1418418077-1223-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 04:01 PM, Josef Bacik wrote:
> Depending on where the extent root shows up in the dirty list we could end up
> recowing the extent root a few times during commit.  This is inefficient, so
> instead only track the other COW only roots and update them all at once, and
> then do the extent root/block group update loop by itself to try and reduce the
> amount of churn we do at commit time.  Thanks,
>

Killing this one as well.  Thanks,

Josef

