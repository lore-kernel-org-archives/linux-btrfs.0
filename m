Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:36171 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab2JIMwb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 08:52:31 -0400
Message-ID: <50741E0D.30505@jan-o-sch.net>
Date: Tue, 09 Oct 2012 14:52:29 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 3/4] btrfs: extended inode refs
References: <1345494561-28758-1-git-send-email-mfasheh@suse.de> <1345494561-28758-4-git-send-email-mfasheh@suse.de>
In-Reply-To: <1345494561-28758-4-git-send-email-mfasheh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris, Hi Mark,

I'm currently working on extended inode refs for btrfs send, reading the version
of fs/btrfs/backref.c in Chris' next branch. Concerning commit
f8728be56e48e4a64ed49a71c66b3e6436869838 ...

On Mon, August 20, 2012 at 22:29 (+0200), Mark Fasheh wrote:
> Teach tree-log.c about extended inode refs. In particular, we have to adjust
> the behavior of inode ref replay as well as log tree recovery to account for
> the existence of extended refs.
> 
> Signed-off-by: Mark Fasheh <mfasheh@suse.de>
> ---
>  fs/btrfs/backref.c  |   68 +++++++++++
>  fs/btrfs/backref.h  |    5 +
>  fs/btrfs/tree-log.c |  316 ++++++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 337 insertions(+), 52 deletions(-)

I had made comments on v3 of this one, which were obviously ignored for v4. I
did not reply to v4, which is the version in "next". Despite that, this commit
has got a

    Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net

Chris, can you please remove that tag from the commit mentioned?

Thanks,
-Jan
