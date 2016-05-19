Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45226 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753433AbcESPGQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 11:06:16 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
	by mx0b-00082601.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u4JF2uZi023227
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 08:06:14 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
	by mx0b-00082601.pphosted.com with ESMTP id 230vd9e9kf-1
	(version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 08:06:14 -0700
Date: Thu, 19 May 2016 11:06:01 -0400
From: Chris Mason <clm@fb.com>
To: <linux-btrfs@vger.kernel.org>
Subject: Re: Crash after WARN_ON(BTRFS_I(inode)->csum_bytes)
Message-ID: <20160519150601.ivpfwwqiyz2jziol@floor.thefacebook.com>
References: <20160519102553.GA4164@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20160519102553.GA4164@invalid>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2016 at 12:25:53PM +0200, M G Berberich wrote:
> Hello,
> 
> a near total system crash (reboot via magic-sysreq-keys was possible)
> which seems to be associated to btrfs.
> 
> btrfs check (v 4.5.2) does not find any problem with any filesystems
> on the system.
> 
> Kernel is stock 4.6, booting without initramfs, system is Debian
> stretch (testing).

This patch should fix things:

https://patchwork.kernel.org/patch/9106001/

-chris
