Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:36949 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751091AbaDWWke convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 18:40:34 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62529 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1Wd5qD-001iDM-Qb
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 16:40:33 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info>
Date: Wed, 23 Apr 2014 16:40:33 -0600
Message-Id: <ECBC57F1-E3A0-4423-9248-6D7C72DDF09A@colorremedies.com>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org> <000001cf5f3e$aaf7a080$00e6e180$@petrovi.no-ip.info> <20140423220312.GK26949@merlins.org> <000a01cf5f42$2b180b30$81482190$@petrovi.no-ip.info>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The screen shot provided makes it clear that one of the following kernel parameters is incorrect:

> root=/dev/mapper/cryptroot

> rootflags=subvol=root

So either the dmcrypt volume hasn't been opened, thus isn't available; or rootfs isn't on a subvolume named root found at the top level of the file system. So I'd say this isn't a btrfs problem, rather it's due to some earlier misconfiguration that's preventing rootfs from being mounted.


Chris Murphy