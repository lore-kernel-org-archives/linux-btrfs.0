Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:42226 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751137Ab3HSUoH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Aug 2013 16:44:07 -0400
Message-ID: <5212838F.7030001@sgi.com>
Date: Mon, 19 Aug 2013 15:43:59 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: btrfs/009 never shrinked or removed $seqres.full
References: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376675094-21522-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Stefan, it has been committed.

--Rich

commit 6bd8df93fa6b7d9ce402f9c665e5971106df7843
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 16 17:44:54 2013 +0000

     xfstests: btrfs/009 never shrinked or removed $seqres.full

     Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
     Reviewed-by: Eric Sandeen <sandeen@redhat.com>
     Signed-off-by: Rich Johnston <rjohnston@sgi.com>
