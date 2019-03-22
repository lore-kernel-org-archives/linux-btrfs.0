Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC37C10F03
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34179218E2
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 13:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfCVNhd (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:37:33 -0400
Received: from mail-ua1-f65.google.com ([209.85.222.65]:37544 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728140AbfCVNhc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 09:37:32 -0400
Received: by mail-ua1-f65.google.com with SMTP id x1so744187uaj.4;
        Fri, 22 Mar 2019 06:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XzQ9NHyI634XKb+UUobZCMcWq8m8E9RK1f4ELxnBy2E=;
        b=V1v/AnSzmYyzfgtTGbdWoSkqLVLaYuJoNGCkUfnE6xPn6rGBm6rwYo4QDADjnaY0wQ
         BXqC7l+6BAE4eOrjar1GbFHv99ONn1xR7HIIMPq/QETAWXHN3w8MpCzQ+YXBFBrn/0qC
         YqwIleqEs/o+6Pq+43Ir43txZgWSA+hkXMzoD/PZe/NAfih+blQRtEU/Q4gZTS/yvM+6
         cl+4x6aLPjvKnVrygfhOmnvIVSRbheBHCCA6UHhVFLTYLe81saehixXRov1vaX1iYhz/
         FH2J7suVfmwqRnHb1xJEoWOzK0zMFKnDurbsmn9GQTIx2BPiTzi3wtsgrHoSTlg5DccL
         tY9A==
X-Gm-Message-State: APjAAAWiIQu/M1n/5ZHrazupQk8BYqApPh9h1Y+Sv1a3dKS81hknWLOt
        jLiXOv/5Gd2C05GMTW2sxVsR0stTpF7O2IqI+OrgIw==
X-Google-Smtp-Source: APXvYqy4ogpwjpSonoiPfh2lc9ghBw42usNLeIrbxmtszFsz2NZOsJfJk0zpTsb127+lhrr709ywFNgm7FrLQ8o0S0U=
X-Received: by 2002:ab0:6419:: with SMTP id x25mr938049uao.86.1553261850477;
 Fri, 22 Mar 2019 06:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 22 Mar 2019 14:37:18 +0100
Message-ID: <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
To:     Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        linux-um@lists.infradead.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-block@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        sparclinux <sparclinux@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Sakari,

On Fri, Mar 22, 2019 at 2:25 PM Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
> The printk family of functions supports %ps and %pS conversion specifiers
> to print function names. Yet the deprecated %pf and %pF conversion
> specifiers with equivalent functionality remain supported. A number of
> users of %pf and %pF remain.
>
> This patchsets converts the existing users of %pf and %pF to %ps and %pS,
> respectively, and removes support for the deprecated %pf and %pF.
>
> The patches apply cleanly both on 5.1-rc1 as well as on Linux-next. No new
> %pf or %pF users have been added in the meantime so the patch is
> sufficient as itself on linux-next, too.

Do you know in which commit they became deprecated, so the backporters
know how far this can be backported safely?

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
