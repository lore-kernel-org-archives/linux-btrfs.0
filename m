Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59693 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3IXWCT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Sep 2013 18:02:19 -0400
Date: Wed, 25 Sep 2013 00:02:13 +0200
From: Mathieu Chouquet-Stringer <ml2news@free.fr>
To: linux-btrfs@vger.kernel.org
Subject: Re: Failure to remove snapshot with 3.12* and FS switches to
 read-only
Message-ID: <20130924220213.GA17590@wasting>
References: <20130923125417.GA3413@wasting>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130923125417.GA3413@wasting>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 23, 2013 at 02:54:17PM +0200, Mathieu Chouquet-Stringer wrote:
> My system is configured to do FS snapshots when I upgrade packages.  I
> have a cron job which runs at night to delete these snapshots.  Its goal
> is to keep 10 snapshots maximum, one per day if possible.
> 
> This works perfectly with 3.11.1 but fails miserably with anything post
> 3.11.
> 
> With a pre 3.12 (3.11.0-10050-g3711d86), this is what happens:
> [...]

And this doesn't seem to happen anymore with 3.12-rc2, sorry for the
noise.
-- 
Mathieu Chouquet-Stringer                               m+btrfs@thi.eu.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
