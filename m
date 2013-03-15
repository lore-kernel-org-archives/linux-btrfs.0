Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pipebreaker.pl ([109.107.25.67]:51446 "EHLO
	mother.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3COSrf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Mar 2013 14:47:35 -0400
Date: Fri, 15 Mar 2013 19:47:33 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add skinny metadata support to progs V2
Message-ID: <20130315184733.GC23825@mother.pipebreaker.pl>
References: <1363373549-15423-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363373549-15423-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 15, 2013 at 02:52:29PM -0400, Josef Bacik wrote:
> This fixes up the progs to properly deal with skinny metadata.  This adds the -x
> option to mkfs and btrfstune for enabling the skinny metadata option.  This also
> makes changes to fsck so it can properly deal with the skinny metadata entries.
> Thanks,

  Can we have a manpage for mkfs.btrfs, explaining what "skinny metadata", "mixed mode"
and other *are*?

-- 
Tomasz   .. oo o.   oo o. .o   .o o. o. oo o.   ..
Torcz    .. .o .o   .o .o oo   oo .o .. .. oo   oo
o.o.o.   .o .. o.   o. o. o.   o. o. oo .. ..   o.

