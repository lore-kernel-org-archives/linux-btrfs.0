Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:37610 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753218Ab3HPP6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 Aug 2013 11:58:30 -0400
Message-ID: <520E4C4F.8030000@sgi.com>
Date: Fri, 16 Aug 2013 10:59:11 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfstests: redirect output in btrfs/003
References: <1376666323-27012-1-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1376666323-27012-1-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Stefan for the patch, it has been committed without the special 
header. ;)

--Rich

commit 0150222d1ceed701a637e0d271ddd36e4f489f7a
Author: Stefan Behrens <sbehrens@giantdisaster.de>
Date:   Fri Aug 16 15:18:43 2013 +0000

     xfstests: redirect output in btrfs/003

