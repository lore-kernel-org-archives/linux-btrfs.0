Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:64241 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaHAQ6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Aug 2014 12:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDOMVhHq9kmRh11tX7BF_V4XjDncpzUROoJJntif-vwKZbbNw@mail.gmail.com>
References: <CAPDOMVhHq9kmRh11tX7BF_V4XjDncpzUROoJJntif-vwKZbbNw@mail.gmail.com>
Date: Fri, 1 Aug 2014 12:58:16 -0400
Message-ID: <CAPDOMVjF_6mRWDLbZLXsr5F2PT3H-GW=rQdF7Yt9LYdKayGdVQ@mail.gmail.com>
Subject: Re: Help with btrfs_zero_range function
From: Nick Krause <xerofoify@gmail.com>
To: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please forget my other questions , seems the only work to make punch
hole work for zero range is to
make a function like the one I am pasting below for zero range and
change the calls to punch range to
zero range as the other parts of the function can be the same from my reading.
Regards Nick
static int find_first_non_hole(struct inode *inode, u64 *start, u64 *len)
{
    struct extent_map *em;
    int ret = 0;

    em = btrfs_get_extent(inode, NULL, 0, *start, *len, 0);
    if (IS_ERR_OR_NULL(em)) {
        if (!em)
            ret = -ENOMEM;
        else
            ret = PTR_ERR(em);
        return ret;
    }

    /* Hole or vacuum extent(only exists in no-hole mode) */
    if (em->block_start == EXTENT_MAP_HOLE) {
        ret = 1;
        *len = em->start + em->len > *start + *len ?
               0 : *start + *len - em->start - em->len;
        *start = em->start + em->len;
    }
    free_extent_map(em);
    return ret;
}
