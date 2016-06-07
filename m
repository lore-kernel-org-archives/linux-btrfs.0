Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40647 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161164AbcFGQuM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jun 2016 12:50:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bAKCc-0006dm-DD
	for linux-btrfs@vger.kernel.org; Tue, 07 Jun 2016 18:50:06 +0200
Received: from pd953e4e5.dip0.t-ipconnect.de ([217.83.228.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jun 2016 18:50:06 +0200
Received: from holger by pd953e4e5.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jun 2016 18:50:06 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger@applied-asynchrony.com>
Subject: Re: [Bug] Kernel 4.6.1 errors
Date: Tue, 7 Jun 2016 16:16:35 +0000 (UTC)
Message-ID: <pan$91fbd$ae848894$5accd3ac$e352812d@applied-asynchrony.com>
References: <24157b0e-7fd5-b5c7-8411-af7c3d133c11@chefmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 07 Jun 2016 17:54:26 +0200, g6094199 wrote:

> he guys!
> 
> I´m running Debian Sid where i have found several kernel errors today
> and most of them are btrfs related.
> 
> uname -a
> Linux NAS 4.6.0-trunk-amd64 #1 SMP Debian 4.6-1~exp1 (2016-05-17) x86_64
> GNU/Linux

This is 4.6.0-whatever, not 4.6.1. The problem is fixed in the real
4.6.1 (released last week), which you can find described in commit 4704fa54..
at https://cdn.kernel.org/pub/linux/kernel/v4.x/ChangeLog-4.6.1

-h

