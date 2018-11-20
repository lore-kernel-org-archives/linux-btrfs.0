Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68290C46475
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 21:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB62920685
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 21:09:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB62920685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbeKUHkO (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 21 Nov 2018 02:40:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:43454 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725865AbeKUHkN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Nov 2018 02:40:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7EBBEACFF;
        Tue, 20 Nov 2018 21:09:04 +0000 (UTC)
Subject: Re: [PATCH v2] btrfs: Fix error handling in
 btrfs_cleanup_ordered_extents
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com
References: <1540554115-11226-1-git-send-email-nborisov@suse.com>
 <20181120190050.u4pyaa6m5p5tck27@macbook-pro-91.dhcp.thefacebook.com>
From:   Nikolay Borisov <nborisov@suse.com>
Openpgp: preference=signencrypt
Autocrypt: addr=nborisov@suse.com; prefer-encrypt=mutual; keydata=
 xsFNBFiKBz4BEADNHZmqwhuN6EAzXj9SpPpH/nSSP8YgfwoOqwrP+JR4pIqRK0AWWeWCSwmZ
 T7g+RbfPFlmQp+EwFWOtABXlKC54zgSf+uulGwx5JAUFVUIRBmnHOYi/lUiE0yhpnb1KCA7f
 u/W+DkwGerXqhhe9TvQoGwgCKNfzFPZoM+gZrm+kWv03QLUCr210n4cwaCPJ0Nr9Z3c582xc
 bCUVbsjt7BN0CFa2BByulrx5xD9sDAYIqfLCcZetAqsTRGxM7LD0kh5WlKzOeAXj5r8DOrU2
 GdZS33uKZI/kZJZVytSmZpswDsKhnGzRN1BANGP8sC+WD4eRXajOmNh2HL4P+meO1TlM3GLl
 EQd2shHFY0qjEo7wxKZI1RyZZ5AgJnSmehrPCyuIyVY210CbMaIKHUIsTqRgY5GaNME24w7h
 TyyVCy2qAM8fLJ4Vw5bycM/u5xfWm7gyTb9V1TkZ3o1MTrEsrcqFiRrBY94Rs0oQkZvunqia
 c+NprYSaOG1Cta14o94eMH271Kka/reEwSZkC7T+o9hZ4zi2CcLcY0DXj0qdId7vUKSJjEep
 c++s8ncFekh1MPhkOgNj8pk17OAESanmDwksmzh1j12lgA5lTFPrJeRNu6/isC2zyZhTwMWs
 k3LkcTa8ZXxh0RfWAqgx/ogKPk4ZxOXQEZetkEyTFghbRH2BIwARAQABzSJOaWtvbGF5IEJv
 cmlzb3YgPG5ib3Jpc292QHN1c2UuZGU+wsF4BBMBAgAiBQJYijkSAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRBxvoJG5T8oV/B6D/9a8EcRPdHg8uLEPywuJR8URwXzkofT5bZE
 IfGF0Z+Lt2ADe+nLOXrwKsamhweUFAvwEUxxnndovRLPOpWerTOAl47lxad08080jXnGfYFS
 Dc+ew7C3SFI4tFFHln8Y22Q9075saZ2yQS1ywJy+TFPADIprAZXnPbbbNbGtJLoq0LTiESnD
 w/SUC6sfikYwGRS94Dc9qO4nWyEvBK3Ql8NkoY0Sjky3B0vL572Gq0ytILDDGYuZVo4alUs8
 LeXS5ukoZIw1QYXVstDJQnYjFxYgoQ5uGVi4t7FsFM/6ykYDzbIPNOx49Rbh9W4uKsLVhTzG
 BDTzdvX4ARl9La2kCQIjjWRg+XGuBM5rxT/NaTS78PXjhqWNYlGc5OhO0l8e5DIS2tXwYMDY
 LuHYNkkpMFksBslldvNttSNei7xr5VwjVqW4vASk2Aak5AleXZS+xIq2FADPS/XSgIaepyTV
 tkfnyreep1pk09cjfXY4A7qpEFwazCRZg9LLvYVc2M2eFQHDMtXsH59nOMstXx2OtNMcx5p8
 0a5FHXE/HoXz3p9bD0uIUq6p04VYOHsMasHqHPbsMAq9V2OCytJQPWwe46bBjYZCOwG0+x58
 fBFreP/NiJNeTQPOa6FoxLOLXMuVtpbcXIqKQDoEte9aMpoj9L24f60G4q+pL/54ql2VRscK
 d87BTQRYigc+ARAAyJSq9EFk28++SLfg791xOh28tLI6Yr8wwEOvM3wKeTfTZd+caVb9gBBy
 wxYhIopKlK1zq2YP7ZjTP1aPJGoWvcQZ8fVFdK/1nW+Z8/NTjaOx1mfrrtTGtFxVBdSCgqBB
 jHTnlDYV1R5plJqK+ggEP1a0mr/rpQ9dFGvgf/5jkVpRnH6BY0aYFPprRL8ZCcdv2DeeicOO
 YMobD5g7g/poQzHLLeT0+y1qiLIFefNABLN06Lf0GBZC5l8hCM3Rpb4ObyQ4B9PmL/KTn2FV
 Xq/c0scGMdXD2QeWLePC+yLMhf1fZby1vVJ59pXGq+o7XXfYA7xX0JsTUNxVPx/MgK8aLjYW
 hX+TRA4bCr4uYt/S3ThDRywSX6Hr1lyp4FJBwgyb8iv42it8KvoeOsHqVbuCIGRCXqGGiaeX
 Wa0M/oxN1vJjMSIEVzBAPi16tztL/wQtFHJtZAdCnuzFAz8ue6GzvsyBj97pzkBVacwp3/Mw
 qbiu7sDz7yB0d7J2tFBJYNpVt/Lce6nQhrvon0VqiWeMHxgtQ4k92Eja9u80JDaKnHDdjdwq
 FUikZirB28UiLPQV6PvCckgIiukmz/5ctAfKpyYRGfez+JbAGl6iCvHYt/wAZ7Oqe/3Cirs5
 KhaXBcMmJR1qo8QH8eYZ+qhFE3bSPH446+5oEw8A9v5oonKV7zMAEQEAAcLBXwQYAQIACQUC
 WIoHPgIbDAAKCRBxvoJG5T8oV1pyD/4zdXdOL0lhkSIjJWGqz7Idvo0wjVHSSQCbOwZDWNTN
 JBTP0BUxHpPu/Z8gRNNP9/k6i63T4eL1xjy4umTwJaej1X15H8Hsh+zakADyWHadbjcUXCkg
 OJK4NsfqhMuaIYIHbToi9K5pAKnV953xTrK6oYVyd/Rmkmb+wgsbYQJ0Ur1Ficwhp6qU1CaJ
 mJwFjaWaVgUERoxcejL4ruds66LM9Z1Qqgoer62ZneID6ovmzpCWbi2sfbz98+kW46aA/w8r
 7sulgs1KXWhBSv5aWqKU8C4twKjlV2XsztUUsyrjHFj91j31pnHRklBgXHTD/pSRsN0UvM26
 lPs0g3ryVlG5wiZ9+JbI3sKMfbdfdOeLxtL25ujs443rw1s/PVghphoeadVAKMPINeRCgoJH
 zZV/2Z/myWPRWWl/79amy/9MfxffZqO9rfugRBORY0ywPHLDdo9Kmzoxoxp9w3uTrTLZaT9M
 KIuxEcV8wcVjr+Wr9zRl06waOCkgrQbTPp631hToxo+4rA1jiQF2M80HAet65ytBVR2pFGZF
 zGYYLqiG+mpUZ+FPjxk9kpkRYz61mTLSY7tuFljExfJWMGfgSg1OxfLV631jV1TcdUnx+h3l
 Sqs2vMhAVt14zT8mpIuu2VNxcontxgVr1kzYA/tQg32fVRbGr449j1gw57BV9i0vww==
Message-ID: <1af84f15-4ef4-0aaf-60a4-f4c3275e08ba@suse.com>
Date:   Tue, 20 Nov 2018 23:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181120190050.u4pyaa6m5p5tck27@macbook-pro-91.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 20.11.18 г. 21:00 ч., Josef Bacik wrote:
> On Fri, Oct 26, 2018 at 02:41:55PM +0300, Nikolay Borisov wrote:
>> Running btrfs/124 in a loop hung up on me sporadically with the
>> following call trace:
>> 	btrfs           D    0  5760   5324 0x00000000
>> 	Call Trace:
>> 	 ? __schedule+0x243/0x800
>> 	 schedule+0x33/0x90
>> 	 btrfs_start_ordered_extent+0x10c/0x1b0 [btrfs]
>> 	 ? wait_woken+0xa0/0xa0
>> 	 btrfs_wait_ordered_range+0xbb/0x100 [btrfs]
>> 	 btrfs_relocate_block_group+0x1ff/0x230 [btrfs]
>> 	 btrfs_relocate_chunk+0x49/0x100 [btrfs]
>> 	 btrfs_balance+0xbeb/0x1740 [btrfs]
>> 	 btrfs_ioctl_balance+0x2ee/0x380 [btrfs]
>> 	 btrfs_ioctl+0x1691/0x3110 [btrfs]
>> 	 ? lockdep_hardirqs_on+0xed/0x180
>> 	 ? __handle_mm_fault+0x8e7/0xfb0
>> 	 ? _raw_spin_unlock+0x24/0x30
>> 	 ? __handle_mm_fault+0x8e7/0xfb0
>> 	 ? do_vfs_ioctl+0xa5/0x6e0
>> 	 ? btrfs_ioctl_get_supported_features+0x30/0x30 [btrfs]
>> 	 do_vfs_ioctl+0xa5/0x6e0
>> 	 ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
>> 	 ksys_ioctl+0x3a/0x70
>> 	 __x64_sys_ioctl+0x16/0x20
>> 	 do_syscall_64+0x60/0x1b0
>> 	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> Turns out during page writeback it's possible that the code in
>> writepage_delalloc can instantiate a delalloc range which doesn't
>> belong to the page currently being written back. This happens since
>> find_lock_delalloc_range returns up to BTRFS_MAX_EXTENT_SIZE delalloc
>> range when asked and doens't really consider the range of the passed
>> page. When such a foregin range is found the code proceeds to
>> run_delalloc_range and calls the appropriate function to fill the
>> delalloc and create ordered extents. If, however, a failure occurs
>> while this operation is in effect then the clean up code in
>> btrfs_cleanup_ordered_extents will be called. This function has the
>> wrong assumption that caller of run_delalloc_range always properly
>> cleans the first page of the range hence when it calls
>> __endio_write_update_ordered it explicitly ommits the first page of
>> the delalloc range. This is wrong because this function could be
>> cleaning a delalloc range that doesn't belong to the current page. This
>> in turn means that the page cleanup code in __extent_writepage will
>> not really free the initial page for the range, leaving a hanging
>> ordered extent with bytes_left set to 4k. This bug has been present
>> ever since the original introduction of the cleanup code in 524272607e88.
>>
>> Fix this by correctly checking whether the current page belongs to the
>> range being instantiated and if so correctly adjust the range parameters
>> passed for cleaning up. If it doesn't, then just clean the whole OE
>> range directly.
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>> Fixes: 524272607e88 ("btrfs: Handle delalloc error correctly to avoid ordered extent hang")
> 
> Can we just remove the endio cleanup in __extent_writepage() and make this do
> the proper cleanup?  I'm not sure if that is feasible or not, but seems like it
> would make the cleanup stuff less confusing and more straightforward.  If not
> you can add

Quickly skimming the code I think the cleanup in __extent_writepage
could be moved into __extent_writepage_io where we have 2 branches that
set PageError. So I guess it could be done, but I will have to
experiment with it.

> 
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> 
> Thanks,
> 
> Josef
> 
