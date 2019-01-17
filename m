Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E35C43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:28:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25846205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 00:28:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="VeH4MmqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbfAQA2i (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 16 Jan 2019 19:28:38 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46858 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728694AbfAQA2i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Jan 2019 19:28:38 -0500
Received: by mail-lj1-f195.google.com with SMTP id v15-v6so6997578ljh.13
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Jan 2019 16:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cKzlvwFUx7LuBcd4rdNT9bFC5PmavExeRmeVSVISmCs=;
        b=VeH4MmqW47vB1nlD5O/GkNRDS8KCrHGt6UN1jz3V4p1KJbSZ38TsToH7AlTIsWUwDY
         Iy2ktXYNkVswAgOoXf/5dM5N7L7GdrLM1wO3EOQVGLV7mnp0/+ek+IREu1wdfI4jV/b0
         jzIeL8j9MnBMqeBTm2EnrmWYBzOTklmGO/6c620OHC8ng28FTtO7DKWI+dIRzhYTfn1F
         icclYvdQxX54UK9cM97BUz1ghDlDEU4PM7kvIFe9zweh7I0x9xnhe7sYpPawzxA5hhul
         f9aSpg99VGV2eQfL6xjoyjfqYe8YIEIAG0X00atg7BH9sLMPhw/fVpeDpNQ4RcysCw4u
         boNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cKzlvwFUx7LuBcd4rdNT9bFC5PmavExeRmeVSVISmCs=;
        b=bOUX/vzfHnybysaqfn0q/kbwfhOdtJNGt/TqxyOzY3LmTL6gMMIAatmjZEbsGZemyU
         /CzZxQ0nZTZA4vL9eXfQNbgt4Gein/KzOFYgE3b/jHDENGPNjRimjknMB67WmNE+msBt
         9kMNZru4zqD2sCieQJQuKvzefBGdm0Cu2Qn4NXfmaavNaZwbMFDdYXIDKO2zTPOAbH5z
         vzMcllh9RBXsYrZj9vrLn64xfCjIDbNrC6IomQ/LMnIXbHop3Xg+2iiFjeyUCaw8+U6K
         pJEtDTgTOIYN+yXFRGUs9Jw7cCeim7pTiIT/pZifhT/Sa0NUNc0pK0pHq0Oui63cAgsC
         qXTg==
X-Gm-Message-State: AJcUuke0znvM/i6mkFHjdFlMTyG24+i0mnAJgnKgcygBaPgvpnz6egPS
        aFKQ+z11jD+cNtU5vSddu3PbJhb0sgUcWDZ0/ahcdA==
X-Google-Smtp-Source: ALg8bN7xQK6YgH7cnvpTOcMzAhYhFMlBh/3T0W3J+p/MoaMci6C4f1OUYKiTEjWZlxI2XWBX32EqKaRloQkXGpRC7eA=
X-Received: by 2002:a2e:9ad0:: with SMTP id p16-v6mr8917734ljj.102.1547684915744;
 Wed, 16 Jan 2019 16:28:35 -0800 (PST)
MIME-Version: 1.0
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <2dba4f49-2be5-694b-2676-0fa75a250e2d@googlemail.com> <45de3cc0-b8b5-9e33-fbba-d02505583d2b@googlemail.com>
 <45b6077b-11d2-2db9-ddc5-85743507ba4d@suse.com> <54453a7f-abb1-209a-63f1-b93599ba72e1@googlemail.com>
In-Reply-To: <54453a7f-abb1-209a-63f1-b93599ba72e1@googlemail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 16 Jan 2019 17:28:23 -0700
Message-ID: <CAJCQCtQOfKko2n1SQO8mLHRCGN0zswCWNey9ykMFKE8tZgCSaQ@mail.gmail.com>
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Oliver Freyermuth <o.freyermuth@googlemail.com>
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 16, 2019 at 12:40 PM Oliver Freyermuth
<o.freyermuth@googlemail.com> wrote:
> Since repair did already run (and did not really help, but segfaults after trying some things) I guess the volume is hosed now anyways.
> It's still sad there is no clear explanation for the corruption - I still believe it *might* have been unmounted hard while btrfs-cleaner was running, though,
> but I would hope that can not lead to a non-recoverable state (especially if "only" deleted / to-be-deleted subvolumes are affected).

Well in theory no, even cleaning is predicated on COW. So what should
be true is the trees are pruned and written into a new location, and
only once that succeeds is a new super written. Of course, a
complicating factor is the tree walking is expensive, likely not all
of it can fit in memory at one time, and the new pruned tree isn't all
written out at once either; and then another complicating factor is if
any new files are being created at the same time. You don't want all
new writes to be held up until the cleaning is done.

But if there's no hardware fault or transient power problem or failure
at the time, then all of this should eventually complete successful
and in the proper order. That it didn't, suggests a bug. The problem
is where. Btrfs bug? Some other kernel bug? Hardware, including
firmware, bug?

-- 
Chris Murphy
