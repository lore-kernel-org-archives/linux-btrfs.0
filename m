Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm03.jp.fujitsu.com ([202.219.69.170]:32950 "EHLO
        mgwkm03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbcKIB6L (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 20:58:11 -0500
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 300F8AC0057
        for <linux-btrfs@vger.kernel.org>; Wed,  9 Nov 2016 10:58:06 +0900 (JST)
Subject: Re: [PATCH v2] btrfs-progs: send-test: add checking of clone-src
 option
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <201611040835.AA00012@WIN-5MHF4RKU941.jp.fujitsu.com>
 <201611090125.AA00013@WIN-5MHF4RKU941.jp.fujitsu.com>
 <f66ad5e8-5443-c52a-0727-111959183643@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Message-ID: <940f0900-ed96-351f-54c5-ef748ccc194d@jp.fujitsu.com>
Date: Wed, 9 Nov 2016 10:57:33 +0900
MIME-Version: 1.0
In-Reply-To: <f66ad5e8-5443-c52a-0727-111959183643@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/11/09 10:39, Qu Wenruo wrote:
> 
> 
> At 11/09/2016 09:25 AM, Tsutomu Itoh wrote:
>> Sending stream size of clone-src(-c) option is checked.
>> Fixed by "btrfs-progs: send: fix handling of -c option".
>>
>> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
>> ---
>> V2: old sending stream image is used
>> ---
>>  .../016-send-clone-src/send-stream-v4.8.2.img      | Bin 0 -> 6299778 bytes
> 
> The image seems quite large.
> 
> How about compressing it? And the script seems only checking the size of the file, not the content.
> 
> So it seems that we don't even need to upload the file.

Certainly, only the size of the image file is necessary, and we don't need image file.
But I want to keep the image file as a record.
Therefore, I'll post the version that compresses the image file soon.

Thanks,
Tsutomu

> 
> Thanks,
> Qu
> 
>>  tests/misc-tests/016-send-clone-src/test.sh        |  49 +++++++++++++++++++++
>>  2 files changed, 49 insertions(+)
>>  create mode 100644 tests/misc-tests/016-send-clone-src/send-stream-v4.8.2.img
>>  create mode 100755 tests/misc-tests/016-send-clone-src/test.sh
>>

(snip)

