Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C682CC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 22:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 904982064C
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 22:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="fWlLV+Jj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731770AbfBRW2Y (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:28:24 -0500
Received: from mail-lj1-f178.google.com ([209.85.208.178]:43523 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbfBRW2Y (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 17:28:24 -0500
Received: by mail-lj1-f178.google.com with SMTP id z20so14684937ljj.10
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 14:28:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r8kh8JfN7wOdgNnU6n+Fw/QJnalKSRmHq5acPJUR/8w=;
        b=fWlLV+JjkW4/ZxCoVurUkYPGZR6Zlm+J4/iP2TiIZKWj72NvMCwzBu6ojmrgmaIvbQ
         +IImU9Edo0XQwuJviWxOnzxaGyMeNHxkgwqSfR1Cl0JRnG36IqajSIrw5dDBa+qIHPHA
         c0DzbG8alsN8GdEGwPbYOwsBCzm/jFvH0o2gnPhTreAE9Ch9gm+ZQ+wOSRpaCg5HS0dH
         3r14mYeZC4dsV13UH7ySHu2mEQEC0lbo2VWaZY922teiU0LAlf+0LH6jOvUrXkDVoNnQ
         ZaahwDW/Xx5KIpnvZNAC3uExCQLF74CjbaD3BlMfP7QoWi5dVTb/P0LOmfrIE4AOgiIi
         45Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r8kh8JfN7wOdgNnU6n+Fw/QJnalKSRmHq5acPJUR/8w=;
        b=j2AY9kVxGisY4kJeU+cArJgXMiup8L4MOFJiHWSypAdv5/8ugVwqDaW8T8Gg1G+dNl
         ymypJ5r2vNVoKlv50okvo3ieO3d0cl0tTE5mV4SZAAVVxKVWqutWuvHIL0keAwWrutJc
         KRF/LWSVGKqzCZsqJ3dm99nze16AXGbOYubcIzqjV+0nf7AvHruh59M3HrFLtRnz4Wgq
         6CExSLSzBnyNcMbj12vpn0U6iuGw3lI61iRx/FyAPDhrPEbm8tEL+kNCgW5E8fLEi1w4
         +JOL/jszF7a7MpFS7L+2uDn9Z7oSCyB3D3+7pOnVCYxl1wPxSpJojLU9ldcgFF4MYby7
         UTkA==
X-Gm-Message-State: AHQUAuYVEVV5FBsKwNDODkKQZ1PRb68mW4WSnl91ovoWQBSVSY9KE+jq
        hrM/nclD1SNGi6+EvV3VwWrvUpHqiR/ZTesjN/psYwvtOIc=
X-Google-Smtp-Source: AHgI3IZgZ5Exkp7tP4wyUsp8EGu5PyRYMkWS05saMtp4S3k13rQ/vUwAfi2lsFS/A3fbBTguSdbfBJngTCWz5zXAWNk=
X-Received: by 2002:a2e:7d04:: with SMTP id y4-v6mr9370932ljc.127.1550528901748;
 Mon, 18 Feb 2019 14:28:21 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org> <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org>
In-Reply-To: <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 15:28:09 -0700
Message-ID: <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
Subject: Re: Btrfs send with parent different size depending on source of files.
To:     =?UTF-8?Q?Andr=C3=A9_Malm?= <admin@sheepa.org>
Cc:     Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 18, 2019 at 2:36 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> The reason why I'm using reflinks instead of snapshots is because the
> master subvolume is large and will contain hundreds of gigabytes worth
> of data. Now if I change / remove, say 10 GB worth of data from the
> master subvolume unrelated to the child subvolume I don't want those
> gigabytes sent down the wire with btrfs send as they are unrelated. Also
> I want to be able to after time, when required, add more data from the
> master subvolume to the child. Thats why I can't split the master
> subvolume into parts of related data.

OK, is it your plan to have both master and child on the destination
Btrfs? So you plan to do a 'btrfs send' without -p option to send the
entire master subvolume (snapshot) to destination first? And then you
want to create the child efficiently using a difference between master
and child? Yes I think that might work but I haven't tried it. But of
course, master must already be on the destination.

btrfs sub create master
##populate the master
btrfs sub create childofmaster
cp --reflink master/bunchoffiles childofmaster/
btrfs sub snap -r master master.20190218-initial
btrfs sub snap -r childofmaster childofmaster.20190218-initial
btrfs send master.20190218-initial | btrfs receive /destination/
btrfs send -p master.20190218-initial childofmaster.20190218-initial |
btrfs receive /destination/

However your subsequent incremental send/receive has nothing to do
with master anymore; you indicate above you don't intent to keep
master up to date on the destination. Just child. In that case the
incremental changes look like this:

cp --reflink master/morefiles childofmaster/
btrfs sub snap -r childofmaster childofmaster.20190218T1905
btrfs send child -p childofmaster.20190218-initial
childofmaster.20190218T1905 | btrfs receive /destination/
cp --reflink master/yetmorefiles childofmaster/
btrfs sub snap -r childofmaster childofmaster.20190219T1301
btrfs send child  childofmaster.20190218T1905
childofmaster.20190218T1905  | btrfs receive /destination/


--=20
Chris Murphy
