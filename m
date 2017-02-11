Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44780 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753198AbdBKNHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 11 Feb 2017 08:07:52 -0500
Date: Sat, 11 Feb 2017 08:07:20 -0500
From: Chris Mason <clm@fb.com>
To: Pat Erley <pat-lkml@erley.org>
CC: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>,
        Liu Bo <bo.li.liu@oracle.com>, Christoph Hellwig <hch@lst.de>,
        <kernel-team@fb.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs_decompress_buf2page()
Message-ID: <20170211130719.GA65294@clm-mbp.thefacebook.com>
References: <35a7eac2a55a330a27639e0b38f8d052e6dbee8b.1486767707.git.osandov@fb.com>
 <1e52505b-b6fa-f60c-92d5-282ef25cbb9a@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <1e52505b-b6fa-f60c-92d5-282ef25cbb9a@erley.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 10, 2017 at 08:12:35PM -0800, Pat Erley wrote:
>
>
>On 02/10/17 15:03, Omar Sandoval wrote:
>>From: Omar Sandoval <osandov@fb.com>
>>
>>If btrfs_decompress_buf2page() is handed a bio with its page in the
>>middle of the working buffer, then we adjust the offset into the working
>>buffer. After we copy into the bio, we advance the iterator by the
>>number of bytes we copied. Then, we have some logic to handle the case
>>of discontiguous pages and adjust the offset into the working buffer
>>again. However, if we didn't advance the bio to a new page, we may enter
>>this case in error, essentially repeating the adjustment that we already
>>made when we entered the function. The end result is bogus data in the
>>bio.
>>
>>Previously, we only checked for this case when we advanced to a new
>>page, but the conversion to bio iterators changed that. This restores
>>the old, correct behavior.
>
>I can confirm this fixes the corruption I was seeing
>
>Feel free to add:
>
>Tested-by: Pat Erley <pat-lkml@erley.org>

Thanks again Pat for bisecting this down.  It passed overnight so I'm 
sending in right now.

-chris
