Return-Path: <SRS0=BfcD=PJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7988FC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 02:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3641E2075D
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Jan 2019 02:39:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=nuclearwinter.com header.i=@nuclearwinter.com header.b="xRcGFjps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbfAACjK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Dec 2018 21:39:10 -0500
Received: from titan.nuclearwinter.com ([205.185.120.7]:44444 "EHLO
        titan.nuclearwinter.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727945AbfAACjK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Dec 2018 21:39:10 -0500
Received: from [IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c] ([IPv6:2601:6c5:8000:6b90:54ff:ba2b:b29:792c])
        (authenticated bits=0)
        by titan.nuclearwinter.com (8.14.7/8.14.7) with ESMTP id x012cvbl027746
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 31 Dec 2018 21:39:01 -0500
DKIM-Filter: OpenDKIM Filter v2.11.0 titan.nuclearwinter.com x012cvbl027746
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nuclearwinter.com;
        s=201211; t=1546310342;
        bh=eG/aY6p8DzRI7ihibfGFtxcFsxQYa/WZQno/uit9mWk=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=xRcGFjps+nGCsuNu6x0LlUgqren38YqS0AnFTti/OuMBxdEWSrA2I8nlJaBnhREDw
         B6IxrDqLjQPY0OADrwFs5Ja4pOQvZrtcDWwLO+iMEej3nFiMLzQ1fz1z5nMSuasGq3
         KOy7mI3h5w1IGkqYXFJStm5xA6pVTN2akdLmz+/Y=
Subject: Re: Scrub aborts due to corrupt leaf
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com>
 <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com>
 <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <CAJCQCtTV3a9rH6ystLCbLUVoh4b1LL5yXWiOBPp6Fa28efZf_w@mail.gmail.com>
 <35ccf3c1-c18d-cce9-23b8-d24a35fe5549@mendix.com>
 <9e6b268b-b545-bad1-f33a-b29ea1af7db0@nuclearwinter.com>
 <CAJCQCtSbLkpYnwEO05D5R2oXVznJ3KwBxjyfBDnM4PaGwSXUhg@mail.gmail.com>
 <3f3020c0-2643-074d-b88d-02123ece911c@nuclearwinter.com>
 <CAJCQCtTc49Qe3_zN7OVF7TQbONhdsh4-383=ttu_0i-5OOig7g@mail.gmail.com>
 <CAJCQCtQ68Oz=biJ=Z5fZJiqB0QzAR6mK_1eRvuqYXZjecL3bxw@mail.gmail.com>
 <b8b50f6e-60ed-6988-0556-50c94c077099@nuclearwinter.com>
 <9dbfde05-4b20-4681-9286-3db0e8cf4f56@gmx.com>
From:   Larkin Lowrey <llowrey@nuclearwinter.com>
Message-ID: <55906a16-be89-fa15-09fc-d852063d06db@nuclearwinter.com>
Date:   Mon, 31 Dec 2018 21:38:51 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <9dbfde05-4b20-4681-9286-3db0e8cf4f56@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (titan.nuclearwinter.com [IPv6:2605:6400:20:950:ed61:983f:b93a:fc2b]); Mon, 31 Dec 2018 21:39:02 -0500 (EST)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 12/31/2018 7:12 PM, Qu Wenruo wrote:
>
> On 2018/12/31 下午11:52, Larkin Lowrey wrote:
>> On 10/11/2018 12:15 AM, Chris Murphy wrote:
>>> Is this a 68T file system? Seems excessive.
>>> Haha, by excessive I mean nuking such a big fs just for being unable
>>> to remove the space tree. I'm quite sure the devs would like to get
>>> that crashing bug fixed, anyway.
>> A second FS just started failing. I never had this much trouble with
>> space cache v1.
>>
>> This host had a DIMM failure a couple of weeks ago which caused the
>> system to halt due to uncorrectable ECC error(s).
> That looks like a pretty possible cause for the corruption.
>
> Like strange items in your extent tree of your other fs, if your memory
> is unreliable, all your fs is possible corrupted.
>
> And for the victim of memory corruption, the hotter tree block the
> easier to be a victim.
>
> For both case, the corruption happens at extent tree, which matches the
> symptom.

I hope you're not saying that BTRFS bypasses ECC protections. That would 
be very bad indeed. So, since the CPU immediately halted when it 
detected a memory error that could not be corrected, memory was not 
corrupted and the worst that happened was a write to disc that did not 
complete.

> Please do a btrfs check on all your filesystems.

# btrfs check /dev/Cached/Nearline
Opening filesystem to check...
Checking filesystem on /dev/Cached/Nearline
UUID: 68d31d5f-97a2-4a73-a398-c7c13ff439a5
[1/7] checking root items
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
checksum verify failed on 271262429573120 found 1BA4548E wanted D105DF84
bad tree block 271262429573120, bytenr mismatch, want=271262429573120, 
have=17478763091281320157
ERROR: failed to repair root items: Input/output error

--Larkin

