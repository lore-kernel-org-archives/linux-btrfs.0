Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81309C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 09:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C5C120835
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 09:38:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C5C120835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbeJJQ7N (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 12:59:13 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:40948 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbeJJQ7N (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 12:59:13 -0400
Received: by mail-oi1-f193.google.com with SMTP id j68-v6so3554822oib.7;
        Wed, 10 Oct 2018 02:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tnkT4izmftR5GAe0cowLcCY1pNJ+dLUIOXbSQLCpn9w=;
        b=fhMs1NT+mLuQLS0rwbYDOJiVti/GU4OMlvraVPlHCiuRTNi9Kln+U63ljvJu89TVRY
         eR0VCngfK0g5h8m7HDj6mOTWgPvLehL+s11CoofX9d3M6igL90uahjRm6Gzi5jqygRlk
         uAALftflCrDf9gYLvX6rMJJAGWNblOTlKV9DxoTKUGh+/OExCJC5iZmjaxkRuUP6U6s4
         e1n2GeRSZWsPQ8efo32HTJoapbe0bj3D5ORvv4Br5CSuVCHhnox3OJfzSVe5QYyBm6Xn
         p6uHen4p/avBDhjwx2W6WPkgw7Sr1vTt68LhFX5wkCg94TVKwF8VV+NwW9YcSeWjCRCG
         faxQ==
X-Gm-Message-State: ABuFfohtISH4Mbyue9cio6xGTvbu4XX+BhGtm/cCyhIT6fFR7Tc0Cflc
        dwZrf+fDVcTJv/8BRra74urspkNr/jMs22jrH84=
X-Google-Smtp-Source: ACcGV620VNaHa2ODB19mWW61iA6JpJj1h+DV3pSLC13xTKD5RrtP1PXacHw887xAGnqo56R0CZo4Z0ggQqG5VoawjUo=
X-Received: by 2002:aca:af91:: with SMTP id y139-v6mr1084766oie.322.1539164272549;
 Wed, 10 Oct 2018 02:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20180919220444.23190-1-linux@rasmusvillemoes.dk> <20181009112013.14238-1-linux@rasmusvillemoes.dk>
In-Reply-To: <20181009112013.14238-1-linux@rasmusvillemoes.dk>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 10 Oct 2018 11:37:41 +0200
Message-ID: <CAJZ5v0js_Lp6zh3b1O3R_oM6F9RehAj4wr5xz26hTg=A6zHDBQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/23] various dynamic_debug patches
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     jbaron@akamai.com, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        linux-btrfs@vger.kernel.org,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 9, 2018 at 1:20 PM Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
>
> v2: Added various acks/reviews. I'll follow up with rewriting the x86
> part as asm macros once that work is in mainline.
>
> Patches 15, 16 are in next-20181009; in hindsight I should probably
> have asked Rafael not to pick those.

So I have dropped them (which was easy enough to do).

Thanks,
Rafael
