Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52223 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932882AbcDYQYU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 12:24:20 -0400
Date: Mon, 25 Apr 2016 18:23:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/3] btrfs: keep sysfs target add in the last
Message-ID: <20160425162358.GD29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
 <1458816494-483-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458816494-483-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 06:48:13PM +0800, Anand Jain wrote:
> Sysfs create context should come in the last, so that we
> don't have to undo sysfs operation for the reason that any
> other operation has failed.

Moving the sysfs call will make a visible change: in the old code, the
sysfs node exists during the whole replace process, while in the new
code it appears only after it finishes. While this is not necessarily a
problem, I'd like to check that his is an intended change, as it's not
mentioned in the changelog.

Besides, the sysfs node seems to be added unconditionally, so if the
scrub is running in parallel (checked a few lines above the new code),
we'll happily add the target device although no replace happened.
