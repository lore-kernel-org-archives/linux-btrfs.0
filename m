Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34985 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbcELOTM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 10:19:12 -0400
Received: by mail-io0-f170.google.com with SMTP id d62so96552705iof.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 07:19:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 May 2016 17:19:11 +0300
Message-ID: <CAA91j0XRtuyJd12CgDTBXEaOKdN0Ff1Bt2_wT=nGUJy9r=usyg@mail.gmail.com>
Subject: Undelete deleted subvolume?
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I accidentally deleted wrong snapshot using SUSE snapper. Is it
possible to undelete subvolume? I know that it is possible to extract
files from old tree (although SLES12 does not seem to offer
btrfs-find-root), but is it possible to "reconnect" subvolume back?
