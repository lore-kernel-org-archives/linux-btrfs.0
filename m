Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab3JHRTn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Oct 2013 13:19:43 -0400
Date: Tue, 8 Oct 2013 10:19:38 -0700
From: Zach Brown <zab@redhat.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 02/12] btrfs-progs: check fopen failure in cmds-send
Message-ID: <20131008171938.GL25712@lenny.home.zabbo.net>
References: <1381182185-10896-1-git-send-email-zab@redhat.com>
 <1381182185-10896-3-git-send-email-zab@redhat.com>
 <5253C552.7080609@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5253C552.7080609@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > @@ -72,6 +72,11 @@ int find_mount_root(const char *path, char **mount_root)
> >  	close(fd);
> >  
> >  	mnttab = fopen("/proc/mounts", "r");
> > +	if (!mnttab) {
> > +		close(fd);
> > +		return -errno;
> 
> close() can modify errno.
> 
> And close(fd) is already called 4 lines above. You didn't run the static
> code analysis again after applying your patch :)

OK, here's a less dumb attempt:

- z

>From f8a3425c184a55e0c254143e520e60a6856c27da Mon Sep 17 00:00:00 2001
From: Zach Brown <zab@redhat.com>
Date: Fri, 4 Oct 2013 15:38:18 -0700
Subject: [PATCH] btrfs-progs: check fopen failure in cmds-send

Check for fopen() failure.  This shows up in static analysis as a
possible null pointer derference.

Signed-off-by: Zach Brown <zab@redhat.com>
Laughed-at-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 cmds-send.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/cmds-send.c b/cmds-send.c
index 374d040..81b3e49 100644
--- a/cmds-send.c
+++ b/cmds-send.c
@@ -72,6 +72,9 @@ int find_mount_root(const char *path, char **mount_root)
 	close(fd);
 
 	mnttab = fopen("/proc/mounts", "r");
+	if (!mnttab)
+		return -errno;
+
 	while ((ent = getmntent(mnttab))) {
 		len = strlen(ent->mnt_dir);
 		if (strncmp(ent->mnt_dir, path, len) == 0) {
-- 
1.7.11.7

