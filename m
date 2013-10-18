Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab3JRQRP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 12:17:15 -0400
Date: Fri, 18 Oct 2013 09:17:11 -0700
From: Zach Brown <zab@redhat.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix up seek_hole/seek_data handling
Message-ID: <20131018161711.GB2316@lenny.home.zabbo.net>
References: <1382111301-3116-1-git-send-email-jbacik@fusionio.com>
 <20131018221115.460375f7@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131018221115.460375f7@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 18, 2013 at 10:11:15PM +0600, Roman Mamedov wrote:
> On Fri, 18 Oct 2013 11:48:21 -0400
> Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > Whoever wrote this was braindead.
> 
> You do realize you sent a number of people googling for "Delalloc is such a
> pain. If we have a hole and we have pending" just out of curiosity? :))

Hmm?  git blame, friend :).  Not that we needed to.  We knew exactly who
he was referring to the moment we read the comment.  We love us some
Josef.

- z
