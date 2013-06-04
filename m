Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47759 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3FDXQ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 19:16:56 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E749D9A067F
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Jun 2013 17:16:55 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Zach Brown <zab@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
Message-ID: <20130604231653.4088.91500@localhost.localdomain>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Tue, 4 Jun 2013 19:16:53 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Zach Brown (2013-06-04 18:17:54)
> Hi gang,
> 
> I finally sat down to fix that readdir hang that has been in the back
> of my mind for a while.  I *hope* that the fix is pretty simple: just
> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> indicator that we shouldn't return entries.  Does this look reasonable?

I like it, and it doesn't look too far away from how others are abusing
f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
loves to surprise me.

-chris
