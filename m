Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68377C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2365C2147A
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 03:54:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="liH5DNSZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbfBSDyj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 22:54:39 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:45379 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfBSDyi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 22:54:38 -0500
Received: by mail-lj1-f180.google.com with SMTP id s5-v6so16123726ljd.12
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Feb 2019 19:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=du9gIdiM+APPIIJ3DWgNZ5itGgZpg8wFs6hS6cyDCww=;
        b=liH5DNSZIBaewdLF3VQD5JO2toWggKg8PaNY+URxa0EPFZ7rgx41TEvGll1AN71NpS
         lU9kxy/t/jn60xS6OQE5yG+N4oelDIpklfaG5hooONj2r5KaA1froNAPmBn7IQ7/AIp5
         v4VBA3t51yuMgPftIyLMcM0h0a0rn6wgEX0T/M02Zfwiel/ltovXALWSOmIojfbsnIW+
         DLbd0gVxf4M9UqL927DBPiPkvWlIVVfmCx22sheTluo41MNClU+xfcwqvgd/fm44GTyy
         /Eu3Z7SBlkggVn3YtGXdGHIQfFFSUqx4vdOeoM6h9JCNRZNTliIYGxp6DZSV6FV/XOVM
         FWcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=du9gIdiM+APPIIJ3DWgNZ5itGgZpg8wFs6hS6cyDCww=;
        b=TP2xKWdc/2m/m9NeiZ6hdWdhrz3CwiLrX/xpOhaYEeyS/NsIHOxowpVHXddz69OPSr
         aWolqqfDXNj60xLX6PHO18t3puJdMPokz49yEepUKWaUQxcJT7RYWefTW86dHd56UAg6
         sMwxuD4rjBIH2lMusOD+vNv7b7fp0EpVGTUVs0TJRucMXX1UK12HOj4tgBhTPbDm69e/
         ykzSQH2tIIPi6IlYy/oXiXTnebkUIIKN1MU3q2pyQ/uKAEjz0FP4ZQ+QZeoNMAjfKgda
         gnGrQIccTTiWpx1rKzOzWJ11N9RayPHBcyx2Dyf5ADoEag+qCiRDuHOv0YI/TRUAcwQy
         um7g==
X-Gm-Message-State: AHQUAuY5t3L7s5gK+qQjHWkmLIhjaJIokQAnKI/qoroJtPLe6L6pzhPb
        ymXe90UVjoJgOJN8BqGtrM86RyFFyfdEUxvjeYn36Q==
X-Google-Smtp-Source: AHgI3IZcW+pSxgYAMafxRcT9LG8iJKU6XlAOb+ofTQ8TLCdlBdxu64ud0e5AabS5+7CYvXJamB3wGzjCTT+bMWMbdWQ=
X-Received: by 2002:a2e:9a09:: with SMTP id o9-v6mr15826012lji.132.1550548476767;
 Mon, 18 Feb 2019 19:54:36 -0800 (PST)
MIME-Version: 1.0
References: <b1c31d98-baaa-85c7-1101-65350e1b4f45@sheepa.org>
 <6a6cd7a7-ffaf-bb74-1c94-bfb1ad7fb335@gmail.com> <d216fc94-dba2-031f-a16a-94dadd462866@georgianit.com>
 <40efb627-911f-1cae-c3d2-f2353eaab99c@sheepa.org> <CAJCQCtSE++nn=mVEpKt3vgpnDXXnooD2zg6aUJ6DdkphVDHQkg@mail.gmail.com>
 <47ac7b0a-269c-5580-fb3b-2504111901cf@sheepa.org> <CAJCQCtT8Z47UQnRo1zDfpCB6e7cSPOzYFkR55_9ASTW=oBPTZA@mail.gmail.com>
 <d84709a7-1029-3e07-95ee-2ae646e39bd0@sheepa.org> <CAJCQCtRLU=Cv9Lg75Vc4KO18N0y4hvoCuo9WV+rbKg2DTb+o7A@mail.gmail.com>
 <a870ee41-983a-5786-eb14-4513de4da875@sheepa.org> <CAJCQCtRvxpai3Cs+588T+QjYJbJSs2NE=nzkZ90FY41M9peXog@mail.gmail.com>
 <fec70b89-90ee-20b9-d47a-ae1be31361fc@sheepa.org> <CAJCQCtSc=T=Umg4bz2M6o1bZin7Y967827Jrfkeh=nCPLy6dGQ@mail.gmail.com>
 <c1fc8b54-9cf6-f191-57ba-7621edefd139@sheepa.org>
In-Reply-To: <c1fc8b54-9cf6-f191-57ba-7621edefd139@sheepa.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 18 Feb 2019 20:54:24 -0700
Message-ID: <CAJCQCtQzGCvn3DjPQUndRv=MmhVGzz5Nr=JL7p8kJim9ABmN3g@mail.gmail.com>
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

On Mon, Feb 18, 2019 at 5:28 PM Andr=C3=A9 Malm <admin@sheepa.org> wrote:
>
> Rsync is probably i bad idea yes. I could btrfs send -p the changed
> "new" master subvolume and then delete the old master subvolume and then
> reference the new master subvolume when transferring it later on i guess?

I'm not sure how your application reacts to snapshots or reflinks, or
how it updates its files. All of that needs to be tested to see what
the incremental send size is, and if the resulting received snapshot
contains files with the integrity your application expects, and so on.

>
> I'll explain the problem I'm trying to solve abit better;
>
> Say i have a program that will run in multiple instances. The program
> requires a dataset of large files to run (say 20GB). The dataset will be
> updated over time, i.e parts of them changes. These changes should only
> apply to new instances for the program. The program will also generate
> new data (both new files and also changing data in the the shared
> dataset) that is unique to the instance of the child subvolume. Finally
> I need to transfer the program together with its generated data to
> another remote machine to continue it's processing there. What i want to
> achieve is avoid having to transfer the entire dataset when only small
> parts of it is changed by the program. I also want to avoid having to
> duplicate copies of the data on the remote machine.

Yep. Based on this description though, the only time I grok using
'btrfs send -p master.snap child.snap | btrfs receive /destination/'
is for the initial transfer of child. Master must be already fully
replicated. Now you can snapshot master and child on separate
schedules to account for their different use case, and send their
increments independent of each other. Or in fact maybe you'll realize
you do have a use case for clone.

Have you looked at GlusterFS or Ceph for this use case? I kinda wonder
if there's any simplification to just having a clustered file system
make all of the send/receive stuff go away, and you can ensure your
data is replicated pretty much immediately, and is always available
for all computers. *shrug* That's off topic but I'm curious if there
are ways to simplify this for your use case.



--=20
Chris Murphy
