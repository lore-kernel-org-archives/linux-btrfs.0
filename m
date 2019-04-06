Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 567FAC282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A52C2171F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 00:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uLq4zKQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfDFAho (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 20:37:44 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:41123 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726316AbfDFAho (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 20:37:44 -0400
Received: by mail-oi1-f173.google.com with SMTP id v7so6317909oie.8
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2019 17:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=py0p9jEAT70v5tiCJlxtR55BO5mLsGk3++K20VBsPIg=;
        b=uLq4zKQX09/+SfSk7Q5jee0x8Fe50Ux2qtkQwF1vywZSSmWdqiiugdy/TbNxrpXU7i
         QMB2iS1LAxD0vLvceLRfb2J8JZyi/zrx2aNf1KnMZDo+ffg1pLmOOLA7VGzu6c3JvqQw
         gWla22yxSWRan9p6dV3nrLd+oFFhJkONBDJWjDR5hHSJRaskD5QagAWBzGSaYp0xuvVu
         KoNowmEqYqmbkZkeBelG5+vM+FftnzyW2zg177LYliI1AmrNCyfIzvsYyzo7/Q1aNJNL
         3/dRzZaT20RYEP4cMkx66W7v3A5j93GMEdeaTUZfZKq2m1epbnCEkNVM6NqswXcK/L8/
         shyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=py0p9jEAT70v5tiCJlxtR55BO5mLsGk3++K20VBsPIg=;
        b=TzN1YHfgSTG18SpBwT1AKb6OqCGN0SrZKP2+MxicoFGoqUz16pJU0JUxzd0Vu+7Yog
         QtbxlqXiA2dIrRtAZoyw+qiiRno0RWX4kDN726b1Vdx3uwKlT4eRylxFmAccHtXWlLql
         Lhw96s22rb68vd4VDUs4SZFd+csnvSz5JjDV3tfhFNM57WTKA/rDEXwGP0TRFk0vTPXW
         xoHpln0US4QN1Iel1iGzYp1Ef3wBpg/A0AfIKtvv/YmO9KZOwAUxoRlvXVD+CcA/PPQG
         qEqZDzQ6/G4nfVJ9n7G5kX53NpV4XZ7ulEQ17Y88F8k/PkUbj6r7MZY81tts5cva5NkP
         GwsQ==
X-Gm-Message-State: APjAAAUWQKwI8KKR5eabWCz2S2XvCoUL7NxHXKXZQWVRoZnEhI05h9cl
        Hl6yYAn5zgjCr5hqgXBG6l+GGODYv0k6Sel6pRwuY19i
X-Google-Smtp-Source: APXvYqyC/+3zflr1L2eT+7/XMODQ4xm6fzSxe6hvqaGtwOLdt+cpmZf8tG7fPU8Y0wYDkU/VgkxQA2u5bcoB77kQlV4=
X-Received: by 2002:aca:5f0b:: with SMTP id t11mr8504756oib.14.1554511063803;
 Fri, 05 Apr 2019 17:37:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAG3pWAmvekNpnBsQTaMrefKe6pvMSZjPm+SOxnKkMkpGO_1msQ@mail.gmail.com>
 <CAJCQCtQ3YFovgt4tFNQ+uLE81BiD0KFqPdvzE7Rxu+3wujWp2A@mail.gmail.com>
 <CAG3pWA=pzd+xxCrZ92b4TBw5iWtsHkfJQ4nsNrnqcBz_6dX4Hg@mail.gmail.com>
 <CAJCQCtTgfVY9g+A3m=FA_k0O-kbMGifz8QF62W2LMVmW_C8wnA@mail.gmail.com>
 <CAG3pWAkZdzD-W2HHd46bdyAzHwLdOt-t+LVXhWgV_bBkUmKBVg@mail.gmail.com>
 <CAJCQCtQs_oBAXB4UzY1xGuZatqrCb0=+3y9g8T2f2v+6eEg9RQ@mail.gmail.com>
 <CAG3pWAmMHnsC_cgiy+5Rt5vunW6cAw8FcZW_zHPWOQttx2Z=Nw@mail.gmail.com> <CAJCQCtQ4Xe+Co7z2Ry_SpBg4O7rZ_4NWx48rtGQAA5Um+L6z4Q@mail.gmail.com>
In-Reply-To: <CAJCQCtQ4Xe+Co7z2Ry_SpBg4O7rZ_4NWx48rtGQAA5Um+L6z4Q@mail.gmail.com>
From:   Glenn Trigg <ggtrigg@gmail.com>
Date:   Sat, 6 Apr 2019 11:37:32 +1100
Message-ID: <CAG3pWAnJV9+L_CTxXjXAcd58OKBqVkLDF0dPEzZSLKw88-OYPw@mail.gmail.com>
Subject: Re: help request for an unmountable raid1 filesystem
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Chris,

On Fri, 5 Apr 2019 at 17:45, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Thu, Apr 4, 2019 at 11:51 PM Glenn Trigg <ggtrigg@gmail.com> wrote:
> >
> > Hi Chris,
> >
> > Thanks for spending the time and energy to help me look into this.
> >
> > btrfs restore isn't very happy either, so I guess I'll wait until
> > btrfs-progs v5.0 comes out and see if that helps.
> >
> > btrfs restore says...
> > % ./btrfs restore -v -D /dev/sda1 /data2
> > This is a dry-run, no files are going to be restored
> > parent transid verify failed on 628168376320 wanted 37601 found 37712
> > parent transid verify failed on 628168376320 wanted 37601 found 37712
> > parent transid verify failed on 628168376320 wanted 37601 found 37712
> > parent transid verify failed on 628168376320 wanted 37601 found 37712
> > Ignoring transid failure
> > ERROR: child eb corrupted: parent bytenr=628624064512 item=0 parent
> > level=1 child level=1
> > Error searching -5
>
> I'm gonna suggest that's a bug, just because btrfs restore needs to be
> expected to do better than this. I suggest taking a btrfs-image while
> waiting for btrfs-progs 5.0.
>
> # btrfs-image -c9 -t4 -ss -w /dev/ /pathtoimage/

I ran this command (using version 4.20.2) and after a whole bunch of
WARNING: cannot find a hash collision for ...
type messages it then produced this output:

Couldn't map the block 1350591496192
Invalid mapping for 1350591496192-1350591512576, got 1469008838656-1470082580480
Couldn't map the block 1350591496192
bad tree block 1350591496192, bytenr mismatch, want=1350591496192, have=0
ERROR: unable to read log root block
ERROR: create failed: No such file or directory

and no output file was created. This doesn't look very good!

Regards,
Glenn
