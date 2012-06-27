Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:38635 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab2F0NtB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 09:49:01 -0400
Date: Wed, 27 Jun 2012 09:48:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jordan Windsor <jordanw2@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:1887 after hard shutdown.
Message-ID: <20120627134857.GC2819@localhost.localdomain>
References: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CACCfv7qEa-hVmNEB6DMy9khGfjcyPuLk27M1ue4VMDwgv9++FQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 09:46:44PM -0600, Jordan Windsor wrote:
> Hello,
> My computer locked up and I had to press the reset button.
> Ever since then I can't mount the btrfs filesystem, here's the output:
> 

Already fixed, go to the newest kernel you can get ahold of, 3.5-rc4 is the
newest I think?  Thanks,

Josef
