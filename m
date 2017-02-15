Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35609 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752413AbdBOV6A (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Feb 2017 16:58:00 -0500
Received: by mail-pg0-f54.google.com with SMTP id t188so1035927pgt.2
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Feb 2017 13:57:59 -0800 (PST)
Date: Wed, 15 Feb 2017 13:57:22 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Liu Bo <bo.li.liu@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Pat Erley <pat-lkml@erley.org>, kernel-team@fb.com
Subject: Re: [PATCH v2] Btrfs: fix btrfs_decompress_buf2page()
Message-ID: <20170215215722.GA11161@vader>
References: <35a7eac2a55a330a27639e0b38f8d052e6dbee8b.1486767707.git.osandov@fb.com>
 <cdac0f8a-2957-5346-66aa-b890162c2c6e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cdac0f8a-2957-5346-66aa-b890162c2c6e@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 11:32:06AM +0800, Anand Jain wrote:
>  Thanks Omar for nailing this down. How about a test case for this ?

Yeah, I'll put together a test case using your new compressible data
helper, thanks for adding that.
