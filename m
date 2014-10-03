Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23007 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753439AbaJCSRh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 14:17:37 -0400
Message-ID: <542EE83D.8050701@fb.com>
Date: Fri, 3 Oct 2014 14:17:33 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.17.0-rc7: kernel BUG at fs/btrfs/relocation.c:931!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
In-Reply-To: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2014 03:27 AM, Tomasz Chmielewski wrote:
> Got this when running balance with 3.17.0-rc7:
>

Give these two patches a try

https://patchwork.kernel.org/patch/4938281/
https://patchwork.kernel.org/patch/4939761/

Thanks,

Josef
