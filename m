Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46392 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2K1K4A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:56:00 -0500
Date: Wed, 28 Nov 2012 18:54:23 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Arendt <admin@prnet.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
Message-ID: <20121128105422.GB2791@liubo>
Reply-To: Liu Bo <bo.li.liu@oracle.com>
References: <50AFB620.6040707@prnet.org>
 <2925363.jTFvA7mLni@vfr>
 <50AFE5FC.7040304@prnet.org>
 <20121124033910.GA5680@gmail.com>
 <50B27C4A.7040702@prnet.org>
 <20121126025439.GA5923@liubo>
 <50B3003E.2010104@prnet.org>
 <20121127074625.GA31592@liubo.cn.oracle.com>
 <50B51296.3010103@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50B51296.3010103@prnet.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 27, 2012 at 08:20:54PM +0100, David Arendt wrote:
> Hi,
> 
> I have now tested a gentoo reinstall with a recompile of nfs-utils. By
> observing how the directory /var/lib/nfs is created, I found a rather
> simple way to reproduce the problem:

Thanks for the reproduce steps, it helps quite a lot.

It turns out to be something wrong in btrfs's setting xattr code, I've
just sent you two patches for it, maybe you can check to see if it works
on your box :)

thanks,
liubo
