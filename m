Return-Path: <SRS0=1Vb6=TU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFC8C04AAC
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 May 2019 12:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66E5C204FD
	for <linux-btrfs@archiver.kernel.org>; Mon, 20 May 2019 12:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="siR587ql"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390987AbfETMkk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 20 May 2019 08:40:40 -0400
Received: from hr2.samba.org ([144.76.82.148]:34224 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388722AbfETMkj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 May 2019 08:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=6ytvJlkt8047nZRPmtlwiLyiJ5D8GfIP2ONA469TyiA=; b=siR587qlDvOn0vrU+PQHfmuktw
        B4MTpZAUvgSqRe1i4FbNamtTp0hBXR5VTVH4HE8m16b+A1JfwNugO4kbQSGOXXkGF1Psyr+SYAqzr
        F04hCud2Fpv62ONW5LhdbxK2AbvKdPBUfpfBY4l3B8yaQuNGx/9I+aEN4FZBRXOTUdfA=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hShan-0008W2-D5; Mon, 20 May 2019 12:40:37 +0000
Date:   Mon, 20 May 2019 14:40:36 +0200
From:   David Disseldorp <ddiss@samba.org>
To:     Patrik Lundquist <patrik.lundquist@gmail.com>
Cc:     "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Newbugreport <newbugreport@protonmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Andrei Borzenkov <arvidjaar@gmail.com>,
        Samba Technical <samba-technical@lists.samba.org>
Subject: Re: Btrfs remote reflink with Samba
Message-ID: <20190520144036.7295329f@samba.org>
In-Reply-To: <CAA7pwKPZrwKcpPRvvuhgqxZk6KzC871Pa0gusTCa6oz=W=fqGw@mail.gmail.com>
References: <clzY4RoSOURzgBtua3TjQ4WXJzgY3EwTyiaYwt49zFAPIi_jO2nAQ8O2saTwpqHH9x0ISw9AVbWOvVR4hFDIx8_dzlWKAzHwcOtEuwaXzJ8=@protonmail.com>
        <275f7add-382c-bf6d-4cf8-f9823cf55daf@gmail.com>
        <CAA7pwKM_1uWbu9ECgkqAMXMWTOJm5xH1wvHKFwq+7w=JeQQ7xg@mail.gmail.com>
        <ZBp4TxX3BVubLSjbbtXjztW20HT6YFrXCMMV6IX3xamgZbnpU4KJvO5vs0tcF5po8Ay4KdgGyffZ2DHitm4X4Hm0CFMPCjC2g_HHS9CR51M=@protonmail.com>
        <56ee6d38-d4a8-a62b-4e0d-7568030cdcad@gmail.com>
        <CAA7pwKPZrwKcpPRvvuhgqxZk6KzC871Pa0gusTCa6oz=W=fqGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, 20 May 2019 14:14:48 +0200, Patrik Lundquist wrote:

> On Mon, 20 May 2019 at 13:58, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> >
> > On 2019-05-20 07:15, Newbugreport wrote:  
> > > Patrik, thank you. I've enabled the SAMBA module, which may help in the future. Does the GUI file manager (i.e. Nautilus) need special support?  
> > It shouldn't (Windows' default file manager doesn't, and most stuff on
> > Linux uses Samba so it shouldn't either, not sure about macOS though).  
> 
> The client side needs support for FSCTL_SRV_COPYCHUNK. Nautilus uses
> gvfsd-smb which in turn uses the Samba libs, but I have no idea if it
> works. Maybe David Disseldorp knows?

libsmbclient copychunk functionality was added via:
https://git.samba.org/?p=samba.git;a=commit;h=f73bcf4934be
IIRC, it was added with the intention of being used by Nautilus.
That said, I've not tried it myself, and I don't see any reference to
splice in:
https://gitlab.gnome.org/GNOME/gvfs/blob/master/daemon/gvfsbackendsmb.c
(Perhaps I'm looking in the wrong place?).

Cheers, David
