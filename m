Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab3HFTLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 15:11:25 -0400
Date: Tue, 6 Aug 2013 12:11:18 -0700
From: Zach Brown <zab@redhat.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fusionio.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/4] btrfs: offline dedupe
Message-ID: <20130806191118.GP12314@lenny.home.zabbo.net>
References: <1375814571-31753-1-git-send-email-mfasheh@suse.de>
 <1375814571-31753-5-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375814571-31753-5-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 06, 2013 at 11:42:51AM -0700, Mark Fasheh wrote:
> This patch adds an ioctl, BTRFS_IOC_FILE_EXTENT_SAME which will try to
> de-duplicate a list of extents across a range of files.

This addresses all my previous issues (save the interface that we've
aggreed to disagree on).  Thanks for taking the time to fix it up.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
