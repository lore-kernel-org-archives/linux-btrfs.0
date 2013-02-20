Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934921Ab3BTNL0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 08:11:26 -0500
Date: Wed, 20 Feb 2013 14:11:23 +0100
From: David Sterba <dsterba@suse.cz>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Cc: Arne Jansen <lists@die-jansens.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel panic when scrub is used
Message-ID: <20130220131123.GD9521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CALJXSJrNNkEmSeGkez+A5-SWT9k8CUA7fUW5MRviXBWTLB1nqQ@mail.gmail.com>
 <512266F5.7000109@die-jansens.de>
 <CALJXSJpEVB6vESOQmpLfBkHYSqxU0quhByYGSJqgUR5SVY6Shw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALJXSJpEVB6vESOQmpLfBkHYSqxU0quhByYGSJqgUR5SVY6Shw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 18, 2013 at 12:53:28PM -0500, Jérôme Poulin wrote:
> http://tinypic.com/r/2r3xdvl/6

At the top of the listing there's apparent trace of a WARN_ON issued and
it's in read_extent_buffer

4660 void read_extent_buffer(struct extent_buffer *eb, void *dstv,
4661                         unsigned long start,
4662                         unsigned long len)
4663 {
4664         size_t cur;
4665         size_t offset;
4666         struct page *page;
4667         char *kaddr;
4668         char *dst = (char *)dstv;
4669         size_t start_offset = eb->start & ((u64)PAGE_CACHE_SIZE - 1);
4670         unsigned long i = (start_offset + start) >> PAGE_CACHE_SHIFT;
4671
4672         WARN_ON(start > eb->len);
4673         WARN_ON(start + len > eb->start + eb->len);

4674
4675         offset = (start_offset + start) & ((unsigned long)PAGE_CACHE_SIZE - 1);
4676
4677         while (len > 0) {
4678                 page = extent_buffer_page(eb, i);
4679
4680                 cur = min(len, (PAGE_CACHE_SIZE - offset));
4681                 kaddr = page_address(page);
4682                 memcpy(dst, kaddr + offset, cur);

first segfault happens at memcpy, it's likely a bad value in 'offset'
calculated from bogus values in 'eb'. With some luck we can guess at which page
it happend (which of RBX=11, RCX=2, RDX=1 holds value of 'i') or what are
values of other variables.

4683
4684                 dst += cur;
4685                 len -= cur;
4686                 offset = 0;
4687                 i++;
4688         }
4689 }

Was the filesystem created with nodesize > 4k ?

david
