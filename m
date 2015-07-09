Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mta-out1.inet.fi ([62.71.2.230]:38708 "EHLO johanna4.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbbGIRTL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jul 2015 13:19:11 -0400
From: Henri Valta <cg@jakorasia.info>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Anyone tried out btrbk yet?
Date: Thu, 09 Jul 2015 20:12:43 +0300
Message-ID: <2975016.hhQ9CjkKJD@lap2arch>
In-Reply-To: <11148188.L9vtSMaNHV@merkaba>
References: <11148188.L9vtSMaNHV@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 09 July 2015 14:26:55 you wrote:

> Well I may try it for one of my BTRFS volumes in addition to the rsync
> backup for now. I would like to give all options on command line, but well,
> maybe it can completely replace my current script if I put everything in its
> configuration.
> 
> Any other handy BTRFS backup solutions?

Hi,

I've been using btrfs-sxbackup for a couple of weeks, and it has been working 
great. Everything is configured on command line, so that's a plus.

https://pypi.python.org/pypi/btrfs-sxbackup
https://github.com/masc3d/btrfs-sxbackup

-Henri
