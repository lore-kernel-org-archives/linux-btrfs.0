Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:44756 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727AbcFCJxq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 05:53:46 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.84_2)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1b8lnU-0004Nh-A7
	for linux-btrfs@vger.kernel.org; Fri, 03 Jun 2016 11:53:44 +0200
Date: Fri, 3 Jun 2016 11:53:44 +0200
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Recommended why to use btrfs for production?
Message-ID: <20160603095344.GV14027@torres.zugschlus.de>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 03, 2016 at 11:49:09AM +0200, Martin wrote:
> We would like to use urBackup to make laptop backups, and they mention
> btrfs as an option.
> 
> https://www.urbackup.org/administration_manual.html#x1-8400010.6
> 
> So if we go with btrfs and we need 100TB usable space in raid6, and to
> have it replicated each night to another btrfs server for "backup" of
> the backup, how should we then install btrfs?

Do you plan to use Snapshots? How many of them?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
