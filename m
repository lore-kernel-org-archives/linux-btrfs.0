Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:33336 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbdA3LnM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jan 2017 06:43:12 -0500
Subject: Re: Fresh Raid-1 setup, dump-tree shows invalid owner id
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>, linux-btrfs@vger.kernel.org
References: <20170130015416.GA5619@giis.co.in>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <006ecc84-52fb-2b09-0e47-317fa018e9f9@mendix.com>
Date: Mon, 30 Jan 2017 12:43:07 +0100
MIME-Version: 1.0
In-Reply-To: <20170130015416.GA5619@giis.co.in>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/30/2017 02:54 AM, Lakshmipathi.G wrote:
> After creating raid1:
> $./mkfs.btrfs -f -d raid1 -m raid1 /dev/sda6 /dev/sda7
> 
> and using
> $./btrfs inspect-internal dump-tree /dev/sda6  #./btrfs-debug-tree /dev/sda6
> 
> shows possible wrong value for 'owner'? 
> --
> checksum tree key (CSUM_TREE ROOT_ITEM 0) 
> leaf 29425664 items 0 free space 16283 generation 4 owner 7
> fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
> chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
> data reloc tree key (DATA_RELOC_TREE ROOT_ITEM 0) 
> leaf 29442048 items 2 free space 16061 generation 4 owner 18446744073709551607 <<< owner id?
> fs uuid 94fee00b-00aa-4d69-b947-347f743117f2
> chunk uuid 6477561c-cbca-45e4-980d-56727a8dc9d9
> --
> 
> or is that expected output?

Yes, the owner is the number of the tree.

DATA_RELOC_TREE is -9, but then unsigned 64 bits.

>>> -9 + 2**64
18446744073709551607L

So the result is a number that's close to the max or 64 bits.

You can find those numbers in the kernel source in
  include/uapi/linux/btrfs_tree.h

e.g.:

#define BTRFS_DATA_RELOC_TREE_OBJECTID -9ULL

-- 
Hans van Kranenburg
