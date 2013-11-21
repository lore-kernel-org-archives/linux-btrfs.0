Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40524 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab3KUBDR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 20:03:17 -0500
Date: Thu, 21 Nov 2013 09:03:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: fs/btrfs/extent-tree.c:8430:9: error: format not a string
 literal and no format arguments
Message-ID: <20131121010312.GA8841@localhost>
References: <528c09f9.S0ecVwNN2c+fnUkv%fengguang.wu@intel.com>
 <CAGXu5jLoG00u2svBW6W5h9QsfYw1zZwYhZ1k4HG2UsvcWPHxuQ@mail.gmail.com>
 <20131120040551.GB4201@localhost>
 <CAGXu5jLXf=aOQa7XnvJ21n4VaVcNOUxhLGcFFdWOPXDam6sZ8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jLXf=aOQa7XnvJ21n4VaVcNOUxhLGcFFdWOPXDam6sZ8g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 20, 2013 at 08:04:58AM -0800, Kees Cook wrote:
> On Tue, Nov 19, 2013 at 8:05 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Tue, Nov 19, 2013 at 07:56:35PM -0800, Kees Cook wrote:
> >> Hi!
> >>
> >> Which tree is 'devel-snb'? I don't see that on the kernel.org trees.
> >
> > It's my local merge branch, based on the latest upstream release.
> 
> Hm, which release? I don't see it in 3.12, Linus's tree, nor linux-next.

'devel-snb' is one of my private branch, starting from v3.12, merging
several public git branches (eg. btrfs-next, kees/format-security, ...)
and finally do compile tests on top of it. This effectively tests
all of the merged public branches in one go. :)

Thanks,
Fengguang
