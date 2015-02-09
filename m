Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:41944 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759087AbbBIUD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Feb 2015 15:03:27 -0500
From: Josef Bacik <jbacik@fb.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [GIT PULL] btrfsck and btrfs-image fixes
Date: Mon, 9 Feb 2015 15:03:03 -0500
Message-ID: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This series of patches fixes up btrfsck in lots of ways and adds some new
functionality.  These patches were required to fix Hugo's broken multi-disk fs
as well as fix fsck so it would actually pass all of the fsck tests.  This also
fixes a long standing btrfs-image problem where it wouldn't restore multi disk
images onto a single disk properly.  Dave you can pull this from

https://github.com/josefbacik/btrfs-progs.git for-kdave

These patches all pass make test.  Thanks,

Josef
