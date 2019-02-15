Return-Path: <SRS0=Dxhg=QW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB806C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 12:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B80DB21920
	for <linux-btrfs@archiver.kernel.org>; Fri, 15 Feb 2019 12:03:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qmsVefHj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbfBOMDD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 15 Feb 2019 07:03:03 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:36239 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732769AbfBOMDD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Feb 2019 07:03:03 -0500
Received: by mail-vk1-f193.google.com with SMTP id v131so1936305vkd.3
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Feb 2019 04:03:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=J42vYzQOKAS8w7Syfgaj5iT0zHJ+81+RRo/92cnTfLs=;
        b=qmsVefHjEXdPXwfCq9cby1iIJSd7MhS68/n97orj7oRKMSWww9FLMn+Zq9VZViVVUC
         YXgGXelWHWEmzlPazg9Id9yvvguTTQQJMXWF8y4BqXu/ZOVdBbateB3Yr0PGnT4eBV4e
         gvYVV5YrV6ag5m9h6SWJWZyIpYqrMkDVvm5GLrjARVBeDLvo8pG1SE1WpgvuHrDeQwBy
         BoVC1PNyfPcN/Y+QMaT2npPQgqN7piXW03pvq7VJ+5HbSSLLmnT/qA5G3CHpZ/toE0QZ
         6Rd9z8oumcRtJj/IyxBi+9KpakBqSgJD5A9Ln2XryQohK49+jA7mq6r6FTRM4riAnBxR
         cIJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=J42vYzQOKAS8w7Syfgaj5iT0zHJ+81+RRo/92cnTfLs=;
        b=dR+L0hr6WekMA2QsrtAYaCroUPIIlwOZXvuugGPxaUVZzZOxXErB3+k5n4+Y9YcvZV
         ShERSNUg3denkl/CghXxaz2NK2g9aG3ah0cCKy+LGcuohPF5SuOX4tCjDx3/9uTEZpLq
         ncpSjdiGOdlSOeMUGoHgcM3alqY9VlP++HsmCvHE6BJsXwk997W28vJzjzZDax0yNA7d
         XMU/I00uejz9i6DYUUzPuzlIjQNcqViGSACqMhF3kTlbl/B+qVIgT1mv5L6cUBshfKdN
         gd+5/aXp558PG/Xy7sZdD49zcTlKSouwyEX3FW8GUNyuAqhPaRyiRAdoP6nQldYNI29z
         GonQ==
X-Gm-Message-State: AHQUAuaK0GC3dALF5zVEl8r+T9LVERL+OC3mB1lmq+yqQyRDBH7HHkt9
        G/uYESDUjForBXYP8RIKcKZF9LR+khvUFde7ttvm+yWM
X-Google-Smtp-Source: AHgI3IY4iGEqy6ipQ8ie1vQwQ58joBvje3F/FD4Vpg/KLrBV4bU+WlrZWgKl8n6eNw2G6+f311+4qBx4r4fe3OtTRMo=
X-Received: by 2002:a1f:7f10:: with SMTP id o16mr4606315vki.31.1550232182124;
 Fri, 15 Feb 2019 04:03:02 -0800 (PST)
MIME-Version: 1.0
References: <20180823031125.GE13528@hungrycats.org> <20190212030838.GB9995@hungrycats.org>
 <CAL3q7H7T_NX=D8qimRC55g8V-p0k-ygUiW-K5bxF02r-6XT6Rg@mail.gmail.com>
 <20190212165916.GA23918@hungrycats.org> <CAL3q7H6eTTw-iTHiQLcJHa5iRRspWxQpfyTQRU1SmcxBqXSppg@mail.gmail.com>
 <20190212181328.GB23918@hungrycats.org> <CAL3q7H4k=N=0Cv8hYAZkfTfaG8XJgG1KzT5mA_4XnutxGFc8DA@mail.gmail.com>
 <CAL3q7H6YShEBKDTDZ7_qBoLDMgihP_8NYee_60-LUqd6sF5xZQ@mail.gmail.com>
 <CAL3q7H6WSe_C7_+D0x1_Z+KdK=k+iM-t2J4pQSO32ZsY4AEZ=Q@mail.gmail.com> <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
In-Reply-To: <95e4d9825c2565473184765c4d77ae0015d01580.camel@scientia.net>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 15 Feb 2019 12:02:50 +0000
Message-ID: <CAL3q7H53VWwCU78WgD928NgD=qcKaJd4Kh7sLOY2yv-Cfy9oOg@mail.gmail.com>
Subject: Re: Reproducer for "compressed data + hole data corruption bug, 2018
 edition" still works on 4.20.7
To:     Christoph Anton Mitterer <calestyo@scientia.net>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 14, 2019 at 11:10 PM Christoph Anton Mitterer
<calestyo@scientia.net> wrote:
>
> On Thu, 2019-02-14 at 01:22 +0000, Filipe Manana wrote:
> > The following one liner fixes it:
> > https://friendpaste.com/22t4OdktHQTl0aMGxcWLj3
>
> Great to see that fixed... is there any advise that can be given for
> users/admins?

Upgrade to a kernel with the patch (none yet) or build it from source?
Not sure what kind of advice you are looking for.

>
>
> Like whether and how any occurred corruptions can be detected (right
> now, people may still have backups)?
>
>
> Or under which exact circumstances did the corruption happen? And under
> which was one safe?
> E.g. only on specific compression algos (I've been using -o compress
> (which should be zlib) for quite a while but never found any
> compression),... or only when specific file operations were done (I did
> e.g. cp with refcopy, but I think none of the standard tools does hole-
> punching)?

As I said in the previous reply, and in the patch's changelog [1], the
corruption happens at read time.
That means nothing stored on disk is corrupted. It's not the end of the wor=
ld.

[1] https://lore.kernel.org/linux-btrfs/20190214151720.23563-1-fdmanana@ker=
nel.org/

>
>
> Cheers,
> Chris.
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
