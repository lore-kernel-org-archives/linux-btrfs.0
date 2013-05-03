Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:42398 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761561Ab3ECPDh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 11:03:37 -0400
Message-ID: <5183D1D0.40608@sgi.com>
Date: Fri, 3 May 2013 10:03:44 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: xfs-oss <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: btrfs/276 - stop all fsstress before exiting
References: <517A10B1.7040107@redhat.com>
In-Reply-To: <517A10B1.7040107@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Eric and the review Jan, this has been committed.

--Rich

commit 0b5677123b5d8c0a29b45f55c7b981aeeca9b2c8
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Apr 26 05:29:21 2013 +0000

     xfstests: btrfs/276 - stop all fsstress before exiting

