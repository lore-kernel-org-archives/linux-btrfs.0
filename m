Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52005 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3LRLJs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Dec 2013 06:09:48 -0500
Received: by mail-wi0-f169.google.com with SMTP id hn6so4890627wib.4
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Dec 2013 03:09:47 -0800 (PST)
Received: from pdb1.th.formicary.net (vl488-formicary-host150.jump.net.uk. [212.13.207.150])
        by mx.google.com with ESMTPSA id w20sm3037395wia.5.2013.12.18.03.09.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 18 Dec 2013 03:09:46 -0800 (PST)
Date: Wed, 18 Dec 2013 11:09:44 +0000
From: Leonidas Spyropoulos <artafinde@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: improve the performance fluctuating of the fsync
Message-ID: <20131218110944.GA8309@pdb1.th.formicary.net>
References: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387363964-20316-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 18, 2013 at 06:52:44PM +0800, Miao Xie wrote:
> In order to improve the performance of fsync, we use the outstanding
> ordered extents to avoid looking up the checksum from the csum tree.
> But we didn't filter out the ordered extents whose csum is still being
> calculated, when we got those ordered extents, we had to wait for the
> csum calculation. It made the performance dropped down suddenly. (On
> my box, it drop down from 56MB/s to 4-10MB/s)
> 
> But actually, the csum calculation of the ordered extents which were
> introduced by the current fsync had already completed. Those ordered
> extents whose csum was being calculated didn't belong to the current
> fsync, we can ignore them.
> 
> By this patch, the performance fluctuating doesn't happen, and the average
> performance grows up by ~2%.
> [..] 

Will this help with apt-get performance over btrfs file system? As far as I understand it it's happening because of multiple fsync calls.
