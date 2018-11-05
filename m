Return-Path: <SRS0=ibH9=NQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3FC2C0044C
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 13:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A3302081D
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Nov 2018 13:22:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A3302081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbeKEWlu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Nov 2018 17:41:50 -0500
Received: from mout.gmx.net ([212.227.15.18]:56527 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729100AbeKEWlu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Nov 2018 17:41:50 -0500
Received: from [192.168.178.22] ([109.193.14.2]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MhAAr-1g6gFI0Ffd-00MLgT; Mon, 05
 Nov 2018 14:22:05 +0100
Received: from [192.168.178.22] ([109.193.14.2]) by mail.gmx.com (mrgmx002
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MhAAr-1g6gFI0Ffd-00MLgT; Mon, 05
 Nov 2018 14:22:05 +0100
From:   "M. Klingmann" <m.klingmann@gmx.de>
Subject: Salvage files from broken btrfs
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
References: <45c08a5b-231a-744f-90e7-b2a33fd9b051@gmx.de>
 <ab4bf22e-5ee0-fa0c-7c46-82d144f8438f@gmx.com>
 <9ebb0148-2cc4-11f4-7028-71d2bce0493c@gmx.de>
 <c913ca2c-d7cd-def9-366c-0d3b511720ac@gmx.com>
 <6d8b1c06-5fd1-2198-6c91-f3041a91464e@gmx.de>
 <230db828-b752-9167-fbc1-5c603ce7c138@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=m.klingmann@gmx.de; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ec4f6a57-de12-94ae-f10b-cc9cb1bce494@gmx.de>
Date:   Mon, 5 Nov 2018 14:22:04 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <230db828-b752-9167-fbc1-5c603ce7c138@gmx.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: de-DE
X-Provags-ID: V03:K1:XdFCiVw8ig4hrnkPYq2hjx/82UAFXVwmQ9114slLlxiEdTLgfoA
 K3jtmnueaIppE1swAYEPx5gfNGaokGOK7eNd7LE8CDAKkogOKSzePOLeRwEd5FyMBh2ChV4
 1aaEOAQKwftnBJ4r79GtMeNcdfLntR2mutzLfB8us52j/AHrm4u0j/zP81VwWkbTep5kq7G
 KpetChAc1QyhiT9RHjnMg==
X-UI-Out-Filterresults: notjunk:1;V01:K0:JHW8WyJfJAs=:lvzbFDRdhaia4pthr06wj/
 Yxb396Xg0spPU6D7bsVAFycde0ydT23i654+SGrWwmSkHrz1qJCJjMH03Qdp4u1b08xgLo/gr
 SZz3Wz+DGIWS7cEH+UhEV45j1E6DpVXOGoWb4IgZ3JUcW03ECRytKnYOuF+xjo/dlVjfxXLqt
 n2RA0kTdWXBxRa5zHmRKp6bxtU70n80mhcuLb3DUPqBuz37glEw7dlbpktmd3Fz8/3N6NzJFd
 yxm1nIFQ1ZRTshT/3wpD4ARWgPrbymwCwpWG43msNxuYatnchJWAoc9nU594Z0T4X34F0TyWz
 cOg0QAt/W3w/YX8YK6W2lYLH8h8Zr4vPr5+Nkq3WpVs1O14pb7rVMx6DhhTNkwjEqxe6yZ71U
 8v7N+M0YTSWuRn3gZ4kqTAnwAXw9JgCJeAoEuVURNsYqd9r7iTsXkXwisRB5Xuho/Jqv62WQl
 5fPQmz7Ys4w7MfkFaKpCyIVjVdKPGVjrpKoJs5B9SEwbbdYND3NrSin2EBC1ccQJ5C4DBCnMn
 InE0q9juOfGv3996KEx3jcc7q5y1Mwjwbfx6RraETLV4KK646qIiXank45IG1IvIqkm4sIU/t
 Tk58HTnxyyKpeldmHq8VyYxfDH4k+jKq5C8sUYizWsvmGUyRqV2Ak6Z1KCMhHL2lpIQpWoQ+X
 X5MILj/XRh67lJysYbEYOBXNRej/QFLBlcrWK8t2N4J/2xfY/WT5dUlBtN3rU4h/A158RBnrJ
 lD+bVtteG30JsafrumB7ZRQfmy8+z+dwxMEZjsD5GOFgeEuUU+X91ExVj/s+eDyB/vYKryy0a
 u59oY4Z6H4UuzGk9J+Vr7BAXaLX0mJJtAMrd51WAEx4C3IpqOp1Ti/V9rZ/VjXC/bfwm7L/+F
 YWklY/BMwUoWiMLPivpkG65vr5P9VWMyDJIJJvoC7Fxc+rnK5quJ5oUyZd2qFV
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 03.11.2018 at 02:05 Qu Wenruo wrote:
> On 2018/11/3 上午1:18, M. Klingmann wrote:
>> On 02.11.2018 at 15:45 Qu Wenruo wrote:
>>> On 2018/11/2 下午10:30, M. Klingmann wrote:
>>>> On 31.10.2018 at 01:03 Qu Wenruo wrote:
>>>>> My plan for such recovery is:
>>>>>
>>>>> 1) btrfs ins dump-super to make sure system chunk array is valid
>>>>> 2) btrfs-find-root to find any valid chunk tree blocks
>>>>> 3) pass that chunk tree bytenr to btrfs-restore
>>>>>    Unfortunately, btrfs-restore doesn't support specifying chunk root
>>>>>    yet. But it's pretty easy to add such support.
>>>>>
>>>>> So, please provide the "btrfs ins dump-super -Ffa" output to start with.
>>>> Following your plan, I did 1) and 2).
>>>> As 2) failed (see below), is there anything I can do to find the tree
>>>> bytenr to supply btrfs-restore with it?
>>>>
>>>> 1) Here's the output given by "btrfs-show-super -Ffa":
>>>>
>>>> superblock: bytenr=65536, device=sdcard.iso
>>>> ---------------------------------------------------------
>>>> csum            0xb8e15dd7 [match]
>> [snip]
>>>> 2) "btrfs-find-root" yields "Couldn't read chunk root; Open ctree failed".
>>> It's not plain "btrfs-find-root" but "btrfs-find-root -o 5".
>>>
>>> And you should use btrfs-progs v4.17.1, not the old v4.4.
>>> The ability to continue search even if chunk tree get corrupted is added
>>> in v4.5, and I strongly recommend to use latest (v4.17.1) for a lot of
>>> fixes and extra debug output.
>>>
>>> If you can't find any handy way to update btrfs-progs, you could use
>>> Archlinux iso as a rescue OS to use the latest btrfs-progs.
>> Using Archlinux in fact is the easiest way to use version 4.17.1
>> (Archlinux for 2018-11-01).
>>
>> Here's the output from "btrfs-find-root sdcard.iso":
>>
>> WARNING: cannot read chunk root, continue anyway
>> Superblock thinks the generation is 1757933
>> Superblock thinks the level is 0
>>
>> Here's the output using "btrfs-find-root -o 5 sdcard.iso":
>>
>> WARNING: cannot read chunk root, continue anyway
>> Superblock doesn't contain generation info for root 5
>> Superblock doesn't contain the level info for root 5
> No other output at all?
>
> That means the whole 8M range of system chunk get corrupted.
> Thus really no way to get any meaningful data out of the filesystem,
> unfortunately.
>
> Thanks,
> Qu
That's a pity. So I'm back to the hex editor.
I hope to find another angle before searching for file content.
Thank you for your efforts anyway.
Cheers,
Mirko
