Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62983 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758139Ab2ERQJM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 May 2012 12:09:12 -0400
Received: by qcro28 with SMTP id o28so2089418qcr.19
        for <linux-btrfs@vger.kernel.org>; Fri, 18 May 2012 09:09:11 -0700 (PDT)
Message-ID: <1337357348.7927.5.camel@ayu>
Subject: Re: SSD format/mount parameters questions
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Tomasz Torcz <tomek@pipebreaker.pl>
Cc: linux-btrfs@vger.kernel.org
Date: Fri, 18 May 2012 12:09:08 -0400
In-Reply-To: <20120518153258.GE24598@mother.jarsat.pl>
References: <jp32u7$vlc$1@dough.gmane.org> <20120518070251.GA32766@panda>
	 <CAFvQSYRK_jmakEYVYgLH5Ct1rCQO-tA6-kn6D_o+Mdy0pwCuXQ@mail.gmail.com>
	 <20120518153258.GE24598@mother.jarsat.pl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2012-05-18 at 17:32 +0200, Tomasz Torcz wrote:
> On Fri, May 18, 2012 at 05:08:33PM +0200, Clemens Eisserer wrote:
> > > I would not buy anything else
> > > than intel. I have about 26 of them for years now (both in servers and
> > > workstations, several series), and never had an issue. Two of my
> > > colleagues have OCZ, and both had to RMA them.
> > 
> > I guess it boils down wether you want intel also to rule the SSD
> > market in the long term, as they do with PC processors...
> > 
> > Comparing intel SSDs with OCZ is not that fair, as OCZ has always been
> > low-priced bleeding edge stuff.
> 
>   Looking into the controllers...
>   first there were bunch of different ones; Intel had it own design with
> SSD 320.
>   Then come Sandforce; it got broadly used, despite sucking when used
> with FDE. Even Intel started to used Sandforce - SSD 520. How's
> reliabilty of Intel differs?
>   Latest fad is Marvell controller; again Intel joins the pack with SSD510.
> 
>   So, Intel is not that different anymore.

The controllers themselves really aren't that interesting any more - an
SSD controller is really just an ARM or MIPS core with some flash
interfaces, a SATA interface, and some ram - running proprietary
firmware.

Several of the Marvell devices actually have completely different
firmwares (e.g. Intel's firmware for Marvell devices was reportedly
developed by them in-house), and Intel's Sandforce firmware has some
customizations for improved reliability, at the expense of some speed.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

