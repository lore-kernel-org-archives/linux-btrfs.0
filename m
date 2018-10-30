Return-Path: <SRS0=iJ2R=NK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA94CC2BC61
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 15:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A95E620657
	for <linux-btrfs@archiver.kernel.org>; Tue, 30 Oct 2018 15:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WGdBnrn7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A95E620657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbeJaAXI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 30 Oct 2018 20:23:08 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37096 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbeJaAXI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Oct 2018 20:23:08 -0400
Received: by mail-lj1-f193.google.com with SMTP id c4-v6so11786614lja.4
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 08:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SZtmXnmJyWcV3ODY01HTI6Wn9QrRQ/iAqsvYQvID67M=;
        b=WGdBnrn7F16rz92FKgx1F4F3xq2L9ulvrmEfPrKuWXMSJg17Aa63Fxb4Gpe3Qz7ahS
         SQx/RzzxMUHxL+geYcHIhSUG6fGusw3Q4xKa1lJPbq7lgRXc/NSDMDIEFgl3LPHIqfJ8
         80TSVyN3Gc0SnuacfrYuhwkcImopJDcH4u/ig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SZtmXnmJyWcV3ODY01HTI6Wn9QrRQ/iAqsvYQvID67M=;
        b=gLiUciFLVyaBnwkXW16PTJR5wYM9J5RFIbMtNT33a0mr0bdxEuDDtnI1okw9H4nJCX
         +vfE+ilx3f8mWH5z5n2uwG2+5/mZWscZmB5IPfarv2tZK0l9wv9mmo1t8gb/ZCh4VjOF
         MQmU3OGiSVjmnKBMrh5uMdfVSGxFaX/HvLsPoEIvVs4WhHEbAedrArEBb0I6G3UANTjO
         2ti0j1RmN0QI5Xjb2T+UdEXY5E1cLi2quEY4oC13tdbMPAMIPZf+g/PCgFmy4fz4nor3
         mT6idz0NQkrOto35uW8boqs2cO9eCv4eadRabvNStE+5YsG71egM7C/8xYas+GRz7+CF
         V08A==
X-Gm-Message-State: AGRZ1gLT/FdrOORVr3Sfj41h5wAsZcZ52BxYhvc+X8LNx2nRhQXcRsUN
        sKTchNddKtifH8+SppSo5GRj8kM6v3BeaQ==
X-Google-Smtp-Source: AJdET5es42cuuxI7KrPpj0p3A7kh20bQ78EeD3fvZeAxQnLDrTOCYK0oF+fMcNXoWtqsvv7eoH8uRw==
X-Received: by 2002:a2e:5dd9:: with SMTP id v86-v6mr8025208lje.86.1540913351294;
        Tue, 30 Oct 2018 08:29:11 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id o2-v6sm1200956lfl.2.2018.10.30.08.29.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Oct 2018 08:29:10 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id d7-v6so9203438lfi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2018 08:29:10 -0700 (PDT)
X-Received: by 2002:a19:7019:: with SMTP id h25-v6mr2315708lfc.147.1540913349579;
 Tue, 30 Oct 2018 08:29:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1540904580.git.dsterba@suse.com>
In-Reply-To: <cover.1540904580.git.dsterba@suse.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 30 Oct 2018 08:28:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgPmELRt00f1tbOoG4kMU6Kn1nvF1AysxXJk2V45WPNJA@mail.gmail.com>
Message-ID: <CAHk-=wgPmELRt00f1tbOoG4kMU6Kn1nvF1AysxXJk2V45WPNJA@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 4.20, part 2
To:     dsterba@suse.com
Cc:     Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 30, 2018 at 6:24 AM David Sterba <dsterba@suse.com> wrote:
>
> this part contains a few minor updates and fixes that were under testing
> or arrived shortly after the merge window freeze, mostly stable material.

Pulled,

                 Linus
