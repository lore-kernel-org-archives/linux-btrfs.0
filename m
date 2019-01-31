Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16417C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF2072084C
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 16:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548952775;
	bh=KUXXYlI9dZ66O2cIwbdX2/vpViHigGrx2ZINc7B3JQM=;
	h=References:In-Reply-To:From:Date:Subject:To:List-ID:From;
	b=DUFO8McKBOI0u5bfX5OftbOqrYtN+Nz6daC2zsAxqquDZse0OPMzogUckGI59udm9
	 nZgBuoKw68im9Qmr6gz2Uf1cbNDGbCsd7TJpCMTeX9mNTSF7myxhZk2k2+aa7zJMih
	 CB3SkmXr7DXEA/AG8yZidh6Ame2csa/+d7c93eLw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbfAaQje (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:46878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbfAaQje (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 11:39:34 -0500
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD13B20863
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 16:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548952774;
        bh=KUXXYlI9dZ66O2cIwbdX2/vpViHigGrx2ZINc7B3JQM=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=VKWxgqy2bkOh1btJ42+VksjrvlhcPedMozw1+v4pvPlXMAWMGbFzlZYGJXVQODSY6
         O6yNAxhS9bZHP3XWkfbR3Dfc6r3d0P/NKiyR9QPst18xuIsAA6gEwowddT+lJg1ke1
         oE5eOD7DgUpWQqrwlLZdEA6FUICpFKywGuuPRT+E=
Received: by mail-vs1-f48.google.com with SMTP id x64so2351289vsa.5
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 08:39:33 -0800 (PST)
X-Gm-Message-State: AJcUukdIysJxkGcDkRT42ZAihLZ4dvdfe22a1EEUBLWkCFc+3ggcb6GC
        Ij1UxfNVcfRbsh9tOAJ/9XsW8aAcM21BDuijCOA=
X-Google-Smtp-Source: ALg8bN6zE7iQ/KSKcKRoTBbl6J8a0J2P91eSKfoowDuG/Mwzpz1f6P0OVg4tExLFNtPNqth8GhW5b7BiYrZ9oNavgOs=
X-Received: by 2002:a67:4c51:: with SMTP id z78mr12243992vsa.99.1548952773058;
 Thu, 31 Jan 2019 08:39:33 -0800 (PST)
MIME-Version: 1.0
References: <20181212180559.15249-1-fdmanana@kernel.org> <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
In-Reply-To: <20181213160740.GE23615@twin.jikos.cz>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Thu, 31 Jan 2019 16:39:22 +0000
X-Gmail-Original-Message-ID: <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
Message-ID: <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for deduplication
To:     dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > Checking if the destination root is read-only was being performed only for
> > clone operations. Make deduplication check it as well, as it does not make
> > sense to not do it, even if it is an operation that does not change the
> > file contents (such as defrag for example, which checks first if the root
> > is read-only).
>
> And this is also change in user-visible behaviour of dedupe, so this
> needs to be verified if it's not breaking existing tools.

Have you had the chance to do such verification?

This actually conflicts with send. Send does not expect a root/tree to
change, and with dedupe on read-only roots happening
in parallel with send is going to cause all sorts of unexpected and
undesired problems...

This is a problem introduced by dedupe ioctl when it landed, since
send existed for a longer time (when nothing else was
allowed to change read-only roots, including defrag).

I understand it can break some applications, but adding other solution
such as preventing send and dedupe from running in parallel
(erroring out or block and wait for each other, etc) is going to be
really ugly. There's always the workaround for apps to set the
subvolume
to RW mode, do the dedupe, then switch it back to RO mode.

Thanks.
