Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:47436 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751002AbdIWKfh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Sep 2017 06:35:37 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 9989C2B7AFFE
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Sep 2017 12:35:35 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Subject: btrfs_extref_hash 64-bit vs. btrfs_crc32c 32-bit
Message-ID: <a77ac7e4-502d-046c-a116-b4a4c35133cb@mendix.com>
Date: Sat, 23 Sep 2017 12:35:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

When looking around in the kernel code, I ran into this (hash.h):

u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length);

[...]

static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
int len)
{
return (u64) btrfs_crc32c(parent_objectid, name, len);
}

[...]

What is the "official" behaviour of just stuffing a 64-bit
(parent_objectid) value into a 32-bit function argument (crc)? Does it
get truncated? Does this compile without a warning?

I would expect that the caller should do the housekeeping of deciding
how to transform the 64 bit parent_objectid into some 32 bit value.

-- 
Hans van Kranenburg
