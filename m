Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34590 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751867Ab3LQGiS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 01:38:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: fs/btrfs/extent_io.c:219 free_extent_state.part.36+0x21/0x34 [btrfs]()
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131217145543.7cfd90b5@wpkg.org>
Date: Mon, 16 Dec 2013 23:38:12 -0700
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <B290DF0D-3FD8-432B-8706-49EA0458C59F@colorremedies.com>
References: <20131217145543.7cfd90b5@wpkg.org>
To: Tomasz Chmielewski <tch@wpkg.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 16, 2013, at 10:55 PM, Tomasz Chmielewski <tch@wpkg.org> wrote:

> I'm getting these quite easily after upgrading to 3.13-rc4.
> 
> [  822.392976] CPU: 1 PID: 8115 Comm: rsync Not tainted 3.12.0-rc4 #1

Shows an older kernel. You might try 3.13.rc4 actual and see if it's reproducible. 3.12.5 is current.


Chris Murphy

