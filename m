Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54355 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaFEOls (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 10:41:48 -0400
Date: Thu, 5 Jun 2014 07:41:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: latest btrfs-progs and asciidoc dependency
Message-ID: <20140605144146.GC14713@merlins.org>
References: <0f2f49c05a626f2f2e635a6db818e302@admin.virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0f2f49c05a626f2f2e635a6db818e302@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 12:52:04PM +0100, Tomasz Chmielewski wrote:
> And it looks the dependency is ~1 GB of new packages? O_o

That seems painful, but at the same time, the alternative, nroff/troff sucks.

Part ofyour problem however seems to be runaway dependencies.
You are getting x11 and stuff like libdrm which clearly you shouldn't need.
If your disk space is more valuable than your time, I recommend you build
asciidoc yourself and you should hopefully end up with less.

Or you can also remove asciidoc from the makefile and read the raw files
which are readable.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
