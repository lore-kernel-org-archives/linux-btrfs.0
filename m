Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:38411 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2K1RMJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 12:12:09 -0500
Message-ID: <50B645DF.7020801@prnet.org>
Date: Wed, 28 Nov 2012 18:11:59 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
References: <50AFB620.6040707@prnet.org> <2925363.jTFvA7mLni@vfr> <50AFE5FC.7040304@prnet.org> <20121124033910.GA5680@gmail.com> <50B27C4A.7040702@prnet.org> <20121126025439.GA5923@liubo> <50B3003E.2010104@prnet.org> <20121127074625.GA31592@liubo.cn.oracle.com> <50B51296.3010103@prnet.org> <20121128105422.GB2791@liubo>
In-Reply-To: <20121128105422.GB2791@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

your patches seem to fix the problem

Thanks,
David Arendt

On 11/28/12 11:54, Liu Bo wrote:
> On Tue, Nov 27, 2012 at 08:20:54PM +0100, David Arendt wrote:
>> Hi,
>>
>> I have now tested a gentoo reinstall with a recompile of nfs-utils. By
>> observing how the directory /var/lib/nfs is created, I found a rather
>> simple way to reproduce the problem:
> Thanks for the reproduce steps, it helps quite a lot.
>
> It turns out to be something wrong in btrfs's setting xattr code, I've
> just sent you two patches for it, maybe you can check to see if it works
> on your box :)
>
> thanks,
> liubo

