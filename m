Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab3AQPJe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Jan 2013 10:09:34 -0500
Date: Thu, 17 Jan 2013 16:09:32 +0100
From: Arvin Schnell <aschnell@suse.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: [PATCH] trivial patch for btrfs-progs
Message-ID: <20130117150932.GA11610@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


Hi,

please find attached a trivial patch for btrfs-progs. Likely not
strictly needed but I noticed valgrind complaining about
uninitialised memory in the ioctl call.

Regards,
  Arvin

-- 
Arvin Schnell, <aschnell@suse.de>
Senior Software Engineer, Research & Development
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
Maxfeldstraße 5
90409 Nürnberg
Germany

--fUYQa+Pmc3FrFX/N
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="memset.diff"

diff --git a/cmds-send.c b/cmds-send.c
index 9b47e70..aa8c5a3 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -271,6 +271,7 @@ static int do_send(struct btrfs_send *send, u64 root_id, u64 parent_root)
 		goto out;
 	}
 
+	memset(&io_send, 0, sizeof(io_send));
 	io_send.send_fd = pipefd[1];
 	send->send_fd = pipefd[0];
 

--fUYQa+Pmc3FrFX/N--
