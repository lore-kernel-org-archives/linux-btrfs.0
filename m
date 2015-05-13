Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934145AbbEMRRz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 13:17:55 -0400
Date: Wed, 13 May 2015 19:17:53 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs progs release 4.0.1-rc1
Message-ID: <20150513171753.GV23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the $subj pre-release has been tagged, 4.0.1 is going to be a small one. So far
the tests don't pass and 'check' chrashes on some images. I'm going to look at
it next, the ETA for the release is this Friday. Bugfixes are still welcome,
small patches and doc updates as well.

Changes:
* restore can restore symlinks
* fix for 'check' crash
* device remove error message fix
* preparatory works for fsid change
