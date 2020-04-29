Return-Path: <SRS0=gyFW=6N=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D069AC83000
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 19:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE106206B8
	for <linux-btrfs@archiver.kernel.org>; Wed, 29 Apr 2020 19:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="0jtbyK7i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgD2Tp7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726456AbgD2Tp6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Apr 2020 15:45:58 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34205C03C1AE
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2020 12:45:58 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 188so3375030wmc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2020 12:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/aMHNX/T1RmstAZgk60SMCDW2TbLPrQck2J11o50yPw=;
        b=0jtbyK7ivkDCBzOTqSaul8/11EyzzjLVjW/+8xrCUE3XZ4Wbx2eNOG/Lcp7Ta0NHdQ
         Qng/Ld9uWIsBL0oS92eh3dLLmRoTl2kHEOE3kD8cuF0hYihqmVakq2xMHIFTWAkDlJTl
         5PAQpCGARzTalP/Gn0Fw+gD+VPfgYrsUm/w3Qz1X0vVYa1tpuJBDSo9Xho/4qDX48rWk
         /4SHwQk/0mcCBtGDPEOVUsi2FpQXxd1HA9PsjWF3L8PUKbp1gaPPSO2dpyWoaL5R2RuQ
         6djFXKor8qEFulAvu455coh6PUYgrXVA106ejZnUBNt077VzxYswefNT86eNilcC9tGa
         kemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/aMHNX/T1RmstAZgk60SMCDW2TbLPrQck2J11o50yPw=;
        b=dfkd/UrrTjb+0OilmXwVjK2EWez//rUZVx2KizIyDvnF4LyFOPPjczMmoYLKamqrFV
         ApX4Tb6VATDkDl4rn7CQBYQDUPrH62qnrF0YEaqUBokCmXdA+HFwVhNOhfjKw3lTAazN
         DYSYlivHO5bIpzv1TOMKanYecteHZlkZwCMqWtVxuvzkXAefrTSYx4luKZLpUxEaDhWj
         /SduBOIjVxxT4mbBPLv+05bl1pAEfEwg1xcWPkd45H7l3RkQM8vdvurhQyygVU3/LG8b
         r2CGvmqPrCxVH4OBcT9h2ZGXftXZvNb9XidK/EiBc3CQP0nELEbEQMpTNCHl5BvmZS72
         DvcQ==
X-Gm-Message-State: AGi0PuZthv1wQhj42609/kv7PrjXOpF2Ci0ZP6HRi3zRlci+fNnaskzX
        Yup2ySROHRhIqgCo8G3RHNksZ2T4owJg32XUpQn+RphM
X-Google-Smtp-Source: APiQypLUhlKqf3KfbLBmfDyJd3kb6/HjiFIq2EEx/6Qz09t9cQFMp/iuIq1CoQmejf7N2fbqNANPKp1Ye07oyekM3YM=
X-Received: by 2002:a05:600c:2645:: with SMTP id 5mr4905197wmy.168.1588189556635;
 Wed, 29 Apr 2020 12:45:56 -0700 (PDT)
MIME-Version: 1.0
References: <f2e0ca56-c059-978a-2d47-73204b22945b@peter-speer.de>
 <20200429183344.GD30508@savella.carfax.org.uk> <2eca0956-c45a-7d3f-1d04-b05a35db0722@peter-speer.de>
In-Reply-To: <2eca0956-c45a-7d3f-1d04-b05a35db0722@peter-speer.de>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 29 Apr 2020 13:45:40 -0600
Message-ID: <CAJCQCtR6m12EMnC8QWwCqxr9=V9HLEWMGJcXkMYiCxxiPp8qcg@mail.gmail.com>
Subject: Re: nodatacow questions
To:     Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Cc:     Hugo Mills <hugo@carfax.org.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 29, 2020 at 12:39 PM Stefanie Leisestreichler
<stefanie.leisestreichler@peter-speer.de> wrote:
>
>
>
> On 29.04.20 20:33, Hugo Mills wrote:
> > Don't use snapshots, or don't use nodatacow.
> >
> > Set autodefrag and don't use nodatacow would be my recommendation.
>
> Thanks for this smart tip.
>
> I guess, the same applies to a subvolume which will hold images of
> virtual machines, right?

For both VMs and loop mounted LUKS encrypted file systems, I use a raw
file (no format). In a directory that has +C set. So all the files
inherit that.

If the lifecycle is short, or I need to test a virtual size device,
then I use truncate to set the virtual size. It only consumes the
space actually used, so often I'm in the habit of just 'truncate -s
1T'. Often the file system is Btrfs. Yes it gets fragmented. And since
it's a short lifecycle I don't care much. The initial performance is
good, maybe better than fallocate.

If the lifecycle is longer, then I use fallocate. This tends to not
fragment much at all, even with Btrfs inside.

And if I have some hybrid need, where the file system might need to
get better, but I don't want to give up the space right away, I
combine:

truncate -s 100G file
fallocate -l 10G file

If I don't use +C for the file, there are better and worse choices for
the "guest" file system in the file. Btrfs fragments less than a
journaled file system. I don't know the exact mechanism, but I suspect
the constant journal overwrites in the guest, turn into COW on Btrfs
which is why the raw file becomes so terribly fragmented - way worse
than if it were Btrfs.

I think you'd need a benchmark of some kind to see what the latencies
are due to fragments, and it might depend significantly between single
and multi-queue devices.


-- 
Chris Murphy
