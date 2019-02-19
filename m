Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A606BC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72DBE21479
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 00:17:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="I80k+ZOV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfBSARW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 19:17:22 -0500
Received: from mail-lj1-f173.google.com ([209.85.208.173]:43423 "EHLO
        mail-lj1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbfBSARW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 19:17:22 -0500
Received: by mail-lj1-f173.google.com with SMTP id z20so14850741ljj.10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 16:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X3/+6tt43qDR9YCNikYZd3HqckNx3hKbYrj1wl7wvck=;
        b=I80k+ZOV3iNlyt7IKjsJ0Efb9keSFfj37YkY/lfZyG+zcoPnsaWLHVJ44ibnup5dSx
         N7Ri7bARusElHOs2iwsvNNx2yY5hAObhxadd4hcyrw54f4LCJea5U5eWMV6WXEkbTEJR
         hN7TmxdTfiwzBpqYUdMWycqNagijP4UvNj80tczmQkiklx+CzQqMuX6tJuF0iDwqeTUk
         pXi824r9hnsfmMXr2dIb27tIeDosqnwIPZ9OhzmxweQvYlrSFLPLZeO3Slh0eYzmntAx
         jnGO7CfgZDY2fNa809LVjrsHAZJWuWcPAqklsP0dJ3nKfLO+kbQnzT3xkoLvLI0pOyuQ
         O9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X3/+6tt43qDR9YCNikYZd3HqckNx3hKbYrj1wl7wvck=;
        b=Aj1n7H4ygdC0ohjLRMU9tMKBv37EccFK2IOOCs2b8SOsZQGAWJ4nHFodU7WqbVQh4S
         Zi3UOx4c/0VjxCV2PNlCGoMahUtRPlKNLiVYMPs+E33zR6HSVaez285TXyx7uVrOjQmt
         qvHYmKCZR6kVQ07mJgpFK73Uca7KXhQqhxSfLXToOk2WuMli3upS8gHRh3pLm0wHSPr2
         bNR6t9OQfPlXAfmnT/A1SQNNPIokSgw/JEP/lC6AOG4xKLDLRYqZgd80xItJkB6o2acN
         4oMooQ5KX0eTqoSYi7JfTkVYak4FBaaFV1Vfak3BIQM1adXovrQYLhsQ7ceym66KvJXj
         OHSQ==
X-Gm-Message-State: AHQUAuaJE6e9Anj9jTUSdkVKl8mUFG0//KT3NNyn6IwKer7egYx6iqMR
        YJzP/w2o8uijRn/45j0qTghN83hpkZyCDrrAkrTrpr6B
X-Google-Smtp-Source: AHgI3IYSjPJq30IvO14b3MbPYtUAbZe/zUClSq35cefuJY5Zugr0q3kIzy6L1dUutSrX0Ge5QhcyA32DbfrQv4uPha8=
X-Received: by 2002:a2e:2202:: with SMTP id i2mr11468240lji.170.1550535440017;
 Mon, 18 Feb 2019 16:17:20 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org> <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org> <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
 <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org> <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
 <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org> <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
In-Reply-To: <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 17:17:08 -0700
Message-ID: <CAJCQCtSZko7XHi2Zk1TSdGVysbQgkd3JO83fuNjNMuj-EUSkzA@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     Chris Murphy <lists@colorremedies.com>
Cc:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 5:16 PM Chris Murphy <lists@colorremedies.com> wrote:

> rsync'd subvolumes across volumes aren't consistent identical by btrfs


s/consistent/considered


-- 
Chris Murphy
