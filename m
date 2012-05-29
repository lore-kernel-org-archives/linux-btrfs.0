Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([58.251.152.66]:56794 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2E2AkQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 May 2012 20:40:16 -0400
Received: from huawei.com (szxga03-in [172.24.2.9])
 by szxga03-in.huawei.com (iPlanet Messaging Server 5.2 HotFix 2.14 (built Aug
 8 2006)) with ESMTP id <0M4R00D8UDW4BA@szxga03-in.huawei.com> for
 linux-btrfs@vger.kernel.org; Tue, 29 May 2012 08:40:52 +0800 (CST)
Received: from szxrg01-dlp.huawei.com ([172.24.2.119])
 by szxga03-in.huawei.com (iPlanet Messaging Server 5.2 HotFix 2.14 (built Aug
 8 2006)) with ESMTP id <0M4R00DG1DW452@szxga03-in.huawei.com> for
 linux-btrfs@vger.kernel.org; Tue, 29 May 2012 08:40:52 +0800 (CST)
Date: Tue, 29 May 2012 08:40:10 +0800
From: Li Zefan <lizefan@huawei.com>
Subject: Re: Make existing snapshots read-only?
In-reply-to: <20120528183700.GA9588@untroubled.org>
To: bruce@untroubled.org
Cc: linux-btrfs@vger.kernel.org
Message-id: <4FC41AEA.2040905@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <20120528183700.GA9588@untroubled.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012/5/29 2:37, Bruce Guenter wrote:

> 
> Is there any way to mark existing snapshots as read-only? Making new
> ones read-only is easy enough, but what about existing ones?
> 


We have code in the kernel side, so what we need to do is to update btrfs-progs,
which is trivial.
