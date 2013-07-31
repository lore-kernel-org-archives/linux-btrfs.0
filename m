Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:48955 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759871Ab3GaNfE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 09:35:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 45A1B9A06B4
	for <linux-btrfs@vger.kernel.org>; Wed, 31 Jul 2013 07:35:02 -0600 (MDT)
Date: Wed, 31 Jul 2013 09:35:00 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: tim <tim@klingt.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [3.10.3] kernel BUG at fs/btrfs/ctree.c:3000
Message-ID: <20130731133500.GB2372@localhost.localdomain>
References: <ktavc5$htm$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <ktavc5$htm$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 31, 2013 at 02:19:25PM +0200, tim wrote:
> running btrfs on kernel 3.10.3, i got the following two backtraces,
> first an info about a hung task and a kernel bug.
> 
> are these known issues?
> 

Well that's not good, can you file a bugzilla with this at bugzilla.kernel.org?
Make sure the component is set to btrfs.  Run btrfsck on your device and attach
the output to the bug as well.  Thanks,

Josef
