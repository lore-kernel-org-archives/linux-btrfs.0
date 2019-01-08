Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA37AC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A6620665
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 21:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRIys3yV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbfAHV4Z (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 16:56:25 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:45774 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfAHV4Z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 16:56:25 -0500
Received: by mail-wr1-f53.google.com with SMTP id t6so5574437wrr.12
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 13:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nxL0ZjnnrFoM2KASVxKJ/NR2AZTtuZlLcqgkJT9rgbA=;
        b=eRIys3yVBnWIbmIK5Ssb5LLIBqb3xeTc30UbTdQv9MXG96hcwI/Yde61qEyODmB26g
         RLrZ+sWkq1FPNnUmH8+euONdMICY3/+rV2q983LQ8HIs8yZ3f8YAK0TI+UAVEXtbun7W
         DFiOAr5aCCemSw6hPujwgYrUbcyXbPchYuxzVg/DYw6SZZY8BZ6JAPa4lkaxGK++vyFF
         C3c7WxH1o0RTGYEsyVC2OJEGAb+TjzBxSpau7jpT5HGXSoUq5nm7gU5W8OgmotYvzz0N
         C2joFs8oJEYRf1bUbh0E1Jdr5DiLYBBqHJHhBlfKEG9dNoPCnepvB4lwtPEpbuczfRMK
         notQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nxL0ZjnnrFoM2KASVxKJ/NR2AZTtuZlLcqgkJT9rgbA=;
        b=UMamDadL/09hBIiPt852aTSqQuSvmw0NLG2V50EY8naM8LSzxhv+dNkSBG74zcJMNF
         RhwUpySLN7Na/DhBnpEM14NUrq10M4PTiu2MDifr2fX488F75WjTl28gS1oWZIJ8u07m
         oE+j5fTprGLT1PR/aUxfXBrGYnFzKxgWyao7AZqZYKRX1ttPEwDqTlhaHJIzpO+klz1a
         W+sAfBnVB04eeOUuUDHKp96JnQLtu5kEsSH7ncLdHd9Ge6/w922z7S5+TDvggFe7CyAT
         VokQNg27+s6yVCa/PB8J8N/g4Uhuv8HWuzI9DHo4oKy5/6QYTByHk3KLlBNBcWS9bToO
         CuGw==
X-Gm-Message-State: AJcUukfCE+OypmeeGBLQNAsXeky/miDX+nbAUwvspPMaFt9seS5u7oCn
        EBtvUrr+YiaIUmk+DNk3+qD9yuIm6Lk=
X-Google-Smtp-Source: ALg8bN4H0SqyILemhmtPbsINTe+47B8XJPyAvqKVMhx2P0Ze914sqdRUH7mX5l9anGPaNQCG4pUMyQ==
X-Received: by 2002:a5d:4c8a:: with SMTP id z10mr2642006wrs.75.1546984583259;
        Tue, 08 Jan 2019 13:56:23 -0800 (PST)
Received: from exnet.gdb.it ([5.90.200.83])
        by smtp.gmail.com with ESMTPSA id c13sm56906535wrb.38.2019.01.08.13.56.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 08 Jan 2019 13:56:22 -0800 (PST)
From:   Giuseppe Della Bianca <giusdbg@gmail.com>
To:     Jeff Mahoney <jeffm@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [COMMAND HANGS] The command 'btrfs subvolume sync -s 2 xyz' can hangs.
Date:   Tue, 08 Jan 2019 22:55:36 +0100
Message-ID: <34407090.HkA8NDud7j@exnet.gdb.it>
In-Reply-To: <04891508-41fd-9d63-9dfb-a51041a3b8ea@suse.com>
References: <2543962.HIiRWmuHEy@exnet.gdb.it> <70326422.XUdVI2pWXa@exnet.gdb.it> <04891508-41fd-9d63-9dfb-a51041a3b8ea@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

In data marted=EC 8 gennaio 2019 22:18:11 CET, Jeff Mahoney ha scritto:

]zac[
> Thanks.  As it turns out, since Filipe's identified the fix for this
> issue, we don't need it anymore.  If that turns out to be a different
> issue, we can revisit the log.

Ok.

]zac[
> > I don't know how btrfs works inside.
> > I just suppose that somewhere in the code an error state is not handled
> > correctly (which can be a file or the whole filesystem not accessible).
>=20
> Kind of, if you look at it under the right light.  The sync subcommand
> only waits for the lookup for the subvolume undergoing deletion to not
> be there anymore.  There's no error state to be passed back to the
> waiter, only the initiator.
]zac[

I understand.
But this is a design error in error handling.
The sync subcommand should also check a flag that the deletion system could=
=20
set in case it is no longer possible to continue the deletion.


Gdb



