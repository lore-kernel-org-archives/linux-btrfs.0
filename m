Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BEA6C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 10:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDD620672
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 10:59:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KdKNbue2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECDD620672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gelma.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbeLEK7o (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 05:59:44 -0500
Received: from mail-lf1-f44.google.com ([209.85.167.44]:46587 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbeLEK7i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 05:59:38 -0500
Received: by mail-lf1-f44.google.com with SMTP id f23so14357034lfc.13
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Dec 2018 02:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kJDb0BNhdjLReSP5EDL2hrFa/VJA5hNqpaNxxH7SJSI=;
        b=KdKNbue2JmZsP8l/R63GpUIwj7TNFPitGzMK8A2H8HRszoNKL035eizM2+4o2HNBqH
         y40nMluGNPlWlmtwJ2P9sgeuwR0auV5p0J2IWZhWfa6L8fd5yY6yWrl57JyPsZ76vAzR
         s5Du5+u2kGbI9IhwDmo1OVYxAo+L9IXMYu6KPi63ssAv8R5rBTPa3SEifBb5wAk2Iw3f
         QSHr6IP1M6VtUzqPYmotLIkoQE1uZftazN23RoYjYLlW4iH3+0T3AG9ngH/1q86crSJM
         W9aAJJIWtdlpFxZmGr04tgWSAc7D8KrH1G1oFAdR0Zt6pVWhH2yg0QxKcU1m6NRFbiKF
         viBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kJDb0BNhdjLReSP5EDL2hrFa/VJA5hNqpaNxxH7SJSI=;
        b=ps2+RnMSrVIEWyjxYZgC/QuhI3FJh1xM2njs+umde0UVMFSgvlASSdEnK2F2JwThLQ
         iT8A20mMwE+xufl3PmGznUcdt5fHW4bU6OxJf3K4dHGU+yNkUoeR9yYl335HN4UK9BMx
         6qYpyOJEOam2r7B6cDk+XFOFjYvyMii9D0O0R06qV/ohFWHu2aV8IetWVIRlULPbCfMZ
         KgiDr5AuB6Fbsddz8j4RjQzev/tmmIAyuPK6hB0ua9lMtGoA/FI0RgQixhF+OwbfhOwu
         KPBP3DG8cHkrWSGtICy0OrXhQZm3gwYQMeqeYcARKQaoBxcU/6i7eH7vdq14IuBeGvsp
         5oPQ==
X-Gm-Message-State: AA+aEWZkXAhQyuqnvXihL7Zno7bCBbPtE51qb+xC9ftXrzU1Abi+MB2/
        rHA8DD3n4F9IEWw+y/PckU4=
X-Google-Smtp-Source: AFSGD/XXiZJpF+sYVsHWgHA9L72hZ9eMaUsX4zHs3onpURKk2CngwUoqh71wG9zkzmGMs6dvW3D+qQ==
X-Received: by 2002:a19:9a8c:: with SMTP id c134mr13392084lfe.152.1544007575018;
        Wed, 05 Dec 2018 02:59:35 -0800 (PST)
Received: from glet (anon-39-32.vpn.ipredator.se. [46.246.39.32])
        by smtp.gmail.com with ESMTPSA id m77sm3558179lfg.3.2018.12.05.02.59.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Dec 2018 02:59:34 -0800 (PST)
Date:   Wed, 5 Dec 2018 11:59:28 +0100
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
To:     Chris Mason <clm@fb.com>
Cc:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Linux-next regression?
Message-ID: <20181205105928.GA29665@glet>
References: <20181126150137.GA16029@glet>
 <845890af-0659-fbfa-c445-d6f109bd5015@gmx.com>
 <20181127141144.GA23269@glet>
 <4f1bb6e7-434a-47d2-a75f-8aca702f5395@gmx.com>
 <20181128160523.GA5288@glet>
 <FEDBF117-C83C-4DEC-96D1-A549DBCF4950@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FEDBF117-C83C-4DEC-96D1-A549DBCF4950@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 10:29:49PM +0000, Chris Mason wrote:
> I think (hope) this is:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=201685
> 
> Which was just nailed down to a blkmq bug.  It triggers when you have 
> scsi devices using elevator=none over blkmq.

Thanks a lot Chris. Really.
Good news: I confirm I recompiled and used blkmq and no-op (at that time).
Also, the massive write of btrfs defrag can explain the massive trigger of
the bug, and next corruption.

Thanks again,
Andrea
