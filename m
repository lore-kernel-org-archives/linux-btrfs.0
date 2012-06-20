Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:42850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756828Ab2FTXoG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 19:44:06 -0400
Message-ID: <4FE2603E.20605@zytor.com>
Date: Wed, 20 Jun 2012 16:43:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: "Fajar A. Nugraha" <list@fajar.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Subvolumes and /proc/self/mountinfo
References: <20120619234919.GA4102@shiny> <CBFTB8kPCXB@helmut.hullen.de> <CAE5mzvitiXX9N=qjM=xRgqhHQ9kY6WHXa4jWKGs6xRNOtd7uEA@mail.gmail.com> <4FE141DB.1080308@zytor.com> <CAG1y0sd6RcFwdUN1tMvpSUA0UyX0N0Q32DvFE-jN9ktL9pr4Dg@mail.gmail.com>
In-Reply-To: <CAG1y0sd6RcFwdUN1tMvpSUA0UyX0N0Q32DvFE-jN9ktL9pr4Dg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2012 11:31 PM, Fajar A. Nugraha wrote:
> 
> IMHO a more elegant solution would be similar to what
> (open)solaris/indiana does: make the boot parts (bootloader,
> configuration) as a separate area, separate from root snapshots. In
> solaris case IIRC this is will br /rpool/grub.
> 

It is both more and less elegant; it means you don't get the same kind
of atomic update for the bootloader itself.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

