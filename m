Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:54169 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753960Ab3H1QZy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Aug 2013 12:25:54 -0400
Message-ID: <521E248C.8020702@sgi.com>
Date: Wed, 28 Aug 2013 11:25:48 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: xfstests <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH][RESEND] xfstests: add a test for btrfs device replace
 operation
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de> <1377263233-8903-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1377263233-8903-2-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Stefan, it has been committed.

--Rich

commit 53b73199db79dcd58622aaac2e9b0f31073bfc44
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 23 13:07:11 2013 +0000

     xfstests: add a test for btrfs device replace operation

