Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62492 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3CJXLu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 19:11:50 -0400
Received: by mail-wi0-f178.google.com with SMTP id hq4so601623wib.17
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 16:11:49 -0700 (PDT)
From: Diego Calleja <diegocg@gmail.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
Date: Mon, 11 Mar 2013 00:06:51 +0100
Message-ID: <1602186.jds4Ur0UDu@diego-arch>
In-Reply-To: <201303101223.56805.Martin@lichtvoll.de>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <201303101223.56805.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El Domingo, 10 de marzo de 2013 12:23:56 Martin Steigerwald escribió:
> Any other idea to make it less cryptic?

I would vote for optionally allowing to expand the codes into
something more verbose and self-documented, ie:

1CmS1P <-> 1Copy-manyStripes-1Parity
