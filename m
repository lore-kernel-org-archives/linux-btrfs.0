Return-Path: <SRS0=uY43=RP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04CDEC10F00
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F2C020693
	for <linux-btrfs@archiver.kernel.org>; Tue, 12 Mar 2019 15:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=urbackup.org header.i=@urbackup.org header.b="GrNDRH1q";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="rkB7q0DD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726815AbfCLPsW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:48:22 -0400
Received: from a4-4.smtp-out.eu-west-1.amazonses.com ([54.240.4.4]:57164 "EHLO
        a4-4.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfCLPsV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Mar 2019 11:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=vbsgq4olmwpaxkmtpgfbbmccllr2wq3g; d=urbackup.org; t=1552405700;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=WmBfPZiCb7QiRr/GsV9yGqpV4J0GvdTKHevTIwt1ptg=;
        b=GrNDRH1qIgRhe1snL95DL5wOtusk4cdGk4Y6UVj3BORZ5r59COi0P41T7FgSBAER
        YaGqNhCJTHS57O6RLWWJFz++zuow9py1W+qpOWJHNXMaQg0q5VujrXXjeNnbURcf1mi
        6cthEKADTsPs+ouqoyjJPjhYN35iNI7uuGiZPreI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1552405700;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=WmBfPZiCb7QiRr/GsV9yGqpV4J0GvdTKHevTIwt1ptg=;
        b=rkB7q0DD+c78r6epa6LUU/HiHIXxE1PGoO+eWoiIPh1TuXgVsSkiZalCub/okERW
        b8rQfkDNFNplEt18D1XUXZ8/v0ramqrQSOgIB7QoZf6ArOwlFJdKuDyV4oIGppxCOP7
        pOB8rlQwLAQ7SRsXqRMgNizb1DQnnhPEz1MPa3Rc=
To:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From:   Martin Raiber <martin@urbackup.org>
Subject: Allow sending of rw-subvols if file system is mounted ro
Message-ID: <0102016972971d54-e7d79438-f177-48d2-ac42-55f162b6b63f-000000@eu-west-1.amazonses.com>
Date:   Tue, 12 Mar 2019 15:48:20 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2019.03.12-54.240.4.4
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

I know there are corner cases that probably make this difficult (such as
remounting the file system rw while a send is in progress), but it would
be nice if one could send all subvolumes as long as a file system is
mounted read-only (pretend every subvol ist read-only if the file system
is mounted read-only).

Background/use case:

Through no fault of btrfs, metadata got damaged, which makes a file
system go read-only after a while and I'd like to btrfs send/receive the
subvolumes and snapshots that are still readable to another btrfs file
system (btrfs send/receive being the only option that does this somewhat
efficiently). Only I cannot send the subvolumes that are not set to
read-only prior to the file system going read-only.
I patched the kernel and btrfs-tools (just commenting the checks out) to
support this in my case, but it would be great if this would be possible
without patching.

Regards,
Martin Raiber

