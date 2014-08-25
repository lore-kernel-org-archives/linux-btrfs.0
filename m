Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28227 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHYEDb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 00:03:31 -0400
Date: Mon, 25 Aug 2014 12:03:22 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Tomasz Torcz <tomek@pipebreaker.pl>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: REPORT: Still a lot of BTRFS freezes in 3.16.1-1-ARCH
Message-ID: <20140825040321.GB22848@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <4207113.A3bnH6gnWF@zafu>
 <20140824173255.GB367827@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20140824173255.GB367827@mother.pipebreaker.pl>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Aug 24, 2014 at 07:32:56PM +0200, Tomasz Torcz wrote:
> On Sun, Aug 24, 2014 at 07:25:43PM +0200, Swâmi Petaramesh wrote:
> > Hi there,
> > 
> > This is to report that I'm still having quite systematic BRTFS freezes on an 
> > ArchLinux running latest 3.16.1-1-ARCH kernel.
> > 
> > Interestingly enough, I have several latops with the exact same setup :
> > 
> > Arch Linux with 3.16.1-1-ARCH kernel, fully running on BTRFS (with LZO 
> > compression) over LVM over LUKS.
> 
>   Have you applied Liu's patch[1]?  It not useful reporting knows bugs, if
> you haven't.
> 
>  1 – http://www.spinics.net/lists/linux-btrfs/msg36616.html

The v3 patch is the better one if you want to try :)

thanks,
-liubo
