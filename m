Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4A6C04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 19:52:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CB020881
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 19:52:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="WeGGG7uc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 68CB020881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=colorremedies.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbeJPDix (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 23:38:53 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32827 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbeJPDix (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 23:38:53 -0400
Received: by mail-lf1-f68.google.com with SMTP id o21-v6so15047943lfe.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc;
        bh=e+lpolDFCAtjDKxrmxSViS3gLJmgWGnUmKAnI9yAm2s=;
        b=WeGGG7ucI+l3gAEYRiKTg/50dIsm1+C51hiAgMjT201RcdUrMN8VfCSDNPHlmJgnwG
         1eb4EnDagL180ePeWpiHgWQfow8lGmNBdb3fD5yyC4RGVOcFCsfjLo7VVKcDBqJyyIEu
         5IMf1KD91ZGr8+pZpUzOLfsoOVNNzXFJlp0kqefyYtXwh37NhscKjUmfSDM3B9dVH4IZ
         JW/MDi2+GQvCTfjAGJdipkkGspOXUoy3dYevtQVAXCqfqb4fzQEPwVXw4kVJKZI9Cy4M
         2l2FKY41R9xC+DPkSLRyATbd9lwvYGkgO05riGtgt5okDqHdWMMavL5s7TbjiRuZTC4H
         3zNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:cc;
        bh=e+lpolDFCAtjDKxrmxSViS3gLJmgWGnUmKAnI9yAm2s=;
        b=jycHzSVN9JoKBNYrFbBRIUUBo8B9TZ/nwmfCmAosdWwon8OVRjGQMAntkra3TwImaw
         wvOl5QWhD4GVA6w8KmsyP6cad2P4LLOFXFvCEDfWAGz4R5Lqdq8tqWEq1wrBzD0A4ZwU
         q6xY8Zwx7e8DfjcqB3Ddc37rEBwnzOwj9hdcCs3y2KwGlCcdncUrFizN68fVvYsLpf4L
         t7HMBO/ZiLVb0WrjOR0PKV11ek+ler6PtUK+4Pz2zVfEbO7l4eKTFSOUR51RfJrOu+Cv
         lZsSUfRokhKdYpc/cJDxLxe/cCYv+qssLnii6Ji3EDAbLyHTYLDufY1hphJpIs/hEEEz
         6XxQ==
X-Gm-Message-State: ABuFfojIQg5J/CWpXBfJv91VojyXzu9ues/eHcPPmNvscdg79EP9X7y8
        xGqDlXpalG2kBnAong+VxDZvCEZon6WuJDrHk360xw==
X-Google-Smtp-Source: ACcGV63KrVqHj+scSAbsh/+hh0yenn3iQzl46HcSWHAebbzGgIlNZAEy/Blj6FJe/6lGKYFiZXZBZpMQayy3CeHrlRs=
X-Received: by 2002:a19:4bc7:: with SMTP id y190-v6mr10664383lfa.144.1539633129454;
 Mon, 15 Oct 2018 12:52:09 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ab3:1999:0:0:0:0:0 with HTTP; Mon, 15 Oct 2018 12:52:08
 -0700 (PDT)
X-Originating-IP: [69.7.113.20]
In-Reply-To: <a7dd8412-15e3-f151-986c-8f34decbb532@gmail.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
 <a7dd8412-15e3-f151-986c-8f34decbb532@gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 15 Oct 2018 13:52:08 -0600
X-Google-Sender-Auth: MmjK-OQ8PJ7Dnn9hPdDZ7s31L2g
Message-ID: <CAJCQCtRkqCu60M8_yVdqABidC1H+XB6iM-wVQo9kfnrwMxAHEw@mail.gmail.com>
Subject: Re: reproducible builds with btrfs seed feature
To:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 6:29 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2018-10-13 18:28, Chris Murphy wrote:

>> The end result is creating two Btrfs volumes would yield image files
>> with matching hashes.
>
> So in other words, you care about matching the block layout _exactly_.

Only because that's the easiest way to verify reproducibility without
any ambiguity.

If someone's compromised a build system such that everyone is getting
the malicious payload, but they can hide it behind a subvolume or
reflink that's not used by default, could someone plausibly cause
selective use of their malicious payload? I dunno I leave that for
more crafty people. But even if it's a tiny bit of ambiguity, it's
non-zero. Hashing a file that contains the entire file system is
unambiguous.

I think populating the image with --rootdir at mkfs time should be
pretty deterministic. One stream in and out. No generations, no
snapshot, no delayed allocation. It'd be quite similar to mksquashfs.
I guess I'd have to try it a few times, and see if really the only
differences are uuids and times, and not allocation related things.



-- 
Chris Murphy
