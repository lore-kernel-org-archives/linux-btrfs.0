Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33297 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424AbbE2UDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 May 2015 16:03:31 -0400
Received: by padj3 with SMTP id j3so242139pad.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 May 2015 13:03:31 -0700 (PDT)
Date: Fri, 29 May 2015 13:03:30 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/4] btrfs: use scrub_pause_on/off() to reduce code in
 scrub_enumerate_chunks()
Message-ID: <20150529200330.GB13244@mew.dhcp4.washington.edu>
References: <5c5c914dad20c018cfe74174827219c418839f39.1432900529.git.zhaolei@cn.fujitsu.com>
 <84c26e5cc92bdb89dd5a4e0efea08957fb268caa.1432900529.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <84c26e5cc92bdb89dd5a4e0efea08957fb268caa.1432900529.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 29, 2015 at 07:55:34PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Use new intruduced scrub_pause_on/off() can make this code block
> clean and more readable.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
Reviewed-by: Omar Sandoval <osandov@osandov.com>

-- 
Omar
