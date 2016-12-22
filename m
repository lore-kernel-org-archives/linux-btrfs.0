Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:36052 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754427AbcLVMXC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Dec 2016 07:23:02 -0500
Received: by mail-it0-f68.google.com with SMTP id n68so20653303itn.3
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Dec 2016 04:23:02 -0800 (PST)
Subject: Re: [bug or by design ?] btrfs defrag compression does not persist
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <16053303-2857-9729-a94f-d697004f019d@oracle.com>
Cc: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <007826d2-17a4-d993-b35b-f15e8a722790@gmail.com>
Date: Thu, 22 Dec 2016 07:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <16053303-2857-9729-a94f-d697004f019d@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-21 21:28, Anand Jain wrote:
>
> A quick design specific question.
>
> The following command converts file-data-extents to the specified
> encoder (lzo).
>
>   $ btrfs filesystem defrag -v -r -f -clzo dir/
>
> However the lzo property does not persist through the file modify.
> As the above operation does not update the btrfs.compression property.
>
> Question:
>  I wonder if this should be a bug or if its by design ?
>  What could be the main use case to _associate compression
>  at the time of defrag_ ?
While I didn't write the tool, I'm pretty certain that it was by design. 
  The primary use cases as I see them for compressing using defrag are:
1. Repacking files after mounting without compression (I do this myself 
whenever I have to boot into a different distro than what I already have 
on the system since I always use compress=none when mounting from 
recovery media).
2. Actually compressing files after marking them for compression.
3. Using multi-tier in-line compression (for example, 'live' data is LZO 
compressed, data which has sat idle for a while is ZLIB compressed).

>  The no-conflict fix will be to add another option to make
>  it persistent.
This ideally should be better documented (nothing says it will persist, 
but nothing I can find says it won't either), but I personally feel that 
defrag shouldn't be mucking about with file attributes beyond the stuff 
that's implicitly updated by shuffling extents around.
