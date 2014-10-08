Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60513 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbaJHCQY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Oct 2014 22:16:24 -0400
Date: Tue, 7 Oct 2014 22:16:16 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v2] btrfs: Make btrfs handle security mount options
 internally to avoid losing security label.
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1412734576.2374.2@mail.thefacebook.com>
In-Reply-To: <1412734360-16237-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1412734360-16237-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, Oct 7, 2014 at 10:12 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> 
wrote:
> changelog:
> v2: Fix a compile error when CONFIG_SECURITY is not set.

Thanks, could you please send this as an incremental?  Your original 
patch is in my integration tree now.

-chris



