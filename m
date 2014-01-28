Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14435 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635AbaA1OhW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 09:37:22 -0500
Message-ID: <52E7C09D.4020808@fb.com>
Date: Tue, 28 Jan 2014 09:37:17 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: do not use extent commit root for sending
References: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com>
In-Reply-To: <1389716803-2415-1-git-send-email-wangshilong1991@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/14/2014 11:26 AM, Wang Shilong wrote:
> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>
> Now we have kicked off transaction from btrfs send, it is not safe
> that we use extent commit root to search.
>
> I happended to catch this problem when running sending and snapshot
> in my desktop.

I'm confused about this, we are searching a read only snapshot, why 
isn't looking at the commit root ok?  Thanks,

Josef
