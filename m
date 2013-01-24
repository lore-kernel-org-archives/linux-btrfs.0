Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab3AXXZs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 18:25:48 -0500
Date: Thu, 24 Jan 2013 15:24:54 -0800
From: Zach Brown <zab@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Eric Sandeen <sandeen@redhat.com>,
        Anand Jain <anand.jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>, "gene@czarc.net" <gene@czarc.net>
Subject: Re: [PATCH 10/10] Btrfs-progs: add show subcommand to subvol cli
Message-ID: <20130124232454.GH14246@lenny.home.zabbo.net>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-11-git-send-email-anand.jain@oracle.com>
 <5100C156.6010107@redhat.com>
 <20130124194238.GE14246@lenny.home.zabbo.net>
 <20130124231434.GA18554@shiny.int.fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130124231434.GA18554@shiny.int.fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Use safe unwinding in one exit path at the end, please.  It's less
> > maddening to audit and less likely to fail over time.
> 
> Really, goto is your friend ;)

I'm not going to use the word frenemy.  I'm just not :).

- z
