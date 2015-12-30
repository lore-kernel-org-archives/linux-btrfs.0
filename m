Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-out1.informatik.tu-muenchen.de ([131.159.0.8]:57308 "EHLO
	mail-out1.informatik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867AbbL3PRt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Dec 2015 10:17:49 -0500
Received: (Authenticated sender: totakura)
	by mail.in.tum.de (Postfix) with ESMTPSA id E0EF91C2433
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Dec 2015 01:00:36 +0100 (CET)
To: linux-btrfs@vger.kernel.org
From: Sree Harsha Totakura <sreeharsha@totakura.in>
Subject: Confining scrub to a subvolume
Message-ID: <56831EA2.3090807@totakura.in>
Date: Wed, 30 Dec 2015 01:00:34 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is it possible to confine scrubbing to a subvolume instead of the whole
file system?

The problem I am facing is that I have a 5 TB btrfs FS.  On it I have
created subvolumes for weekly backups, personal photos, music, and
documents.  Obviously, I am more concerned about my photos and documents
than my backups and music.  Therefore, I would like to scrub the photos
and documents subvolumes more often than the backups subvolume.  Would
this be possible with the current tools?

Regards,
Sree
