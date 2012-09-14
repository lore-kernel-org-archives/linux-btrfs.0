Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:52537 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab2INSCI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 14:02:08 -0400
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id zS5wd8lKHbcuM6Tv (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 14 Sep 2012 12:02:06 -0600 (MDT)
Date: Fri, 14 Sep 2012 14:02:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove our ->freeze_fs and ->unfreeze_fs
Message-ID: <20120914180204.GO12994@localhost.localdomain>
References: <1347645637-1616-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347645637-1616-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 12:00:37PM -0600, Josef Bacik wrote:
> We do not need to do anything special to freeze or unfreeze, it's all taken
> care of by the generic work, and what we currently have is wrong anyway
> since we shouldn't be returnning to userspace with mutexes held anyway.
> Thanks,
> 

Hrm ignore this, apparently we have to at least have a freeze_fs in order for
freeze to work.

Josef
