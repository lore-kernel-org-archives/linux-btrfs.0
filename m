Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbbBJOsl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 09:48:41 -0500
Date: Tue, 10 Feb 2015 15:48:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/10] Enhance btrfs-find-root and open_ctree() to
 provide better chance on damaged btrfs.
Message-ID: <20150210144839.GC28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422522437-18886-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 29, 2015 at 05:07:15PM +0800, Qu Wenruo wrote:
> Also, since only 2 patches is modified(although other part is slightly
> modified to match the change), to avoid mail bombing, I created the pull
> request on github and only send the first 2 patches with cover-letter.
> https://github.com/kdave/btrfs-progs/pull/5

Sending the changed patches only is ok (if you point me at the rest of
the patches), but it's not necessary to open the github pull request.

The version to version changelogs are also stored in the commit
changelogs, that's a bit unexpected for a branch to be pulled.

I've been reviewing this patch series and am mostly ok with that so I'm
going to pull that soon.

