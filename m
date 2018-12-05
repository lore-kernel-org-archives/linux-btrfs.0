Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3586C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 21:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C13882082B
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 21:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C13882082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbeLEVg4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 16:36:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:35746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727257AbeLEVgz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:36:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E303EAD52;
        Wed,  5 Dec 2018 21:36:53 +0000 (UTC)
Subject: Re: [PATCH 00/10] btrfs: Support for DAX devices
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <1d687042-774f-e27b-7341-e5cd7a6be3d2@gmx.com>
From:   Jeff Mahoney <jeffm@suse.com>
Message-ID: <b04ba131-29eb-b064-5f96-75e30cef43f3@suse.com>
Date:   Wed, 5 Dec 2018 16:36:51 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:64.0)
 Gecko/20100101 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <1d687042-774f-e27b-7341-e5cd7a6be3d2@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/5/18 8:03 AM, Qu Wenruo wrote:
> 
> 
> On 2018/12/5 下午8:28, Goldwyn Rodrigues wrote:
>> This is a support for DAX in btrfs. I understand there have been
>> previous attempts at it. However, I wanted to make sure copy-on-write
>> (COW) works on dax as well.
>>
>> Before I present this to the FS folks I wanted to run this through the
>> btrfs. Even though I wish, I cannot get it correct the first time
>> around :/.. Here are some questions for which I need suggestions:
>>
>> Questions:
>> 1. I have been unable to do checksumming for DAX devices. While
>> checksumming can be done for reads and writes, it is a problem when mmap
>> is involved because btrfs kernel module does not get back control after
>> an mmap() writes. Any ideas are appreciated, or we would have to set
>> nodatasum when dax is enabled.
> 
> I'm not familar with DAX, so it's completely possible I'm talking like
> an idiot.

The general idea is:

1) there is no page cache involved. read() and write() are like direct 
i/o writes in concept.  The user buffer is written directly (via what is 
essentially a specialized memcpy) to the NVDIMM.
2) for mmap, once the mapping is established and mapped, the file system 
is not involved.  The application writes directly to the memory as it 
would a normal mmap, except it's persistent.  All that's required to 
ensure persistence is a CPU cache flush.  The only way the file system 
is involved again is if some operation has occurred to reset the WP bit.

> If btrfs_page_mkwrite() can't provide enough control, then I have a
> crazy idea.

It can't, because it is only invoked on the page fault path and we want 
to try to limit those as much as possible.

> Forcing page fault for every mmap() read/write (completely disable page
> cache like DIO).
> So that we could get some control since we're informed to read the page
> and do some hacks there.
There's no way to force a page fault for every mmap read/write.  Even if 
there was, we wouldn't want that.  No user would turn that on when they 
can just make similar guarantees in their app (which are typically apps 
that do this already) and not pay any performance penalty.   The idea 
with DAX mmap is that the file system manages the namespace, space 
allocation, and permissions.  Otherwise we stay out of the way.

-Jeff
-- 
Jeff Mahoney
SUSE Labs

