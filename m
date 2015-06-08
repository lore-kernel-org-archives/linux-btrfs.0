Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33113 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbbFHXhE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Jun 2015 19:37:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z26bB-0000y0-Jl
	for linux-btrfs@vger.kernel.org; Tue, 09 Jun 2015 01:36:57 +0200
Received: from p4ff5820d.dip0.t-ipconnect.de ([79.245.130.13])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 01:36:57 +0200
Received: from holger.hoffstaette by p4ff5820d.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 01:36:57 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH] btrfs: Handle unaligned length in extent_same
Date: Mon, 8 Jun 2015 23:36:25 +0000 (UTC)
Message-ID: <pan.2015.06.08.23.36.25@googlemail.com>
References: <20150608220525.GL18148@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 08 Jun 2015 15:05:25 -0700, Mark Fasheh wrote:

> The extent-same code rejects requests with an unaligned length. This
> poses a problem when we want to dedupe the tail extent of files as we
> skip cloning the portion between i_size and the extent boundary.

This sounds familiar:
http://thread.gmane.org/gmane.comp.file-systems.btrfs/42512

Same problem?

-h

