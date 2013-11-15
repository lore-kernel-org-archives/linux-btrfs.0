Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:44285 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3KOT7P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Nov 2013 14:59:15 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id E75A57C069A
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Nov 2013 12:59:14 -0700 (MST)
Date: Fri, 15 Nov 2013 14:59:13 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Himangi Saraogi <himangi774@gmail.com>
CC: <opw-kernel@googlegroups.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs:check-integrity.c: replace kmalloc with
 kmalloc_array and kzalloc with kzalloc_array.
Message-ID: <20131115195913.GC5128@localhost.localdomain>
References: <20131106205550.GA11060@himangi-Inspiron-N5110gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131106205550.GA11060@himangi-Inspiron-N5110gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 07, 2013 at 02:25:50AM +0530, Himangi Saraogi wrote:
> This patch replaces kmalloc(size * nr, ) with kmalloc_array(nr, size)
> as kmalloc_array() is preferred because it can check that the
> calculation doesn't wrap and won't return a smaller allocation.
> Also kzalloc(size * nr) was replaced with kzalloc_array().
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

This fails to build.  Thanks,

Josef
