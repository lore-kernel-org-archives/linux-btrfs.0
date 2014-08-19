Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaHSLKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 07:10:47 -0400
Date: Tue, 19 Aug 2014 13:10:45 +0200
From: David Sterba <dsterba@suse.cz>
To: stable@vger.kernel.org
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Btrfs stable updates for 3.16.x (and others)
Message-ID: <20140819111045.GQ1553@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi stable team,

please add the following patches to stable trees.

Patch #3 applies to all currently live stables, a 7 years old bug. I've
briefly reviewed all 3 patches against 3.10/12/14/16 (ie. 3.4 skips #1
and #2).

Subjects:
        Btrfs: read lock extent buffer while walking backrefs
        Btrfs: fix compressed write corruption on enospc
        Btrfs: fix csum tree corruption, duplicate and outdated checksums
Commits:
        6f7ff6d7832c6be13e8c95598884dbc40ad69fb7
        ce62003f690dff38d3164a632ec69efa15c32cbf
        27b9a8122ff71a8cadfbffb9c4f0694300464f3b

Thanks.
