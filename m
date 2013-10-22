Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:42834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab3JVV0v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 17:26:51 -0400
Message-ID: <5266ED97.1020308@sgi.com>
Date: Tue, 22 Oct 2013 16:26:47 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>, <sandeen@redhat.com>
Subject: Re: [PATCH] xfstests: stat the dev we're removing to make sure its'
 really gone V3
References: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1382372033-2742-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This has been committed.

Thanks
--Rich

commit 22ebe357198ea2519af6fd7e9082b9ac432631de
Author: Josef Bacik <jbacik@fusionio.com>
Date:   Mon Oct 21 16:13:53 2013 +0000

     xfstests: stat the dev we're removing to make sure its' really gone
