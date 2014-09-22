Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaIVPYY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 11:24:24 -0400
Date: Mon, 22 Sep 2014 17:24:21 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: clm@fb.com
Subject: Btrfs-progs release 3.16.1
Message-ID: <20140922152421.GR9715@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

this is is a minor release collecting a few bugfixes and enhancements.
User visible changes:

* the 'uknown' blockgroup in 'fi df' is properly named 'GlobalReserve'
* -R option for listing received UUID

Other updates:

* library version defines
* static build is fixed
* build without documentation is possible

The kernel.org btrfs-progs git repository is at

https://git.kernel.org/cgit/linux/kernel/git/kdave/btrfs-progs.git/

and eventually synced to Chris' git tree.

The release tarballs are at

https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/

The tarballs and release commits are signed by my GPG key, fingerprint
 F2B4 1200 C54E FB30 380C  1756 C565 D5F9 D76D 583B

I'll send a separate mail about the expected patchflow and future
releases. I'm not expecting to do 3.16.2 unless something serious pops
up.

Thanks.
