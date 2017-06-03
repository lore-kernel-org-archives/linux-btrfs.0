Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37420 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750765AbdFCHhB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jun 2017 03:37:01 -0400
Date: Sat, 3 Jun 2017 00:37:00 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] generic: test Btrfs delalloc accounting overflow
Message-ID: <20170603073700.GA30383@infradead.org>
References: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This looks like a btrfs-specific test, and not like a generic one
to me.
