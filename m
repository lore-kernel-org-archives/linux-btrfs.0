Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5220BC10F0B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDBB8214AF
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 18:28:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="BU0Ni+s5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbfDBS21 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 14:28:27 -0400
Received: from mail-lf1-f54.google.com ([209.85.167.54]:39506 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728978AbfDBS20 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Apr 2019 14:28:26 -0400
Received: by mail-lf1-f54.google.com with SMTP id m13so9742078lfb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Apr 2019 11:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Gtn0w13+dKrHIgMFOQMHi8OLT1T3PRWkVeTpEek4U+o=;
        b=BU0Ni+s5n5iLUp9VAhH1jmmHGXbWgKXPM9cqJF9VDmOqdC03qZBvmF2gpFcuQwf+1R
         kVSFjQ4JGewUG2i1fGDmEJgPFrIlmdRS2VVEtUMhzgFfrroFmcwS3htyDutHWxtx3l/n
         NVg+C/shDnu331U+0G4cjlL6fJDNKBgmSj7W7HPEcwcxJkg4Fd9xKuqcD9S6TeLEtb5E
         ydiAQxYiVI/WRL/O1IirWDmu1msByMmk4a9eoWk2tTjjDJzODkV3oa3dFFnY9koAv/uK
         xdzabZEDpm6TEnAgJbc8Stu/Z0u3yawUMoju+aBsmfo3zSRLp14DnPKUNJS6LDwxqAfE
         Ur3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Gtn0w13+dKrHIgMFOQMHi8OLT1T3PRWkVeTpEek4U+o=;
        b=Fw9RpkWFKV3yjQem0s0tdKodKgJJnOmU8muiQ0neOpUo+eSDY1+LosMpqT5zAaTaJm
         a4DrwdFzUVfETRoENDPbEXMarr91ELwbbWu+oX9+egv1+sEjR2LiiuHvTPjvdfdJfDP2
         /mytIbxPcc+awk9/1qfjsJk/fEHhayobrgMymG1jQimgps84UoJxz6szybVdhGfYIESq
         Q1wxaxmUeBlrzJQo1zPvHNJ/9vCIhwt/r4AfsX+cfQtxS4ni6PiB+No3TFXymJX/BOsm
         3mlkvr38jx+CjmV+hU4fiGOSruCDTXpK65eNqxbAb40ojmw+d07x8JE8ECPFZ5pcUyGC
         FdmA==
X-Gm-Message-State: APjAAAXMfq6miLEiYVl34QCF9sz60oxP3qEcic4CAKe0JIDHGIfZnLAN
        Q49g5aHglqO3YaF/83KQyCOmZm1P0OBHqqQb273C6OtOiJg=
X-Google-Smtp-Source: APXvYqwS+Fh73x7va0FkFx6h8rqBQNXGskTPDY35ZltIGQIcanT2OUKbK4OTIudejuRQuCRojv8e82Fvh08CsZrXMo8=
X-Received: by 2002:a19:5201:: with SMTP id m1mr2798354lfb.68.1554229703814;
 Tue, 02 Apr 2019 11:28:23 -0700 (PDT)
MIME-Version: 1.0
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu> <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu> <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
In-Reply-To: <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Tue, 2 Apr 2019 12:28:12 -0600
Message-ID: <CAJCQCtTZ94yLHChBbtEs=GOUCL44RdRhMXvX8358SumGp_6fKg@mail.gmail.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 2, 2019 at 7:24 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
> On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:

> > On the larger file system only "btrfs check --repair --readonly ..." wa=
s
> > attempted (without success; most command executions were documented, so
> > the results can be made available), no writing commands were issued.
>
> --repair will cause write, unless it even failed to open the filesystem.

It consider `--repair --readonly` is a contradictory request, and it's
ambiguous what the user wants (it's user error) and the command should
fail with "conflicting options" error.


--=20
Chris Murphy
