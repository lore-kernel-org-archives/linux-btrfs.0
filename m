Return-Path: <SRS0=huBW=PW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC79C43387
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE5AA20657
	for <linux-btrfs@archiver.kernel.org>; Mon, 14 Jan 2019 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547475091;
	bh=KBX1D8nXVe0l783ebwfElUrq++xkYQXb9um5AZjS+yo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=stQfd7LYQuywcLrKOdXuqR+OdFIzovdNWdqEpnHZqral0ZLr018v7Rl4wD0dy/DJl
	 lkVXiEoMZjoVDxQkevek3X5YWpmparllL3o64FGyVSismTI0RDALoq/6UUCquPDmSv
	 fmtrWZX6gpCbTtL7w+izwkwBHISnphq5B2EQqIz8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfANOLa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 14 Jan 2019 09:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANOLa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Jan 2019 09:11:30 -0500
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F59820659
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 14:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547475089;
        bh=KBX1D8nXVe0l783ebwfElUrq++xkYQXb9um5AZjS+yo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=khUL4hrBDKDYhn5wiUOXswzF8i9YbtKEl7xIZ1QUAzhQKWJV5bSbt5p12gX9xsVz3
         KpDdiWDvnfy/MYLc/u/KD9QmlKNatdq9GvzQGQAEVlqMJ6efiLEHoctt4G9ckxIOCs
         8dV2I5W3JibDVo/jPsTaRAT9/80vr3o7S5LjcQ7s=
Received: by mail-vs1-f54.google.com with SMTP id x1so13663788vsc.10
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jan 2019 06:11:29 -0800 (PST)
X-Gm-Message-State: AJcUukf9B8HEgZBJc0XDvNR1x1KmCTzlYd+SCpLGsjH5+nPy4qH2Y/wM
        qH4CXD9Sl1FBOcxkJhHsWrhaiIqdl8+uJBZSGpY=
X-Google-Smtp-Source: ALg8bN5oPicd12gRhFa5dzLQJzDi+9JnAExG7coLJjU+FXu04kiXEuYUPJ/+P8G+IvPFn56xOO7gQLtN9q+SkyBnJos=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr10424088vsa.14.1547475088573;
 Mon, 14 Jan 2019 06:11:28 -0800 (PST)
MIME-Version: 1.0
References: <20190114133146.18424-1-fdmanana@kernel.org> <20190114150817.394e4f7d@suse.de>
In-Reply-To: <20190114150817.394e4f7d@suse.de>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 14 Jan 2019 14:11:17 +0000
X-Gmail-Original-Message-ID: <CAL3q7H6cHf8U4pqPDNEA=g_kC_gOhccyE0a1CaS8N3QxdDSCWg@mail.gmail.com>
Message-ID: <CAL3q7H6cHf8U4pqPDNEA=g_kC_gOhccyE0a1CaS8N3QxdDSCWg@mail.gmail.com>
Subject: Re: [PATCH 3/3] Btrfs-progs: add test for receive
To:     David Disseldorp <ddiss@suse.de>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 2:08 PM David Disseldorp <ddiss@suse.de> wrote:
>
> On Mon, 14 Jan 2019 13:31:46 +0000, fdmanana@kernel.org wrote:
>
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Add a test for a scenario that used to fail due to find_mount_root()
> > incorrectly determining the mount point for the receive path due to the
> > fact that a different mount point with a path that is a prefix of the
> > receive path exists.
> >
> > This is fixed by a recent patch titled:
> >
> >   "Btrfs-progs: fix mount point detection due to partial prefix match"
> >
> > Reported-by: David Disseldorp <ddis@suse.com>
>
> My address has an extra 's' (ddiss). This also applies to PATCH 1/3.

Ops.
David can probably correct that when he picks the patch, otherwise
I'll send a new version.
Thanks.

>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > ---
> >  .../034-receive-common-mount-point-prefix/test.sh  | 47 ++++++++++++++++++++++
> >  1 file changed, 47 insertions(+)
> >  create mode 100755 tests/misc-tests/034-receive-common-mount-point-prefix/test.sh
>
> Looks good.
> Reviewed-by: David Disseldorp <ddiss@suse.de>
