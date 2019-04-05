Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DAFC4360F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 474B8206DF
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 06:45:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="IEUKZ+ps"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfDEGpC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 02:45:02 -0400
Received: from mail-lj1-f182.google.com ([209.85.208.182]:39926 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbfDEGpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 02:45:02 -0400
Received: by mail-lj1-f182.google.com with SMTP id l7so4242759ljg.6
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Apr 2019 23:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PpT0xJ+QbUMv+O2M6kuS4R2fmOmGPyctFf/jKBPTIsw=;
        b=IEUKZ+psxv67IafXlJ059nssdaWBNIiKrFvavqudK76Tt5tRbMcZ1X4mGLoeeWNan0
         ImROvZnSQNKuuSZQ0gFN60ILgw7DkTEXffPSaGK+QYWymbUUoclBYA5F+6o/Q87lSHbu
         oc1QHM6ifqBMdkjN9XLCV7L6Za0WdWRIP8JKhXHICAT71k2ISUjRbIIVAjDC2tvfTMfd
         yBbdu6jhHixUGTIgHs4vpLPQFjPm2uBAXJGCJzA+1ct7liAasC5sTrlARBX7FlVIbL+i
         W+s0jd4Uk4qSPCiKi3JqLcoYMk3ItuFGHJt+WDCYZPA3B/wJtUIfRpI8KZiI9lpPr+cN
         k40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PpT0xJ+QbUMv+O2M6kuS4R2fmOmGPyctFf/jKBPTIsw=;
        b=hbaAdCEfTN+TH55ee8R/TZTeZCvIYWDsOaC1O5PeXZahdVgBC5s1PTJt4m85LioOHL
         Bgtq5cqMw7ut2FUenPvq2ebGK4spWhZcipYAL/E32UPS7G4uAnjIyGD6A+EWcV5tESUp
         gexwqB8LpWG1RqGxf//FqJ+jyCX/H3o7wHM7ZpZLssfmkEnNuczXi7JVRCfDTpA+kWgm
         +F7egYB1fxnqiIrwezgwpecy7toJBo3Y1p7UETMXkNETuGKhG+hpRkO9BV4YElSdtlzz
         b96962xNO0E2An5E3r7pXsF6ROi4wKVSIqDM9G/L0A5crjgqW+ivXAILo8qNUWE/gfzf
         yH8A==
X-Gm-Message-State: APjAAAX8PlmRayQcsJWEvmZF6aIFuN2GioFqzSgjYqxqfhqdNlJiJM9z
        89HFT761DifnoNR1sHYHeR1nKZf0J3aerL0g/8TPbw==
X-Google-Smtp-Source: APXvYqyn9tnVdRXCAKkeTxTWBpBos6zMocTHwljF2GpmtnTGXEieRLyhSq2XGjOtcjH8N3zVWNOBK7o6lLdR0PlSqZ0=
X-Received: by 2002:a2e:380c:: with SMTP id f12mr6251015lja.116.1554446699945;
 Thu, 04 Apr 2019 23:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
 <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
 <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
 <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com>
 <CAJCQCtQs_oBAXB4UzY1xGuZatqrCb0=+3y9g8T2f2v+6eEg9RQ@mail.gmail.com> <CAG3pWAmMHnsC_cgiy+5Rt5vunW6cAw8FcZW_zHPWOQttx2Z=Nw@mail.gmail.com>
In-Reply-To: <CAG3pWAmMHnsC_cgiy+5Rt5vunW6cAw8FcZW_zHPWOQttx2Z=Nw@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 5 Apr 2019 00:44:48 -0600
Message-ID: <CAJCQCtQ4Xe+Co7z2Ry_SpBg4O7rZ_4NWx48rtGQAA5Um+L6z4Q@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Glenn Trigg <ggtrigg@gmail.com>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 4, 2019 at 11:51 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
>
> Hi Chris,
>
> Thanks for spending the time and energy to help me look into this.
>
> btrfs restore isn't very happy either, so I guess I'll wait until
> btrfs-progs v5.0 comes out and see if that helps.
>
> btrfs restore says...
> % ./btrfs restore -v -D /dev/sda1 /data2
> This is a dry-run, no files are going to be restored
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> parent transid verify failed on 628168376320 wanted 37601 found 37712
> Ignoring transid failure
> ERROR: child eb corrupted: parent bytenr=628624064512 item=0 parent
> level=1 child level=1
> Error searching -5

I'm gonna suggest that's a bug, just because btrfs restore needs to be
expected to do better than this. I suggest taking a btrfs-image while
waiting for btrfs-progs 5.0.

# btrfs-image -c9 -t4 -ss -w /dev/ /pathtoimage/


-- 
Chris Murphy
