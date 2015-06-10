Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47787 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbbFJK1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 06:27:36 -0400
Date: Wed, 10 Jun 2015 18:27:29 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-btrfs@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: deleting a btrfs subvolume shut up a server
Message-ID: <20150610102728.GC3561@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <5554923A.1090903@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5554923A.1090903@gmx.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 14, 2015 at 02:16:58PM +0200, Toralf Förster wrote:
> I created at a 3 TB btrfs formatted disk a btrfs subvolume, unpacked a minimal Gentoo Linux in it, created in addition few files within it under ./tmp and bind mount from the host few files onto those files. If I now delete in another terminal the subvolume - then the server dies immediately
> 
> It is a headless server, I had to request a manually reset to get it back.
> Nothing in the syslog (syslog-ng 3.6.2) - the server was just shot in he head.
> 
> This happened 2 times in a row. Host is a stable hardened Gentoo with 4.0.2 kernel.

Hmm, is it possible to get some information from netconsole?

Thanks,

-liubo
> 
> :-/
> 
> -- 
> Toralf
> pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E
> --
> "; the past is all dirty and cruel in the modern popular imagination, with the exception of the Romans, who are just cruel"
> Ian Mortimer, 2008, "The Time Traveller's Guide to Medieval England"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
