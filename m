Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:55762 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2JMT1B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Oct 2012 15:27:01 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so845232eaa.19
        for <linux-btrfs@vger.kernel.org>; Sat, 13 Oct 2012 12:26:59 -0700 (PDT)
From: Goffredo Baroncelli <kreijack@gmail.com>
To: kreijack@gmail.com
Cc: Hugo Mills <hugo@carfax.org.uk>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>,
        Martin Steigerwald <Martin@lichtvoll.de>
Subject: [PATCH][V1][BTRFS-PROGS] Replace the units from KB to KiB..
Date: Sat, 13 Oct 2012 21:27:13 +0200
Message-Id: <1350156436-14439-1-git-send-email-kreijack@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

several people asked to update the units showed by the "btrfs" tool
form the SI ones (KB, MB, GB...) to the IEC ones (KiB, MiB...).

The aim of this patch is to allow the user to choice which units
are showed. Depending by the BTRFS_UNIT environmental variable,
the following units are showed:

    BTRFS_UNIT=SI the suffix is KB for 1000bytes, MB for 10^6 bytes...
    BTRFS_UNIT=IEC the suffix is KiB for 1024bytes, MiB for 1024 KiB ...
    BTRFS_UNIT=COMPACT the suffix is KB for 1024 bytes, MB for 1024 KiB;
                       no space between the number and the suffix.

BR
G.Baroncelli

Signed-off-by Goffredo Baroncelli <kreijack@gmail.com>



