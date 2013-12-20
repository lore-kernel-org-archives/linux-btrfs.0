Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41348 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755Ab3LTXUI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Dec 2013 18:20:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vu9MU-00016U-PM
	for linux-btrfs@vger.kernel.org; Sat, 21 Dec 2013 00:20:06 +0100
Received: from p5b0064fb.dip0.t-ipconnect.de ([91.0.100.251])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 00:20:06 +0100
Received: from holger.hoffstaette by p5b0064fb.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 21 Dec 2013 00:20:06 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH v3] Btrfs: fix tree mod logging
Date: Fri, 20 Dec 2013 23:19:44 +0000 (UTC)
Message-ID: <pan.2013.12.20.23.19.56@googlemail.com>
References: <1386963698-17766-1-git-send-email-fdmanana@gmail.com>
	<1387552666-10969-1-git-send-email-fdmanana@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 20 Dec 2013 15:17:46 +0000, Filipe David Borba Manana wrote:

[..patch..]

I applied this to 3.12.6 and was rewarded with:

*fs/btrfs/ctree.c: In function 'tree_mod_log_set_node_key':
*fs/btrfs/ctree.c:924:2: error: implicit declaration of function 
'__tree_mod_log_insert_key' [-Werror=implicit-function-declaration]
*  ret = __tree_mod_log_insert_key(fs_info, eb, slot,
*  ^
*cc1: some warnings being treated as errors
*scripts/Makefile.build:308: recipe for target 'fs/btrfs/ctree.o' failed

Said function prototype is nowhere to be found, only the regular non-
scoped function. Did you just miss this call? Changing the call to the 
remaining tree_mod_log_insert_key() looks like what was intended and 
compiles, but I wanted to check before I burn the house down. :)

-h

