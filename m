Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25950 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964875AbaKNO2O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Nov 2014 09:28:14 -0500
Date: Fri, 14 Nov 2014 09:28:05 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/9] Implement device scrub/replace for RAID56
To: Miao Xie <miaox@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1415975285.25389.8@mail.thefacebook.com>
In-Reply-To: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
References: <1415973061-8643-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, Nov 14, 2014 at 8:50 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> This patchset implement the device scrub/replace function for RAID56, 
> the
> most implementation of the common data is similar to the other RAID 
> type.
> The differentia or difficulty is the parity process. In order to avoid
> that problem the data that is easy to be change out the stripe lock,
> we do most work in the RAID56 stripe lock context.
> 
> And in order to avoid making the code more and more complex, we copy 
> some
> code of common data process for the parity, the cleanup work is in my
> TODO list.

I'm starting to review and test these, but many thanks for tackling 
this.

-chris

