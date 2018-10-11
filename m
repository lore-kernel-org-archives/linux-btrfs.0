Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0835CC32788
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EFC420841
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 07:57:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5EFC420841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbeJKPXG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 11:23:06 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:51695 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727846AbeJKPXG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 11:23:06 -0400
Received: from [192.168.0.5] (ip5f5bf16c.dynamic.kabel-deutschland.de [95.91.241.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C20CE2012D0DC0;
        Thu, 11 Oct 2018 09:56:58 +0200 (CEST)
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
To:     grub-devel@gnu.org, Nick Terrell <terrelln@fb.com>
Cc:     Kernel Team <Kernel-team@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Daniel Kiper <dkiper@net-space.pl>,
        Colin Watson <cjwatson@ubuntu.com>
References: <20181009232137.1941290-1-terrelln@fb.com>
 <c00853f9-bc05-fe91-4e58-bf77f3da8583@molgen.mpg.de>
 <C0415AB7-FD1E-4026-8AEF-02B3F7FEABC5@fb.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <2a45bec8-472a-0719-fd8e-b562749fb01a@molgen.mpg.de>
Date:   Thu, 11 Oct 2018 09:56:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <C0415AB7-FD1E-4026-8AEF-02B3F7FEABC5@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear Nick,


Am 10.10.2018 um 22:28 schrieb Nick Terrell:

>> On Oct 10, 2018, at 12:34 AM, Paul Menzel wrote:
>> 
>> Sorry for being ignorant, but you explain, why the library needs to
>> be imported and it is not enough to use that library as an external
>> dependency?
>> 
>> Importing the library means, it has to be maintained in the GRUB
>> repository, which will result in some maintenance burden.
> 
> I've imported zstd because thats the way the rest of the
> decompressors are imported.
> 
> We could potentially use libzstd as an external dependency, since its
> only dependency is libc and GRUB provides the definitions of the libc
> functions that zstd needs to decompress (memcpy, and memmove). Theres
> some other stuff in the library that requires libc functionality that
> GRUB doesn't provide, but that isn't used during decompression. We
> strip those files out in the import.

Thank you for the explanation.

> Let me know if you want me to switch to an external dependency.

I cannot make that decision. The main developers and the distribution
folks should comment on that.


Kind regards,

Paul
