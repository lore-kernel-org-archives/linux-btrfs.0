Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50871 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAOPIi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 10:08:38 -0500
Date: Wed, 15 Jan 2014 07:08:09 -0800
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfsck failes
Message-ID: <20140115150809.GH10639@merlins.org>
References: <CAFP7zVthUK54N5-8+QRABBpz2R9-mAbJGjiOc6Ty3nVS4O-EDA@mail.gmail.com>
 <A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <A76390BF-4D85-47D3-A332-AD09809F6632@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 13, 2014 at 05:37:31PM -0700, Chris Murphy wrote:
> 
> On Jan 13, 2014, at 3:58 PM, Holger Brandsmeier <brandsmeier@gmail.com> wrote:
> > 
> > Currently btrfsck failes to repair my partition, I get the output:
> > 
> > [root@ho-think bholger]# btrfsck --repair /dev/sda5
> 
> This is almost the last resort and you probably should be posting to the list before using repair.

A reminder about my previous comment that brtfsck should really give
better usage info and --force or --really-try-to-fsck  ;)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
