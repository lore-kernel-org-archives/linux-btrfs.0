Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3596FC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBD0920834
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 05:59:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="g7pMJnr4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBD0920834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbeLDF7Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 00:59:24 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:40420 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbeLDF7Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Dec 2018 00:59:24 -0500
Received: by mail-lf1-f54.google.com with SMTP id v5so11008678lfe.7
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Dec 2018 21:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0eEaceD1MaWM8l8pnRQIfF07oOp5ikXMBLDupeCqFP8=;
        b=g7pMJnr4U39H7nXwuBKrb1RwXXkXAeI0REPiFHgOWtyNOztJrV5+nHMHmZ8+ZritHP
         YJV4vRoErbriE+EheEU6P7w2TbqqQNIp9l52JQD1qGM/alvrH9IySNGxmPIO+zO1pM67
         /ZjGpEPnzP52/x5PTUE4g6iXtyzxcqjcCUFX1RuKkcWMIA6pLJVfzQ+/rpKTYMY0xsg/
         8DfOSoSgI6FxMqkxr32jeFsnbMooDsDOhFAiAGEzF+l6Z4KV8m3xDsjxZzmQCwLaLVNk
         /Vs+4JV0MaKOglJgipqo8RrXBkSSVnLzz5GqkSGcolsBNOfSUD3evyPvCmEchifhsrAO
         TZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0eEaceD1MaWM8l8pnRQIfF07oOp5ikXMBLDupeCqFP8=;
        b=dI525s5ffNjyB3DchUuxWU+1YBN6+NHcs/JtaLr6hocVPpBggIYlBEMJ+D0N8aWZBb
         PEXSiSCvgO88/f+jrWarUavm1qrnIldv21kIlf9zMHeVsc/6LK7OdxTodEP4fNvDuZfp
         FumN985DTZxmGrhW9WHyIWuYxduLks1I0Y2kBeM9tr2rME6Cd26OoytxUjpQJP0LK/+Y
         rkY3Rw3kbZHLQRe0R8fpftxGv5GbP14r865YyieiAWItJQ89i09aNLdWTAI/vfdEd1Bx
         z4CFpzUNj2G1zRoN1Q5IODb1fO2bOBIE2Gcav5rbYp3waW0MiLAGJUCKyeBDywlUGogR
         gT5g==
X-Gm-Message-State: AA+aEWaDjDw+GXLxtqhaE9zvh4zgMF78+uiXK7+ag5h1WluixVQ01tr2
        vtYSCPDjAhCxVYnmo1zo2G55shL8NG9xqFxuwEcM5g==
X-Google-Smtp-Source: AFSGD/WQXo4IiQlLs8v62rl9ek6N/veCCpxrYBuussisUJ3wiP8tVXsD7hAQUJyEWHcshX3zzwV2LjleYP89fcpCNeQ=
X-Received: by 2002:a19:2755:: with SMTP id n82mr3348297lfn.94.1543903162246;
 Mon, 03 Dec 2018 21:59:22 -0800 (PST)
MIME-Version: 1.0
References: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
In-Reply-To: <e94da83b0a57c01663ad1e40fa6b9b5e@wpkg.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 3 Dec 2018 22:59:08 -0700
Message-ID: <CAJCQCtRCu5ED+L+j0vWaiPO1ujm=MpMTxD1OvW1v3ZYpT_SMyw@mail.gmail.com>
Subject: Re: experiences running btrfs on external USB disks?
To:     Tomasz Chmielewski <mangoo@wpkg.org>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 3, 2018 at 10:44 PM Tomasz Chmielewski <mangoo@wpkg.org> wrote:
>
> I'm trying to use btrfs on an external USB drive, without much success.
>
> When the drive is connected for 2-3+ days, the filesystem gets remounted
> readonly, with BTRFS saying "IO failure":
>
> [77760.444607] BTRFS error (device sdb1): bad tree block start, want
> 378372096 have 0
> [77760.550933] BTRFS error (device sdb1): bad tree block start, want
> 378372096 have 0
> [77760.550972] BTRFS: error (device sdb1) in __btrfs_free_extent:6804:
> errno=-5 IO failure
> [77760.550979] BTRFS info (device sdb1): forced readonly
> [77760.551003] BTRFS: error (device sdb1) in
> btrfs_run_delayed_refs:2935: errno=-5 IO failure
> [77760.553223] BTRFS error (device sdb1): pending csums is 4096
>
>
> Note that there are no other kernel messages (i.e. that would indicate a
> problem with disk, cable disconnection etc.).
>
> The load on the drive itself can be quite heavy at times (i.e. 100% IO
> for 1-2 h and more) - can it contribute to the problem (i.e. btrfs
> thinks there is some timeout somewhere)?
>
> Running 4.19.6 right now, but was experiencing the issue also with 4.18
> kernels.
>
>
>
> # btrfs device stats /data
> [/dev/sda1].write_io_errs    0
> [/dev/sda1].read_io_errs     0
> [/dev/sda1].flush_io_errs    0
> [/dev/sda1].corruption_errs  0
> [/dev/sda1].generation_errs  0


Hard to say without a complete dmesg; but errno=-5 IO failure is
pretty much some kind of hardware problem in my experience. I haven't
seen it be a bug.

-- 
Chris Murphy
