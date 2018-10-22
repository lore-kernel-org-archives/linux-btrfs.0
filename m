Return-Path: <SRS0=ca24=NC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FROM_EXCESS_BASE64,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDD9C67863
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 06:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6F2220658
	for <linux-btrfs@archiver.kernel.org>; Mon, 22 Oct 2018 06:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=seravo.fi header.i=@seravo.fi header.b="ChO99Nsc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6F2220658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=seravo.fi
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbeJVOrf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 22 Oct 2018 10:47:35 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:40940 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbeJVOre (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 Oct 2018 10:47:34 -0400
Received: by mail-pf1-f174.google.com with SMTP id g21-v6so12390409pfi.7
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Oct 2018 23:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=seravo.fi; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1faa+tqx9O+HFq2atn2n5Mmfq5vFpG7hTQaDGjvEytE=;
        b=ChO99NscGS3XzWC69g6rxgTHpQ88SmoJahY9nZwtdwoY4D9Jnvbenn4Xb6wqX7iv8B
         WAIVC4eFOVoSrbX7zhCDImPo1RyTvkRM6b5UxOczvgHE+Q3foT8fV4ozvBCq4oUYvzuI
         nIjoCfAD9fAZQMlRuQvBP/XEtKpUtAxNG7ZNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=1faa+tqx9O+HFq2atn2n5Mmfq5vFpG7hTQaDGjvEytE=;
        b=Xkuckgwtso6oeR0/xCl3n2Bhyl8cSwc+fFE5qDVCOesNAQ5u8FvXbvtQRR+BbpE4rf
         h3EhY0Flvsh5RCpeiOsuGHOU5WBoPc7UbVlax/AMUzBGnzK1N8KRl3gHNOUFtfCpFsye
         BCur9I8sgIju3eyYnPAOuAMh3xY+7iWdePw5zrdD23AFUp+Knyf6K92wm5t2nWN28h5l
         kvlu2ipphVQTaDDe+YtkJzRLn5tOGfkyqkK4D23WcANVH0lK55kSrWycn/4ujmsiLLcD
         ejol9Sbu7kl9xHrAgF+HBHaG1R6BO0/POpbJcdB1plx1Jz6iGgpKD/V5KDkhsR+3ra80
         WCeA==
X-Gm-Message-State: ABuFfogTH4NYa70gSTaOKf7I7DIeRGPS4YhzU8yt89akDen1I4i+ok7A
        +ncPcl8j6LaX9ZDDiC6QuVIRtwPmMRTLoT/XL7g/7bg=
X-Google-Smtp-Source: ACcGV63jcEvUCrDhfIdW+KWOcQgySqapS313FJtlb3xSZB8NNDCOK2ctHJpkoadRPuDFkFDrxwXqYUSdIn5krvu96og=
X-Received: by 2002:a63:dd58:: with SMTP id g24-v6mr40846338pgj.86.1540189825074;
 Sun, 21 Oct 2018 23:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
In-Reply-To: <CAHj_TLCsG52NUJf6DbKCO9iQ6Fr2-jOUAsfHs=_UM_LJBYtdMA@mail.gmail.com>
From:   =?UTF-8?B?T3R0byBLZWvDpGzDpGluZW4=?= <otto@seravo.fi>
Date:   Mon, 22 Oct 2018 09:29:58 +0300
Message-ID: <CAHj_TLAHdUqPV_fbPD6G9FNsPhdg5=Hqt1simx256t-2mom4cA@mail.gmail.com>
Subject: Re: How to recover from btrfs scrub errors? (uncorrectable errors,
 checksum error at logical)
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I never got a reply to this thread, but I am not replying to myself in
case somebody has the same issue and is reading the archive:

The problem went away after:
- deleted all snapshots as they seemed to slow down btrfs I/O so much
that simple commands like rm and rsync were unusable
- replaced the disk that had the corrupted file (just in case -
smartctl did not indicate any disk failures) with btrfs replace
- rsynced files from another location to this filesystem so that the
corrupted files got overwritten

Now btrfs scrub does not find any corruption anymore and the
filesystem I/O speed is usable, though still slower than what it used
to be in the past.

ma 15. lokak. 2018 klo 10.50 Otto Kek=C3=A4l=C3=A4inen (otto@seravo.fi) kir=
joitti:
>
> Hello!
>
> I am trying to figure out how to recover from errors detected by btrfs sc=
rub.
>
> Scrub status reports:
>
> scrub status for 4f4479d5-648a-45b9-bcbf-978c766aeb41
>         scrub started at Mon Oct 15 10:02:28 2018, running for 00:35:39
>         total bytes scrubbed: 791.15GiB with 18 errors
>         error details: csum=3D18
>         corrected errors: 0, uncorrectable errors: 18, unverified errors:=
 0
>
> Kernel log contains lines like
>
>   BTRFS warning (device dm-8): checksum error at logical 7351706472448 on=
 dev
>   /dev/mapper/disk6tb, sector 61412648, root 12725, inode 152358265,
> offset 483328:
>   path resolving failed with ret=3D-2
>
> I've tried so far:
> - deleting the files (when path is visible)
> - overwriting the files with new data
> - changed disk (with btrfs replace)
>
> The checksum errors however persist.
> How do I get rid of them?
>
>
> The files are logs and other non-vital information. I am fine by
> deleting the corrupted files. It is OK to recover so that I loose a
> few gigabytes of data, but not the entire filesystem.
>
> Setup is a multi-disk btrfs filesystem, data single, metadata RAID-1
> Mounted with:
>
> /dev/mapper/wdc3td on /data type btrfs
> (rw,noatime,compress=3Dlzo,space_cache,subvolid=3D5,subvol=3D/)
>
> I've read lots of online sources on the topic but none of these help
> me on how to recover from the current state:
>
> https://btrfs.wiki.kernel.org/index.php/Btrfsck
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scr=
ub-and-Btrfs-Filesystem-Repair.html
> https://wiki.archlinux.org/index.php/Identify_damaged_files#Find_damaged_=
files



--=20
Otto Kek=C3=A4l=C3=A4inen
CEO
Seravo
+358 44 566 2204

Follow me at @ottokekalainen
