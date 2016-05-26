Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37814 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbcEZF5N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 May 2016 01:57:13 -0400
Subject: [PATCH 0/7] xfstests: minor fixes for the reflink/dedupe tests
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com
Date: Wed, 25 May 2016 22:57:02 -0700
Message-ID: <146424222237.6278.4174636124436241002.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a patch set for xfstests that adds some more reflink tests
and fixes problems with some of the existing reflink tests.  Most
notably, I fixed the problems with the ENOSPC tests trying to use
the ENOSPC'd fs for loop control -- bad bad bad.

Comments and questions are, as always, welcome.  The fixes are
available on github[1].

--D

[1] https://github.com/djwong/xfstests/tree/djwong-devel
