Return-Path: <SRS0=U11f=M7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89ADFC67863
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 01:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56BE42145D
	for <linux-btrfs@archiver.kernel.org>; Fri, 19 Oct 2018 01:06:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56BE42145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbeJSJKH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 19 Oct 2018 05:10:07 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:52434 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726245AbeJSJKH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 Oct 2018 05:10:07 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46404953"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Oct 2018 09:06:24 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id ABE9F4B6ED9F;
        Fri, 19 Oct 2018 09:06:23 +0800 (CST)
Received: from [10.167.226.24] (10.167.226.24) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 19 Oct 2018 09:06:24 +0800
Subject: Re: fsck lowmem mode only: ERROR: errors found in fs roots
To:     Christoph Anton Mitterer <calestyo@scientia.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
CC:     Su Yue <Damenly_Su@gmx.com>
References: <8d8c90d3edfcc9e73428d3730496d48b1160b39b.camel@scientia.net>
 <a141cad2-0a08-555e-eb05-da2dceb54025@cn.fujitsu.com>
 <7146cafcc48d46ad123388d492807cbba08e101c.camel@scientia.net>
 <94750beb-c339-756a-11ec-f2bcc72b98e3@cn.fujitsu.com>
 <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
From:   Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <7d00063d-a834-b18c-e287-6b41925ee391@cn.fujitsu.com>
Date:   Fri, 19 Oct 2018 09:13:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.0
MIME-Version: 1.0
In-Reply-To: <e2ac3e05ddd1297d4017cbeecfa4b392b04613ad.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.24]
X-yoursite-MailScanner-ID: ABE9F4B6ED9F.AECAC
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[Bad format in previous reply, send again]

On 10/18/18 10:41 PM, Christoph Anton Mitterer wrote:
> Hey.
> 
> So I'm back from a longer vacation and had now the time to try out your
> patches from below:
> 
> On Wed, 2018-09-05 at 15:04 +0800, Su Yue wrote:
>> I found the errors should blame to something about inode_extref check
>> in lowmem mode.
>> I have writeen three patches to detect and report errors about
>> inode_extref. For your convenience, it's based on v4.17:
>> https://github.com/Damenly/btrfs-progs/tree/ext_ref_v4.17
>>

My bad, I have sent patches to ML according to my guess but forgot
to update above repo. I rebased it to v4.17 and pushed again just now, 
would you please fetch patches from above repo and try again?

Thanks,
Su
>> This repo should report more errors. Because one of those is just
>> Whac-A-Mole, I will make it better and send them later to ML.
> 
> 
> This is the output it gives:
> checking extents
> checking free space cache
> checking fs roots
> checking only csum items (without verifying data)
> checking root refs
> Checking filesystem on /dev/mapper/system
> UUID: 6050ca10-e778-4d08-80e7-6d27b9c89b3c
> found 617228185600 bytes used, no error found
> total csum bytes: 600139124
> total tree bytes: 2516172800
> total fs tree bytes: 1639890944
> total extent tree bytes: 156532736
> btree space waste bytes: 455772589
> file data blocks allocated: 7431727771648
>   referenced 732073979904
> 
> (just a bit strange that the UUID line is not in the beginngin)... but
> other than that, no longer an error message as it seems)
> 
> 
> Cheers,
> Chris.
> 
> 
> 


