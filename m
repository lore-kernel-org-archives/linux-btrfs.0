Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dibed.net-space.pl ([84.10.22.86]:47314 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390726AbeIVAIS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 20:08:18 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1870757AbeIUSK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 20:10:26 +0200
Date: Fri, 21 Sep 2018 20:10:25 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: terrelln@fb.com
Cc: grub-devel@gnu.org, kernel-team@fb.com, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: Import kernel zstd
Message-ID: <20180921181025.GB29978@router-fw-old.i.net-space.pl>
References: <20180828013654.1627080-1-terrelln@fb.com> <20180828013654.1627080-2-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180828013654.1627080-2-terrelln@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 06:36:52PM -0700, Nick Terrell wrote:
> Import xxhash and zstd from the upstream kernel as-is. This will not
> compile. The next patch in the series contains all the changes needed to
> make zstd compile in grub. Only the files needed for decompression are
> imported from zstd.
>
> The files are copied from these locations:
> include/linux/{xxhash,zstd}.h
> lib/xxhash.c
> lib/zstd/

First of all, may I ask you to import zstd from original repository
(https://github.com/facebook/zstd) instead of Linux kernel?

Please do not forget to give a commit id and name of the latest patch
in it. If they have stable releases please use the latest one.

Daniel
