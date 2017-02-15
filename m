Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26263 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdBOD1m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Feb 2017 22:27:42 -0500
Subject: Re: [PATCH v2] Btrfs: fix btrfs_decompress_buf2page()
To: Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
References: <35a7eac2a55a330a27639e0b38f8d052e6dbee8b.1486767707.git.osandov@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Christoph Hellwig <hch@lst.de>,
        Pat Erley <pat-lkml@erley.org>, kernel-team@fb.com
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <cdac0f8a-2957-5346-66aa-b890162c2c6e@oracle.com>
Date: Wed, 15 Feb 2017 11:32:06 +0800
MIME-Version: 1.0
In-Reply-To: <35a7eac2a55a330a27639e0b38f8d052e6dbee8b.1486767707.git.osandov@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 02/11/17 07:03, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
>
> If btrfs_decompress_buf2page() is handed a bio with its page in the
> middle of the working buffer, then we adjust the offset into the working
> buffer. After we copy into the bio, we advance the iterator by the
> number of bytes we copied. Then, we have some logic to handle the case
> of discontiguous pages and adjust the offset into the working buffer
> again. However, if we didn't advance the bio to a new page, we may enter
> this case in error, essentially repeating the adjustment that we already
> made when we entered the function. The end result is bogus data in the
> bio.
>
> Previously, we only checked for this case when we advanced to a new
> page, but the conversion to bio iterators changed that. This restores
> the old, correct behavior.
>
> A case I saw when testing with zlib was:
>
>     buf_start = 42769
>     total_out = 46865
>     working_bytes = total_out - buf_start = 4096
>     start_byte = 45056
>
> The condition (total_out > start_byte && buf_start < start_byte) is
> true, so we adjust the offset:
>
>     buf_offset = start_byte - buf_start = 2287
>     working_bytes -= buf_offset = 1809
>     current_buf_start = buf_start = 42769
>
> Then, we copy
>
>     bytes = min(bvec.bv_len, PAGE_SIZE - buf_offset, working_bytes) = 1809
>     buf_offset += bytes = 4096
>     working_bytes -= bytes = 0
>     current_buf_start += bytes = 44578
>
> After bio_advance(), we are still in the same page, so start_byte is the
> same. Then, we check (total_out > start_byte && current_buf_start < start_byte),
> which is true! So, we adjust the values again:
>
>     buf_offset = start_byte - buf_start = 2287
>     working_bytes = total_out - start_byte = 1809
>     current_buf_start = buf_start + buf_offset = 45056
>
> But note that working_bytes was already zero before this, so we should
> have stopped copying.


  Thanks Omar for nailing this down. How about a test case for this ?

-Anand
