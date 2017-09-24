Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:42986 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbdIXRbt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 24 Sep 2017 13:31:49 -0400
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 0C15A2CEBC55
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Sep 2017 19:31:48 +0200 (CEST)
Subject: Re: btrfs_extref_hash 64-bit vs. btrfs_crc32c 32-bit
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a77ac7e4-502d-046c-a116-b4a4c35133cb@mendix.com>
Message-ID: <1b8d512f-d4c2-bfd1-daf4-a03977779a0e@mendix.com>
Date: Sun, 24 Sep 2017 19:31:47 +0200
MIME-Version: 1.0
In-Reply-To: <a77ac7e4-502d-046c-a116-b4a4c35133cb@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/23/2017 12:35 PM, Hans van Kranenburg wrote:
> Hi,
> 
> When looking around in the kernel code, I ran into this (hash.h):
> 
> u32 btrfs_crc32c(u32 crc, const void *address, unsigned int length);
> 
> [...]
> 
> static inline u64 btrfs_extref_hash(u64 parent_objectid, const char *name,
> int len)
> {
> return (u64) btrfs_crc32c(parent_objectid, name, len);
> }
> 
> [...]
> 
> What is the "official" behaviour of just stuffing a 64-bit
> (parent_objectid) value into a 32-bit function argument (crc)? Does it
> get truncated? Does this compile without a warning?
> 
> I would expect that the caller should do the housekeeping of deciding
> how to transform the 64 bit parent_objectid into some 32 bit value.

In the meantime I can of course answer this myself...

#include <stdlib.h>
#include <stdio.h>

typedef unsigned int __u32;
typedef unsigned long __u64;

void i_eat_32_for_breakfast(__u32 food) {
	printf("%u\n", food);
}

int main(void) {
	__u64 eat_this = 4294968320;
	i_eat_32_for_breakfast(eat_this);
	return 0;
}

-$ ./breakfast
1024

-- 
Hans van Kranenburg
