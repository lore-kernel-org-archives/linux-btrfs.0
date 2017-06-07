Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33791 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750766AbdFGADH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 20:03:07 -0400
Received: by mail-pg0-f45.google.com with SMTP id f185so39589598pgc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 17:03:06 -0700 (PDT)
Date: Tue, 6 Jun 2017 17:03:05 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] generic: test Btrfs delalloc accounting overflow
Message-ID: <20170607000305.GB31692@vader.DHCP.thefacebook.com>
References: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
 <20170603073700.GA30383@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170603073700.GA30383@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 03, 2017 at 12:37:00AM -0700, Christoph Hellwig wrote:
> This looks like a btrfs-specific test, and not like a generic one
> to me.

Nothing about the workload itself is btrfs-specific, we just have the
extra check at the end. But I don't really care, I can make it a btrfs
test unless Eryu has already applied it.
