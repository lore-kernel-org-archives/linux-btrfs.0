Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3FDX1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 19:27:01 -0400
Date: Tue, 4 Jun 2013 16:26:57 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130604232657.GE24721@lenny.home.zabbo.net>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130604231653.4088.91500@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> Quoting Zach Brown (2013-06-04 18:17:54)
> > Hi gang,
> > 
> > I finally sat down to fix that readdir hang that has been in the back
> > of my mind for a while.  I *hope* that the fix is pretty simple: just
> > don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > indicator that we shouldn't return entries.  Does this look reasonable?
> 
> I like it, and it doesn't look too far away from how others are abusing
> f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> loves to surprise me.

Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)

- z
