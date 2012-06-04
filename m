Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab2FDSHT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jun 2012 14:07:19 -0400
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q54I7Gfo009240
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jun 2012 14:07:16 -0400
Date: Mon, 4 Jun 2012 14:07:16 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/7] Btrfs: check the return code of btrfs_save_ino_cache
Message-ID: <20120604180703.GA1889@localhost.localdomain>
References: <1338558955-4944-1-git-send-email-josef@redhat.com>
 <1338558955-4944-4-git-send-email-josef@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338558955-4944-4-git-send-email-josef@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 01, 2012 at 09:55:51AM -0400, Josef Bacik wrote:
> In doing my enospc work I would sometimes error out in btrfs_save_ino_cache
> which would abort the transaction but we'd still end up with a corrupted
> file system.  This is because we don't actually check the return value and
> so if somethign goes wrong we just exit out and screw everything up.  This
> fixes this particular part.  Thanks,

Dropping this patch, it doesn't actually matter if the space cache gets written
out or not and it actually fails if the caching has not finished which can lead
to a transaction being aborted for no reason.  Thanks,

Josef
