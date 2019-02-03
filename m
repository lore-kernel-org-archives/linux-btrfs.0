Return-Path: <SRS0=vUl+=QK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AD9C282D7
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 00:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B08DB20855
	for <linux-btrfs@archiver.kernel.org>; Sun,  3 Feb 2019 00:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="DfkEIi/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfBCA02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 2 Feb 2019 19:26:28 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42879 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfBCA02 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Feb 2019 19:26:28 -0500
Received: by mail-lj1-f195.google.com with SMTP id l15-v6so8818698lja.9
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Feb 2019 16:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LxQnRn5ikdAW4KCBIzYupjSH442kHv/4v9J9Y+4jB/I=;
        b=DfkEIi/PNNNyA+0OeyyLb5k1oB2koFIhMTY6Tmpum4k+SUs92YS7JwUdXO9t7mI7VL
         C4xw/A+b4+1XiS6ot2ROzM8+VcmetJIAzoCnCz9A1CR15N8TBo1jq6cxztWY7tu8blmp
         14oMfbOjSEIhH7PVCKdcammJ4t5vknLyehbxYc6n/LLJid5oDEthUiOseHv8UASRyifC
         DLFL7PRPvN+LRrRIEUrdCVMZiHtT19ixfH7QDzunyb0Ejj631hcCrm2B01q+EDXa8bjn
         DE2m920h1ErAbpM6opTcF0rMRCwcPp/AE0wk0agHS+Bn7MtOExHmKmCtR+rwCfU4alpd
         23+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=LxQnRn5ikdAW4KCBIzYupjSH442kHv/4v9J9Y+4jB/I=;
        b=Mk06nztdngn/YZxjAZp8ZS+26ENBOYUNFU7l4ZxAh71d9eDSJMRyjJ6FRCWKV2iJlS
         x7+CXzBnsR4q3jX6BNkyTIeOio2dKomLSUh1I26SL4uAydBAeWb0R7dA8hUml69A0D55
         HXa+LMrT5j3+m6vPhJ4RdvX5z9OJyulfonZenN3cdOPou/KAOSLO9Jk6/SGT/oDiAQ4A
         WZeg1CoLbZLH5LSfuq+ylvSN7SlmqN5O6s/h+dY+pAyxIvkNxvSejOaZUz6vvI/03Ftp
         tbbHLn2SbSBxIZuGW8pxNZgSH3+MVga9LqAFj0Qi2WiSp4iGsyT/+CxOb04r/yacxmJ1
         ObHw==
X-Gm-Message-State: AHQUAuahsIJh6WknDmTxjCDEpCASj+btiV7y1EZPPVVuHg6gTHp0upRx
        22Pd4Fn0EJ8kcdp2Pt5C8RKjdEcV/bQKjfKR6US9gQ==
X-Google-Smtp-Source: AHgI3IaMHQUbB5cpbKskBHN12qb+q5WU76ZvwiUYnMuj9M0C9gOZWMVNEU3CYJo3C4bUHenga6SVuDhfA6K0DY2cMGI=
X-Received: by 2002:a2e:58b:: with SMTP id 133-v6mr4226607ljf.127.1549153586232;
 Sat, 02 Feb 2019 16:26:26 -0800 (PST)
MIME-Version: 1.0
References: <4ef8b545-efa8-43b0-8576-78c71bfb0e2c@www.fastmail.com> <20190202120149.GE4461@carfax.org.uk>
In-Reply-To: <20190202120149.GE4461@carfax.org.uk>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Sat, 2 Feb 2019 17:26:14 -0700
Message-ID: <CAJCQCtRL4bd+2_g8+YZ5uV254E_nK3OxS9Q0AB5dqN-N4zcd0Q@mail.gmail.com>
Subject: Re: RAID1 filesystem not mounting
To:     Hugo Mills <hugo@carfax.org.uk>, Alan Hardman <alanh@fastmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 2, 2019 at 5:02 AM Hugo Mills <hugo@carfax.org.uk> wrote:
>
> On Fri, Feb 01, 2019 at 11:28:27PM -0500, Alan Hardman wrote:
> > I have a Btrfs filesystem using 6 partitionless disks in RAID1 that's f=
ailing to mount. I've tried the common recommended safe check options, but =
I haven't gotten the disk to mount at all, even with -o ro,recovery. If nec=
essary, I can try to use the recovery to another filesystem, but I have aro=
und 18 TB of data on the filesystem that won't mount, so I'd like to avoid =
that if there's some other way of recovering it.
> >
> > Versions:
> > btrfs-progs v4.19.1
> > Linux localhost 4.20.6-arch1-1-ARCH #1 SMP PREEMPT Thu Jan 31 08:22:01 =
UTC 2019 x86_64 GNU/Linux
> >
> > Based on my understanding of how RAID1 works with Btrfs, I would expect=
 a single disk failure to not prevent the volume from mounting entirely, bu=
t I'm only seeing one disk with errors according to dmesg output, maybe I'm=
 misinterpreting it:
> >
> > [  534.519437] BTRFS warning (device sdd): 'recovery' is deprecated, us=
e 'usebackuproot' instead
> > [  534.519441] BTRFS info (device sdd): trying to use backup root at mo=
unt time
> > [  534.519443] BTRFS info (device sdd): disk space caching is enabled
> > [  534.519446] BTRFS info (device sdd): has skinny extents
> > [  536.306194] BTRFS info (device sdd): bdev /dev/sdc errs: wr 23038942=
, rd 22208378, flush 1, corrupt 29486730, gen 2933
> > [  556.126928] BTRFS critical (device sdd): corrupt leaf: root=3D2 bloc=
k=3D25540634836992 slot=3D45, unexpected item end, have 13882 expect 13898
>
>    It's worth noting that 13898-13882 =3D 16, which is a power of
> two. This means that you most likely have a single-bit error in your
> metadata. That, plus the checksum not being warned about, would
> strongly suggest that you have bad RAM. I would recommend that you
> check your RAM first before trying anything else that would write to
> your filesystem (including btrfs check --repair).

Good catch!

I think that can account for the corrupt and generation errors. I
don't know that memory errors can account for the large number of read
and write errors, however. So there may be more than one problem.


--=20
Chris Murphy
