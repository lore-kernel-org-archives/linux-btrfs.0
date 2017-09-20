Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49970 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbdITUp0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 16:45:26 -0400
Subject: Re: RFC: Btrfs does not store checksum type? Only size? O_o
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi76MPGYFiksk5Jt05wjhQoQXpQuu1CiJFhxQw8QEB0gPpw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <fd5c3de5-bf9a-171c-35e8-6c1ffc1da398@mendix.com>
Date: Wed, 20 Sep 2017 22:45:25 +0200
MIME-Version: 1.0
In-Reply-To: <CAGqmi76MPGYFiksk5Jt05wjhQoQXpQuu1CiJFhxQw8QEB0gPpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/20/2017 10:31 PM, Timofey Titovets wrote:
> I was reading the kernel code and docs and didn't find anything about
> some info like "cheksum type" as btrfs have for compression code.
> (I only found some silent "hack" in btrfs-progs, that print "checksum
> type", but get "checksum size")
> 
> If i understood all correctly btrfs only store checksum size, i.e. 4
> for current CRC32C.

The checksum type is set in the superblock:

csum_type		0 (crc32c)
csum_size		4
[...]

So in the current design, you probably could have different checksum
types, but you will have to choose one of them when creating a filesystem.

-- 
Hans van Kranenburg
