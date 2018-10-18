Return-Path: <SRS0=wNEY=M6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5B5ECDE43
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B067521480
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Oct 2018 18:02:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="1yQ/kDoJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B067521480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729725AbeJSCES (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Oct 2018 22:04:18 -0400
Received: from mail-lj1-f173.google.com ([209.85.208.173]:36285 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbeJSCES (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Oct 2018 22:04:18 -0400
Received: by mail-lj1-f173.google.com with SMTP id p89-v6so28566019ljb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Oct 2018 11:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=ckgPgKVHkj1ev1s2gxA+NZJ6OhARBPqpZ6mSzc6RHfk=;
        b=1yQ/kDoJtyR1Fn2OX8j8IzTWOSpll6RAV9LvbOpptTIrJpcnHElVS9HqxGm5AQIcqe
         emyuoR4HJ5IO3kK/lhJGkQsHYPUkiNDgaPVTEFGEyWrjqmcjvZbxQWV4tfJndMXIadYj
         Mw3J66teoy+jd4lYINFBJtKmF2R/mIZVX8zpfqx75AvIDEz4Pc6yltQeqauLLqOVmDdY
         8SxT6ynm/pwG1JI4xLcLLzv4bVLpT5IkFW8eK39ax9VcFrFXj0JS9IwnNCwwkkgRqgxI
         a2cyFUaP3OkK3vEfF2SPQq1q4msQ+W3r9X53pkWUV4lgQzWihbdVKw2QCAgtzv0w07N5
         A8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=ckgPgKVHkj1ev1s2gxA+NZJ6OhARBPqpZ6mSzc6RHfk=;
        b=Bt2NbJHrK+H/3SQWDl9znr2sxEWZcIk2YikPWi6+8+Qj3UVCFsm3AdlBPs4hsNgmox
         YZDz66Oa5kcz28UF6a/jlT8BSU5sr20qkMJqPfzh7FrMV4dkltioXwySfxbiM/jupEsr
         P/y+zCpYxHhZeQo7UtwiV+P2SwHGi33V3NtrqOwFiKlo4QI/G+cOwEC+gZzeT8p69VQS
         s0LxWY6acz+4pFrm2Y0iy/hzTIGtw7KqH22/L4X1Oc66ePmM24M5UdQbem5CTOfB28Is
         /aTzPfWNQEcYbuN9bXvY7ur9Q89Vu7IG6ozJuNC33B9AkasoesPmrnHA2aPe7+D1+ZG0
         0RwQ==
X-Gm-Message-State: ABuFfoh+WcT26QzF9quMiQVer9yjrhHSg+EstIV3iJ9bVqKCLAXDPfSW
        1W/aJxPGlha9rHtvwv3KdOHzqm+NQAoQn/bAGyjVcw==
X-Google-Smtp-Source: ACcGV61dVQJZB7OxjyjGKRSVFkQvPl9gdR29zTxH2+TkCq+jZK1afLbpkvqjpLZWleSW64vtotPemGEOUuS5nRhIPLg=
X-Received: by 2002:a2e:a20a:: with SMTP id h10-v6mr20736504ljm.8.1539885730538;
 Thu, 18 Oct 2018 11:02:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Thu, 18 Oct 2018 11:02:09
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <d63839e6-6d76-2457-cbe5-7e5a60181d23@oracle.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <11171664-790c-40ff-3925-1c179ab8e74b@oracle.com> <CAJCQCtSfuLTsxXfEkmz59PrOJ3LrXmGNG+_NKS_LPk9dHTgkug@mail.gmail.com>
 <d63839e6-6d76-2457-cbe5-7e5a60181d23@oracle.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Thu, 18 Oct 2018 12:02:09 -0600
X-Google-Sender-Auth: PtGxoDpPv32xC2qGy7s4Y0wCaus
Message-ID: <CAJCQCtTu0pjAY8k3L=YK0CCv7MvDepUBafMDqf1mBvJbNdFnkg@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     Anand Jain <anand.jain@oracle.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 16, 2018 at 10:08 PM, Anand Jain <anand.jain@oracle.com> wrote:


>
>  So a possible solution for the reproducible builds:
>    usual mkfs.btrfs dev
>    Write the data
>    unmount; create btrfs-image with uuid/fsid/time sanitized; mark it as a
> seed (RO).
>    check/verify the hash of the image.

Gotcha. Generation/transid needs to be included in that list. Imagine
a fast system vs a slow system. The slow system certainly will end up
with with higher transid's for the latest completed transactions.

But also, I don't know how the kernel code chooses block numbers,
either physical (chunk allocation) or logical (extent allocation) and
if that could be made deterministic. Same for inode assignment.

Another question that comes up later when creating the sprout by
removing the seed device, is how a script can know when all block
groups have successfully copied from seed to sprout, and that the
sprout can be unmounted.



-- 
Chris Murphy
