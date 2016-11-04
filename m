Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38721 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934432AbcKDOlx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Nov 2016 10:41:53 -0400
Received: by mail-wm0-f46.google.com with SMTP id n67so54158855wme.1
        for <linux-btrfs@vger.kernel.org>; Fri, 04 Nov 2016 07:41:53 -0700 (PDT)
Received: from system (HSI-KBW-046-005-000-248.hsi8.kabel-badenwuerttemberg.de. [46.5.0.248])
        by smtp.gmail.com with ESMTPSA id c4sm4948875wmh.4.2016.11.04.07.41.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Nov 2016 07:41:50 -0700 (PDT)
Date: Fri, 4 Nov 2016 15:41:49 +0100
From: Saint Germain <saintger@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Identifying reflink / CoW files
Message-ID: <20161104154149.754c3eab@system>
In-Reply-To: <20161103051707.GE21290@hungrycats.org>
References: <20161027133011.631cf1e5@system>
        <20161103051707.GE21290@hungrycats.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 3 Nov 2016 01:17:07 -0400, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote :

> On Thu, Oct 27, 2016 at 01:30:11PM +0200, Saint Germain wrote:
> > Hello,
> > 
> > Following the previous discussion:
> > https://www.spinics.net/lists/linux-btrfs/msg19075.html
> > 
> > I would be interested in finding a way to reliably identify
> > reflink / CoW files in order to use deduplication programs (like
> > fdupes, jdupes, rmlint) efficiently.
> > 
> > Using FIEMAP doesn't seem to be reliable according to this
> > discussion on rmlint:
> > https://github.com/sahib/rmlint/issues/132#issuecomment-157665154
> 
> Inline extents have no physical address (FIEMAP returns 0 in that
> field). You can't dedup them and each file can have only one, so if
> you see the FIEMAP_EXTENT_INLINE bit set, you can just skip
> processing the entire file immediately.
> 
> You can create a separate non-inline extent in a temporary file then
> use dedup to replace _both_ copies of the original inline extent.
> Or don't bother, as the savings are negligible.
> 
> > Is there another way that deduplication programs can easily use ?
> 
> The problem is that it's not files that are reflinked--individual
> extents are.  "reflink file copy" really just means "a file whose
> extents are 100% shared with another file." It's possible for files
> on btrfs to have any percentage of shared extents from 0 to 100% in
> increments of the host page size.  It's also possible for the blocks
> to be shared with different extent boundaries.
> 
> The quality of the result therefore depends on the amount of effort
> put into measuring it.  If you look for the first non-hole extent in
> each file and use its physical address as a physical file identifier,
> then you get a fast reflink detector function that has a high risk of
> false positives.  If you map out two files and compare physical
> addresses block by block, you get a slow function with a low risk of
> false positives (but maybe a small risk of false negatives too).
> 
> If your dedup program only does full-file reflink copies then the
> first extent physical address method is sufficient.  If your program
> does block- or extent-level dedup then it shouldn't be using files in
> its data model at all, except where necessary to provide a mechanism
> to access the physical blocks through the POSIX filesystem API.
> 
> FIEMAP will tell you about all the extents (physical address for
> extents that have them, zero for other extent types).  It's also slow
> and has assorted accuracy problems especially with compressed files.
> Any user can run FIEMAP, and it uses only standard structure arrays.
> 
> SEARCH_V2 is root-only and requires parsing variable-length binary
> btrfs data encoding, but it's faster than FIEMAP and gives more
> accurate results on compressed files.
> 

As the dedup program only does full-file reflink, the first extent
physical address method can be used as a fast first check to identify
potential files.

But how to implement the second check in order to have 0% risk of false
positive ?
Because you said that mapping out two files and comparing the physical
addresses block by block also has a low risk of false positives.

Thank you very much for the detailed explanation !
