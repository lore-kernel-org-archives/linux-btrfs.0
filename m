Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay1.sgi.com ([192.48.179.29]:56184 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993Ab3JPVY2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 17:24:28 -0400
Message-ID: <525F0427.6030107@sgi.com>
Date: Wed, 16 Oct 2013 16:24:55 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
CC: <sandeen@sandeen.net>, <dsterba@suse.cz>, <jbacik@fusionio.com>
Subject: Re: [PATCH v3] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com> <1381940718-778-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1381940718-778-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the patch Filipe.
This has been committed.

Thanks
--Rich

commit 8bab8b31bb288b9d1b077ff8d06b6491715e8da7
Author: Filipe David Borba Manana <fdmanana@gmail.com>
Date:   Wed Oct 16 16:25:18 2013 +0000

     xfstests: add specific test for default ACL inheritance

