Return-Path: <SRS0=HC3m=PY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD17C43387
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:13:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2951C20657
	for <linux-btrfs@archiver.kernel.org>; Wed, 16 Jan 2019 01:13:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="s62ljoAV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbfAPBNo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 20:13:44 -0500
Received: from mail-ed1-f52.google.com ([209.85.208.52]:33344 "EHLO
        mail-ed1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727183AbfAPBNo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 20:13:44 -0500
Received: by mail-ed1-f52.google.com with SMTP id p6so4155610eds.0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Jan 2019 17:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:references:cc:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kV2necA3ojhTq0/2ZkSHXFWovuJluyySWu9yO56VIV0=;
        b=s62ljoAVm0R5HZtfEOWfprpLwzMLBjOeCGTdcgVTJ+3/VPC2CJ6S2q094AOPrlABAO
         9/DpMLDrPmgV7q2u9TWVRGMbtwa/LeZiBD9ZShlYDSXcNHQr63nE3rZ1qkmdi6UApDoP
         CS+LwtvUUJYCdr4vZjzVCRv7YU5feh4dEJInipl5njsrjgDlZIlil3GseKjykdaSXh0O
         kIAee26uwDGdCEuXaZuGDQRDEUqLl8xS3CZ9o1ybLqoK8fbh3+wNgdyJV979YtzriZZu
         nHN+AO4+NHRDWRVvYCLdBa4VGEaGFRYT7j8917nFAtBdDBuOMftuyKisQepeCUkpaI/i
         dQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kV2necA3ojhTq0/2ZkSHXFWovuJluyySWu9yO56VIV0=;
        b=LzwADMq8g3fLx0429GUohWEJP1XjH9R/Ilfb15sLnO8qpF9XSgPosvHhmfnrUCzw/B
         jOIErut2+n6yGN+v9NoQ9Vj6Fsf7oH+ZoSELgVvnuLaprt7xOCJk8SUkaiZdI8/1Sk3w
         RewVbupF9FwhED8Y1ttZpfEoClVBRpG40+KvR9g12fbS2a6UEnwMiUBT99EvHbVDV1od
         ovli3ck1rt5Qhv48WojEweGNdVh9wnQ+FLv9H1BghF4360Sb8ksirpzUhXKjQqV4Llgo
         Z2fX7+ASEYfDVg5dGtYq3KL1UbDVuY8mAJCCXQ+2foBXIs7akGYyPyIVkTKrvRPUIRlM
         NBug==
X-Gm-Message-State: AJcUukdlLRSFova5zMEoP1qb8FtIV/ENByeD1/CsGRL9q4kFZ7Pedmmj
        eB5TmG4Qff66lmgC+yF1a9Xvv2Dq
X-Google-Smtp-Source: ALg8bN7Q9PLESsksZABW1e4FwS430E5OdgKoslaCV8/TcpomsntP2l+HEvx04rip4txX9ztWqpOp3Q==
X-Received: by 2002:a50:e691:: with SMTP id z17mr5261742edm.275.1547601221028;
        Tue, 15 Jan 2019 17:13:41 -0800 (PST)
Received: from ?IPv6:2a01:5c0:e088:2f20:fa16:54ff:fe84:9770? ([2a01:5c0:e088:2f20:fa16:54ff:fe84:9770])
        by smtp.googlemail.com with ESMTPSA id c23-v6sm2936455ejb.62.2019.01.15.17.13.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jan 2019 17:13:40 -0800 (PST)
Subject: Re: btrfs goes read-only when btrfs-cleaner runs
To:     Chris Murphy <lists@colorremedies.com>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <16012349-e490-6659-8e94-2d4c57c2c3a6@googlemail.com>
 <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From:   Oliver Freyermuth <o.freyermuth@googlemail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=o.freyermuth@googlemail.com; prefer-encrypt=mutual; keydata=
 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
 KB7t2CoZv5xo0STm
Message-ID: <5a42a4d8-0c4d-ab6f-c085-cd9d3aae6614@googlemail.com>
Date:   Wed, 16 Jan 2019 02:13:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSFxdRVeEv_G-ka3oenaR2e=HwNJ0ni3Fxn=pV_XDKDyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Thanks for the reply!

Am 16.01.19 um 01:41 schrieb Chris Murphy:
> The relevant error messages are:
> 
> unable to find ref byte
> errno=-2 No such entry
> 
> Somehow a reference byte has been corrupted and inserted into multiple
> locations in the tree and it's not repairable: i.e. neither a correct
> value can be inferred from other available information, nor do the
> tools have a good way to just trim out the item that contains bad key
> pointers - part of the problem with just cutting out the bad parts is
> it's not clear the problem is made even worse or how far the
> corruption extends.
> 
> What's further troubling though is the idea that this corruption might
> have propagated to a separate volume via snapshot send receive. Either
> of the file systems might still be useful for a developer, it seems to
> me important to have some kind of check to make sure it's not possible
> for corruption to propagate in this manner.
> 
> In the meantime, I think it's a good idea to do a memory test. There's
> some information in the archives about how to do this in a more
> reliable way than just memtest86 type tests, but if you can run even a
> memtest86 over a weekend it might confirm there's a memory problem.
> Unfortunately a pass doesn't necessarily mean there aren't rare
> transient problems.

There are some things which do not quote match up for a broken-memory explanation,
unless my understanding is wrong. 

I'll try to explain more concisely:
- The broken file system is on an external USB drive (SMR sadly!) and 
  was used as backup target for btrfs send of snapshots. 
- The machine sending data there does not have a corrupted filesystem. 
  It scrubs perfectly fine. The disk was only connected to that machine for backups, 
  from time to time. 
- To salvage data from the broken FS, I have now mounted it read-only (to prevent btrfs-cleaner from kicking in)
  and sent all snapshots (via btrbk archive) to a fresh filesystem (on a non-SMR disk). 
  For the read-only-mounted broken filesystem, no corruption error was shown in syslog. 
  Checking the new filesystem which has received all snapshots with "btrfs check --readonly",
  no corruption is visible. 
  So I must deduce the corruption was not part of a snapshot which was sent - which would mean
  the corruption is only part of a subvolume pending cleanup by btrfs-cleaner. 

So the only way corruption could have crept in from the machine's memory would have been
during actual send / receive. Also, since sending from the corrupted FS worked, I presume this corruption
only affects subvolumes marked for deletion, which can't be deleted due to the corruption. 

It *might* have happened that during the reboot after the kernel upgrade (after which the corruption appeared), 
the disk did not properly unmount (while btrfs-cleaner was running). Unmounting that SMR disk while deferred
activities are going on may take many minutes, and something may have timeouted during shutdown. 
I can't exclude this, and since after the reboot, btrfs-cleaner continued, that's indeed pretty likely. 

Is an interrupted btrfs-cleaner execution a possible explanation for this issue? 
This would also explain why the re-sent snapshots all seem fine. 

The filesystem itself has 1.2 TB with personal content. If there is a way to extract just the important bits for the developers
and remove anything about the actual content, of course I can do that. 

Cheers,
	Oliver

> 
> 
> Chris Murphy
> 
