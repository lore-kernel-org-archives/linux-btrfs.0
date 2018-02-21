Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:43025 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932076AbeBUSuf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:50:35 -0500
Received: by mail-pl0-f68.google.com with SMTP id f23so1413712plr.10
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Feb 2018 10:50:35 -0800 (PST)
Date: Wed, 21 Feb 2018 10:50:32 -0800
From: Omar Sandoval <osandov@osandov.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/27] btrfs-progs: introduce libbtrfsutil,
 "btrfs-progs as a library"
Message-ID: <20180221185032.GA879@vader>
References: <cover.1518720598.git.osandov@fb.com>
 <20180220185048.GR10193@twin.jikos.cz>
 <20180221151338.GF1469@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180221151338.GF1469@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 04:13:38PM +0100, David Sterba wrote:
> On Tue, Feb 20, 2018 at 07:50:48PM +0100, David Sterba wrote:
> > I have more comments or maybe questions about the future development
> > workflow, but at this point the patchset is in a good shape for
> > incremental merge.
> 
> After removnig the first patch adding subvolume.c (with
> linux/btrfs_tree.h) and what depends on it, I'm left with:
> 
> Omar Sandoval (4):
>       Add libbtrfsutil
>       libbtrfsutil: add Python bindings
>       libbtrfsutil: add qgroup inheritance helpers
>       libbtrfsutil: add filesystem sync helpers
> 
> with some context updates. That builds and passes the CI tests.

Great. Does the CI system run the Python tests yet?
