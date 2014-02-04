Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from skade.schwarzvogel.de ([144.76.18.87]:40487 "EHLO
	mail.schwarzvogel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbaBDOkL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Feb 2014 09:40:11 -0500
Received: from klausman by mail.schwarzvogel.de with local (Exim 4.82)
	(envelope-from <klausman@schwarzvogel.de>)
	id 1WAguz-000PB1-NH
	for linux-btrfs@vger.kernel.org; Tue, 04 Feb 2014 15:24:05 +0100
Date: Tue, 4 Feb 2014 15:24:05 +0100
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: use late_initcall instead of module_init
Message-ID: <20140204142405.GA93647@skade.schwarzvogel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391290076-13149-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

as discussed on IRC, this makes 3.14-rc1 able tomount brtfs
again. Key difference (aside from being (un)able to mount) is that
btrfs now actually shows up in /proc/filesystems, where with
vanilla 3.14-rc1 it does not.

Tested on an i5-3470T.

Tested-By: Tobias Klausmann <klausman@schwarzvogel.de>


