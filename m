Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107Ab3HGUSc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 16:18:32 -0400
Date: Wed, 7 Aug 2013 13:18:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mark Fasheh <mfasheh@suse.de>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, Andrew Vagin <avagin@gmail.com>
Subject: Re: [PATCH][RESEND] vfs: allow /proc/PID/maps to get device from stat
Message-ID: <20130807201826.GA23804@infradead.org>
References: <20130807195718.GC31381@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130807195718.GC31381@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 07, 2013 at 12:57:18PM -0700, Mark Fasheh wrote:
> stat(2) on btrfs returns a custom device, but proc uses s_dev from the super
> block. This causes problems (abi breakage) because software (and users) are
> not expecting the kernel to return different devices from these calls.

So fix stat on btrfs to return the proper device instead.

