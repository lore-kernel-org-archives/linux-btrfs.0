Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:58410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499Ab3H1Pid (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 11:38:33 -0400
Message-ID: <521E1977.2010806@sgi.com>
Date: Wed, 28 Aug 2013 10:38:31 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: update _filter_size() for Btrfs
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de> <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Stefan, it has been committed.

--Rich

commit 8a51dad60a015e0b261e0f78428731b00b992ce9
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:12 2013 +0000

     xfstests: update _filter_size() for Btrfs

