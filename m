Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FE05C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 19:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC8DF206B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 19:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="hd5X0if6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC8DF206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbeJKDRe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 23:17:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41507 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbeJKDRe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:17:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id u21-v6so6018380lja.8
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2018 12:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=TEzH6HpaQew3fZxwCXmJdvtWrZ2HGM8CiNVrwVtCUhs=;
        b=hd5X0if6DDG4WQtYxmc40/SYPTBK3kpVJ/SW2BlE7tXAFujwxU/uF3jgQj/UXg1aJB
         TpS8tqLqpKH1eMO2iCnwXKzqu3AVqoQU52L5hvYhqzaNmPV33RHWkbv34w2bfsy9vmZY
         D6DDxQ260x/uCgr2IOfFnkEOX6J2Wdp06Ffo9WGps+IyfkUtlBO6XjkrvCQNeqdAjud7
         8TjPROvku2xzk6d2Ffh2GTZLmpz3d4nxAGAt3Jzh4iIAfjz0JNJJuDIMyV4oRFC0ZP77
         nQf33bSEDf9t5bR/RyjId2nAWO83hKuqd2eQVteS18oeJrkVpMyb/MutyMz9Qcx9Fj7t
         5ewQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=TEzH6HpaQew3fZxwCXmJdvtWrZ2HGM8CiNVrwVtCUhs=;
        b=D2WosE2dJyu2EniHsdfRYwGtU7QgLZuChFCkhsodzQrluebcuYBjItGtaw4MxJSJuz
         KF4yg8gjZ6/Zm/unqSIzwIiTUm5Rfp2QBUM3noQq/cND29Uu3bS3SzwqHJUIDxEm9kD2
         TrafTdqy2UJV8CITo7S8USsBDrKSFxE1FeoQkxOiXBryigVCXqtD9dTvJxOfaWsAHDlj
         TSgAgk0d4VYIJeWXd1N7LfcZivxynxZMRbqM6GXJ0D1H+H0loVoBjCVI//zVj5i/03l0
         6RFjbVjruFUojMhrUeDzIXasHwZyUyS9QBDDWb7+foIp62PW3UeQJuXmoGT7QGR0hry6
         kalQ==
X-Gm-Message-State: ABuFfoheaeIAuDRAyo7mUUMpoBSjGNrEzNi+0Ti1/ekqYxb7EWBHJ/ph
        b3xX8ErJVdpaeQ7Yo7QOuFjsKmHRRezkqsoUnekaZQ==
X-Google-Smtp-Source: ACcGV60csJ3UgngZeMaJe6xzQQNpKqbiAQhUItpXNaQ+Xqp249gRQFTFk/XBV0RC4XBsMjmDmXGiLsx/fB52cLnQ10M=
X-Received: by 2002:a2e:215a:: with SMTP id h87-v6mr23267088ljh.102.1539201232338;
 Wed, 10 Oct 2018 12:53:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Wed, 10 Oct 2018 12:53:51
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <b5b1caed-45fe-b418-c137-bcfb52870f1d@nuclearwinter.com>
References: <3af15796-2629-ef87-21c9-2bb3c1366732@nuclearwinter.com>
 <3725e6f2-b1ed-8d3d-aec7-1518dad1cb03@gmx.com> <3bf7c73d-ce25-88ce-271f-ab8c9ae6c01d@nuclearwinter.com>
 <3d82a2b9-41da-26b8-9b74-71d17d8a8a76@gmx.com> <273c99b2-d7e0-bea3-a4a4-7337115beb6f@nuclearwinter.com>
 <0136878c-d4ae-37b0-4903-601367286cf7@nuclearwinter.com> <e84595a6-b1c4-0698-b5d3-251165a11412@gmx.com>
 <CAJCQCtR-j3c99KSpsnUuy5yn5Jx7NAYGXmiDfcrZt4yc8ghCEA@mail.gmail.com>
 <cd4ffeae-0b06-f8ae-1a4e-1165428daee2@gmx.com> <9c7290ea-668d-c10a-9328-91adfac14d5a@nuclearwinter.com>
 <dd08eb00-faf8-cd88-aeb6-e5ed75a2889f@nuclearwinter.com> <4652a690-26ed-fb90-9386-3020ee9e9841@applied-asynchrony.com>
 <556693f8-6985-dd6f-a376-38325ad68e07@nuclearwinter.com> <d885e7ef-c78d-d89a-fc71-f1d4d7b12b31@applied-asynchrony.com>
 <b5b1caed-45fe-b418-c137-bcfb52870f1d@nuclearwinter.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 10 Oct 2018 13:53:51 -0600
X-Google-Sender-Auth: mcfg6wuU3a5y6D7s29MlAM5s4Mo
Message-ID: <CAJCQCtTD-oYza6uQi7aeVWBwyMNGmQY5vya9ZJ-QGKFrpkTAiA@mail.gmail.com>
Subject: Re: Scrub aborts due to corrupt leaf
To:     Larkin Lowrey <llowrey@nuclearwinter.com>
Cc:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 10, 2018 at 12:31 PM, Larkin Lowrey
<llowrey@nuclearwinter.com> wrote:

> Interesting, because I do not see any indications of any other errors. The
> fs is backed by an mdraid array and the raid checks always pass with no
> mismatches, edac-util doesn't report any ECC errors, smartd doesn't report
> any SMART errors, and I never see any raid controller errors. I have the
> console connected through serial to a logging console server so if there
> were errors reported I would have seen them.

I think Holger is referring to the multiple reports like this:

[  817.883261] scsi_eh_0       S    0   141      2 0x80000000
[  817.888866] Call Trace:
[  817.891391]  ? __schedule+0x253/0x860
[  817.895094]  ? scsi_try_target_reset+0x90/0x90
[  817.899631]  ? scsi_eh_get_sense+0x220/0x220
[  817.904045]  schedule+0x28/0x80
[  817.907260]  scsi_error_handler+0x1d2/0x5b0
[  817.911514]  ? __schedule+0x25b/0x860
[  817.915207]  ? scsi_eh_get_sense+0x220/0x220
[  817.919547]  kthread+0x112/0x130
[  817.922818]  ? kthread_create_worker_on_cpu+0x70/0x70
[  817.928015]  ret_from_fork+0x22/0x40


That isn't a SCSI controller or drive error itself; it's a capture of
a thread that's in the state of handling scsi errors (maybe).

I'm finding scsi_try_target_reset here at line 855
https://github.com/torvalds/linux/blob/master/drivers/scsi/scsi_error.c

And also line 2143 for scsi_error_handler
https://github.com/torvalds/linux/blob/master/drivers/scsi/scsi_error.c

Is the problem Btrfs on sysroot? Because if the sysroot file system is
entirely error free, I'd expect to eventually get a lot more error
information from the kernel even without sysrq+t rather than
faceplanting. Can you post the entire dmesg? The posted one starts at
~815 seconds, and the problems definitely start before then but as it
is we have nothing really to go on.


-- 
Chris Murphy
