Return-Path: <SRS0=3O7H=PG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D77C43387
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 15:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 200E520869
	for <linux-btrfs@archiver.kernel.org>; Sat, 29 Dec 2018 15:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeL2P35 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 29 Dec 2018 10:29:57 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:45085 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbeL2P34 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Dec 2018 10:29:56 -0500
Received: by mail-io1-f54.google.com with SMTP id p7so7906609iog.12
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Dec 2018 07:29:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=GWf+plmdQqnWglG93+W4IErhqF1fj6NDjJ/we9Ugrjo=;
        b=GDYiWhxohXadRsOjZFt915YdEvrnRFOSY5LjBNIV5mi/hHWUGK+Gf+3JXE3J4Wb5KG
         xuCZJiCOWT3ggmuWATa0XIyoAgNigQ0DwPKZXi8gHFLHP4LcXI9d4FM+SXNSR3KnzG6f
         sdKZdIN9lAIO//gzIGbuDzZjCCgv9/rpYWFfpKsTc2jWYWinf3fLDcVIDOLI4JsRCKFX
         bTgRkOHK/Y2UvxSdpVfeFxmtVwgJQQ7DIQPW91sYtZ2yBb3ct3nE0a4vM3iTpycty31M
         BP+VZfFmw7Wjhf8K97ZC3L6SCfNkykClZ/yi5XGyKVo02EOAXL9PxFzrkpuk+Jl4yRkW
         CRAQ==
X-Gm-Message-State: AJcUuke6ZXeHfzEg+9uR1oiJ0mXck4CcQ8a5Wba118eeeu3+Cxm8dzmi
        qfzpYtp3MaZpMrFleILb6PNODtatKURA/xei1jVgMA==
X-Google-Smtp-Source: ALg8bN7a6uE8EEq7qU4sMQ4k/IFvOHo/4javluCzm2MNLT8JowpmxqNKMhTyv8Jhd2OW/KdzlFveTS4A5220DKfrslA=
X-Received: by 2002:a6b:92d6:: with SMTP id u205mr22702504iod.221.1546097395765;
 Sat, 29 Dec 2018 07:29:55 -0800 (PST)
MIME-Version: 1.0
References: <20181128110513.6079-1-andrea.gelmini@gelma.net>
 <20181128155619.GS2842@twin.jikos.cz> <20181128161709.GA9917@glet>
 <20181128170247.GW2842@twin.jikos.cz> <20181128171237.GB9917@glet> <20181213215924.GN23615@twin.jikos.cz>
In-Reply-To: <20181213215924.GN23615@twin.jikos.cz>
From:   Andrea Gelmini <andrea.gelmini@gelma.net>
Date:   Sat, 29 Dec 2018 16:29:44 +0100
Message-ID: <CAK-xaQaMcv47iVnNULzuJnHWDAn2yN3S8aOZXFTuUT2if064xw@mail.gmail.com>
Subject: Re: [PATCH] Fix typos
To:     David Sterba <dsterba@suse.cz>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Linux BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Il giorno gio 13 dic 2018 alle ore 22:59 David Sterba
<dsterba@suse.cz> ha scritto:
>

> I've applied the patch as I need to freeze the development branch for
> the upcoming merge window. There were only a few fixups, majority of the
> work is from your patch. Thanks.

No prob. Thanks a lot!

Ciao,
Andrea
