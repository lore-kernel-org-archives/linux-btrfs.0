Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outprodmail02.cc.columbia.edu ([128.59.72.51]:51676 "EHLO
        outprodmail02.cc.columbia.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933306AbdIYTCB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 15:02:01 -0400
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
        by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8PJ0D7t001434
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 15:02:00 -0400
Received: from hazelnut (localhost.localdomain [127.0.0.1])
        by hazelnut (Postfix) with ESMTP id B03D780
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 15:02:00 -0400 (EDT)
Received: from sendprodmail01.cc.columbia.edu (sendprodmail01.cc.columbia.edu [128.59.72.13])
        by hazelnut (Postfix) with ESMTP id 9B8AB84
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 15:02:00 -0400 (EDT)
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
        by sendprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v8PJ1x95014855
        (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 15:02:00 -0400
Received: by mail-wm0-f72.google.com with SMTP id r74so9497043wme.5
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Sep 2017 12:02:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87377kaehb.wl-satoru.takeuchi@gmail.com>
References: <CAFzqJcbAYFXsUjfnHTk9VT=PPsVUibh1-qf_p2oWt490cAdHcA@mail.gmail.com>
 <87377kaehb.wl-satoru.takeuchi@gmail.com>
From: Ruoxin Jiang <rj2394@columbia.edu>
Date: Mon, 25 Sep 2017 15:01:57 -0400
Message-ID: <CAFzqJcZKMMnAJKuGjE=XX13TrvrvhuOtf8coaCVLPNMbsVL4hA@mail.gmail.com>
Subject: Re: Btrfs Issues
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: multipart/mixed; boundary="f403045fab4c69d905055a083177"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--f403045fab4c69d905055a083177
Content-Type: text/plain; charset="UTF-8"

Hi Satoru,

I'm so sorry for the late reply! I rewrote the test programs to invoke
syscalls in the conventional way and added a few comments. Please find
attached the revised report.

As to your questions on "mmap", you are totally right that the first
mmap in the original 1/min.cpp is irrelevant. The original program was
automatically generated from a fuzzer I used and I hope the revised
ones to be much more understandable.

Thanks,
Amy

On Sun, Sep 17, 2017 at 11:10 PM, Satoru Takeuchi
<satoru.takeuchi@gmail.com> wrote:
> At Wed, 13 Sep 2017 11:53:35 -0400,
> Ruoxin Jiang wrote:
>>
>> [1  <text/plain; UTF-8 (7bit)>]
>> Hello,
>>
>> We are researchers from Columbia University, New York. As part of our
>> current research we have found some semantic discrepancies between
>> btrfs and other popular filesystems.
>>
>> We have attached two cases. The first one involves an invalid O_DIRECT
>> write() that fails back to buffered write instead of failing with
>> error EINVAL. In directory 2, we discovered that btrfs calculates
>> write_bytes in __btrfs_buffered_write differently from that in
>> generic_perform_writes in fs/mmap.c. This can cause inconsistent
>> behavior between btrfs and other filesystems when program invokes the
>> same writev/write() syscall.
>>
>> In each directory, you will find a Readme.md describing the issue and
>> pointing to the code that may cause the problem. For your convenience,
>> we also included test programs (min.cpp) and instructions in Readme to
>> help reproduce the issues.
>>
>> We would appreciate very much if you could confirm the two cases at
>> your conveniences.
>
> I took a look at your test programs, btrfs_issues/{1,2}/min.cpp. It looks
> very hard to read since you call syscalls in odd ways and all flags are
> hardcoded as literal hexadecimal numbers. Could rewrite these program
> to improve readability?
>
> In addition, I have two questions about btrfs_issues/1/min.cpp.
>
> 1. Why you set 'filename' as the 1st argument of mmap()?
> 2. What's the purpose of mmap() call? I guess mmap() is not related to issue 1.
>
> Thanks,
> Satoru
>
>>
>> Thanks,
>> Amy
>> [2 btrfs_issues.tar.gz <application/x-gzip (base64)>]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Ruoxin(Amy) Jiang
Columbia University, M.S. Computer Science
347-277-5455

--f403045fab4c69d905055a083177
Content-Type: application/x-gzip; name="btrfs_issues_revised.tar.gz"
Content-Disposition: attachment; filename="btrfs_issues_revised.tar.gz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_j80j2h9v0

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
--f403045fab4c69d905055a083177--

