Return-Path: <SRS0=Zicy=M3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14CDFC04AA5
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B846720652
	for <linux-btrfs@archiver.kernel.org>; Mon, 15 Oct 2018 12:29:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="twSjBxtp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B846720652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbeJOUOS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 15 Oct 2018 16:14:18 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:54351 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbeJOUOS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Oct 2018 16:14:18 -0400
Received: by mail-it1-f174.google.com with SMTP id l191-v6so28320020ita.4
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2018 05:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r9YrrPEEbbb227IhemJQBAV9Gdwv7MG9Lgd/fgFoPYY=;
        b=twSjBxtpPUXW4/cknqEv9BYdS5G5q8HKX3V0WdW6OTpx7RPLRRH5Xh0oieoDGa1nap
         psIS6O4G6ZNMQfV8GTBiKnexK6IZ4zY0yrAopHjcG5sMs0rw+35DV3tq2d66MeLnI3Vq
         YJ9Vc/haZhDURX7URj9V4oixfFG803meU5FaE7JzCczF3SIddwViTyMuSF2Cerb4G81x
         CQirIqVN3PJkQhMFr6QWBTWXsTP/jscWFeAnfGbBifxGA/4Hu5kkZohsbkR7Tql8C7iS
         hXGILlcegnRIpT9K39UXwmVuu7dz5FPzyK50kNjFH4aU03+meppfywBnzh4YwoBXF3vP
         diPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r9YrrPEEbbb227IhemJQBAV9Gdwv7MG9Lgd/fgFoPYY=;
        b=hTBcTwqAd/PJnLRkw8dSZ0Cu2E8LpZCV81rGOl87cNCyUu/mroOJ3nSxIwISAOwVoA
         gFbdbqU6byr+o8FLuqXlBARXwt63VqYHlW75f8fuX4PjlWJy7p3l//AGD9dBextISa0A
         J3hWTbIyzTIyYeIdZaxlCYzX8OX6WZ6q2/tb/GCh+Ce6ClsJP0gRP/RSXzWJRH0T4vDX
         WDOyXDaZChbEJInhgXXoH1p2yG5Ao2W/zTY2npxeEE2FI8Xoz+ezNTmlNG+fF3auNSv/
         OvveXxWwKcDQw4n0uof+OkC+Fb2uFOkjGQMAEn1cHyQctbvOgz2CakO+49CWuesCVvG5
         RQcw==
X-Gm-Message-State: ABuFfoi0UKcrI26JvWelG6yNCi5dOrLtZBOMSXo5J5nTcs3nM19FaS+M
        xStbICpTZ+f8a0Jlj3IcUI4=
X-Google-Smtp-Source: ACcGV62f9PcuyE0+Fzn8kyUFrHhMeJUS1wU9WmcXa1kseulGAiaRXjBfrEjre3COuBQGo1K4xAWD+Q==
X-Received: by 2002:a24:9d90:: with SMTP id f138-v6mr12833013itd.57.1539606552750;
        Mon, 15 Oct 2018 05:29:12 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id c5-v6sm3905429itd.41.2018.10.15.05.29.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Oct 2018 05:29:11 -0700 (PDT)
Subject: Re: reproducible builds with btrfs seed feature
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc:     Anand Jain <anand.jain@oracle.com>
References: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
From:   "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <a7dd8412-15e3-f151-986c-8f34decbb532@gmail.com>
Date:   Mon, 15 Oct 2018 08:29:05 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTPwQnzwkpk=4ZsZXfWTC7HymYETxp-9xUU_tsvOTW0ZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-10-13 18:28, Chris Murphy wrote:
> Is it practical and desirable to make Btrfs based OS installation
> images reproducible? Or is Btrfs simply too complex and
> non-deterministic? [1]
> 
> The main three problems with Btrfs right now for reproducibility are:
> a. many objects have uuids other than the volume uuid; and mkfs only
> lets us set the volume uuid
> b. atime, ctime, mtime, otime; and no way to make them all the same
> c. non-deterministic allocation of file extents, compression, inode
> assignment, logical and physical address allocation
> 
> I'm imagining reproducible image creation would be a mkfs feature that
> builds on Btrfs seed and --rootdir concepts to constrain Btrfs
> features to maybe make reproducible Btrfs volumes possible:
> 
> - No raid
> - Either all objects needing uuids can have those uuids specified by
> switch, or possibly a defined set of uuids expressly for this use
> case, or possibly all of them can just be zeros (eek? not sure)
> - A flag to set all times the same
> - Possibly require that target block device is zero filled before
> creation of the Btrfs
> - Possibly disallow subvolumes and snapshots
> - Require the resulting image is seed/ro and maybe also a new
> compat_ro flag to enforce that such Btrfs file systems cannot be
> modified after the fact.
> - Enforce a consistent means of allocation and compression
> 
> The end result is creating two Btrfs volumes would yield image files
> with matching hashes.
So in other words, you care about matching the block layout _exactly_. 
This is a great idea for paranoid people, but it's usually overkill. 
Realistically, almost nothing in userspace cares about the block layout, 
worrying about it just makes verifying the reproduced image a bit easier 
(there's no reason you can't verify all the relevant data without doing 
a checksum or HMAC of the image as a whole).
> 
> If I had to guess, the biggest challenge would be allocation. But it's
> also possible that such an image may have problems with "sprouts". A
> non-removable sprout seems fairly straightforward and safe; but if a
> "reproducible build" type of seed is removed, it seems like removal
> needs to be smart enough to refresh *all* uuids found in the sprout: a
> hard break from the seed.
> 
> Competing file systems, ext4 with make_ext4 fork, and squashfs. At the
> moment I'm thinking it might be easier to teach squashfs integrity
> checking than to make Btrfs reproducible.  But then I also think
> restricting Btrfs features, and applying some requirements to
> constrain Btrfs to make it reproducible, really enhances the Btrfs
> seed-sprout feature.
> 
> Any thoughts? Useful? Difficult to implement?
> 
> Squashfs might be a better fit for this use case *if* it can be taught
> about integrity checking. It does per file checksums for the purpose
> of deduplication but those checksums aren't retained for later
> integrity checking.
I've seen projects with SquashFS that store integrity data separately 
but leverage other infrastructure.  Methods I've seen so far include:

* GPG-signed SquashFS images, usually with detached signatures
* SquashFS with PAR2 integrity checking data
* SquashFS on top of dm-verity
* SquashFS on top of dm-integrity

The first two need to be externally checked prior to mount, but doing so 
is not hard.  The fourth is tricky to set up right, but provides better 
integration with encrypted images.  The third does exactly what's needed 
though.  You just use the embedded data variant of dm-verity, bind the 
resultant image to a loop device, activate dm-verity on the loop device, 
and mount the resultant mapped device like any other SquashFS image.

I've also seen some talk of using SquashFS with IMA and IMA appraisal, 
but I've not seen anybody actually _do_ that, and it wouldn't be on 
quite the level you seem to want (it verifies the files in the image, 
but not the image as a whole).
