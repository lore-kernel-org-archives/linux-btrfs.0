Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51910 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022Ab3A3AYb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 19:24:31 -0500
Received: from relay1.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id D4B1EA4FFA
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 01:24:29 +0100 (CET)
Date: Wed, 30 Jan 2013 01:24:28 +0100
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Subject: Integration branch of btrfs-progs 2013-01-30
Message-ID: <20130130002427.GD30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

a few build warning fixes, unaligned access fix #2 and finally support
for the 'device stats' and device 'replace' commands!

Please test, worked for me here, but not tested extensively. If
everything goes well I'll send a pull request with this branch in a few
days.

  git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130130

(top commit 78b35a43988163dbf71d9)

I'll continue collecting patches and patchsets in the mean time.
Existing patches and bugfixes have a slight precedence over patchsets.


thanks,
david
