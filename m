Return-Path: <SRS0=fkam=SH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0741C10F0F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F9772186A
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Apr 2019 07:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="GBYC4DVK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729826AbfDEHPu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 03:15:50 -0400
Received: from mail-lf1-f46.google.com ([209.85.167.46]:39764 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbfDEHPu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Apr 2019 03:15:50 -0400
Received: by mail-lf1-f46.google.com with SMTP id m13so3626085lfb.6
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Apr 2019 00:15:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9oty+WM6cyy/VBYtK4b1XQQKGyhF5m86mlmr+BIXDSM=;
        b=GBYC4DVKqXCQ27HsbFmZB1NKs3nDMExTsylF7NS306OGGXYKqY6biPxJMRVMMJC67f
         417VoAKmMj4PEMwnBpC5dLXHbTEw9c9YrqRzu7h13OEoBM0vSUVgCsbzBuHqbzAE20Pz
         3GQdJYuOFUTWI9+0iIZ0yJWrdhg/KDAAm0CluofHtGbQq/2cRZaYFc/yPspkqT2Qs+Sx
         DFyDvZNu8Pxk7EK5+xxYMg38gceIn4tMcxiykuVGCAKr0C2CZdU9gr5PqyEeHg8gg4P2
         LjfWyX/kPe1fecnBGw0sV1tVBq6tzytwe2VrXoRdRo+bnHz84g87VgltYWrRW6bp/Z/g
         xPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9oty+WM6cyy/VBYtK4b1XQQKGyhF5m86mlmr+BIXDSM=;
        b=M8JPI/T/kRA3pFOQibTGtAuyrPzgM+w3BM3nm+902eoUcM+WIvM1Ka+fPhHVcAodof
         5YjcbbdDbyve90IhKbratxpT52J0fzJby+jKEtLLJZlwv1jIxXR28C6++16VzjgjebZe
         Q3o56beF5yqukvzkVKl/XyKxu4h3ldbdHeBSzQR14TT1VltP3KBr0vIRCioebF50VJRU
         mCKgE8gx83ukqv3mtzLt+Z1V8aA4ydgp+MG19OqFU+BaPzeJnv3JIBtzR7jP6esPFMaB
         UQn2Iod9UBjF7iw7Q2ed9yj4wzuRBhz3eft6GcgoW1QqTrhMb3rn8lJ01pJ4x5FgsxGM
         BAlQ==
X-Gm-Message-State: APjAAAXmdqHLZ2QlgPpqQY/KogslSsjCWc9kwciTQKcxEk3mR6OlQFoY
        3Uf0A6RIQtsIjH8tm9xhAc7FLQwepeaCi0QSwWna9A==
X-Google-Smtp-Source: APXvYqxkL+6sIlsLBBLWDzGomTBMwDOgx8Ul8w7INOXt2hr1Il3eeCF/srYEhkJy870a/nbckHZfcf7s/uG6tyFnlGg=
X-Received: by 2002:ac2:554a:: with SMTP id l10mr153469lfk.49.1554448070502;
 Fri, 05 Apr 2019 00:07:50 -0700 (PDT)
MIME-Version: 1.0
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu> <95d0844a-27e3-b1c6-3ef5-ed2df3f0e367@suse.com>
 <3a3537f5-b84c-ee01-b5da-d6bab5bdf221@avgustinov.eu> <CAJCQCtRp+53U_RG+n6oTpBrRRhSSR36OLBc++Q9dQDbHFovurw@mail.gmail.com>
 <beab578a-ccaf-1ec7-c7b6-1ba9cd3743ad@avgustinov.eu>
In-Reply-To: <beab578a-ccaf-1ec7-c7b6-1ba9cd3743ad@avgustinov.eu>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 5 Apr 2019 01:07:39 -0600
Message-ID: <CAJCQCtR6Syn3LYCVOciGPLEpP91Jb9tYp=NncnC2aCNv6coyEw@mail.gmail.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>
Cc:     Chris Murphy <lists@colorremedies.com>,
        Jeff Mahoney <jeffm@suse.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 5, 2019 at 12:45 AM Nik. <btrfs@avgustinov.eu> wrote:
>
> Sorry, I forgot this. Hier is the output:
>
> # btrfs-image -c 9 -ss /dev/sdj3 /mnt/b/sdj3.img
> WARNING: cannot find a hash collision for '..', generating garbage, it
> won't match indexes
>
> The new image is same size, and since it seems small to me I am
> attaching it to this mail.

What do you get for `btrfs insp dump-t -d /dev/` ?

Once I restore it, I get


$ sudo btrfs insp dump-t -d /dev/mapper/vg-nik
btrfs-progs v4.20.2
checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
bad tree block 90195087360, bytenr mismatch, want=90195087360,
have=7681037117263365436
Couldn't setup device tree
ERROR: unable to open /dev/mapper/vg-nik
$ sudo btrfs insp dump-t -r /dev/mapper/vg-nik
btrfs-progs v4.20.2
checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
checksum verify failed on 90195087360 found 6036BAAE wanted 7C05A75D
bad tree block 90195087360, bytenr mismatch, want=90195087360,
have=7681037117263365436
Couldn't setup device tree
ERROR: unable to open /dev/mapper/vg-nik
$

There is a valid superblock however. So it restored something, just
not everything, not sure. Might be related to create failed success!

-- 
Chris Murphy
