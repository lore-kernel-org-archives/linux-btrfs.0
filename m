Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3JVQwf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 12:52:35 -0400
Date: Tue, 22 Oct 2013 18:52:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Anand Jain <Anand.Jain@oracle.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
Message-ID: <20131022165233.GA1032@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
 <20131015171333.GM5787@twin.jikos.cz>
 <20131021144428.GG6924@localhost.localdomain>
 <526612EB.1050802@oracle.com>
 <20131022132147.GA27304@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131022132147.GA27304@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 22, 2013 at 09:21:47AM -0400, Josef Bacik wrote:
> Did you test these?  Because they aren't working for me, so I think a revert is
> the only solution.  Thanks,

The impact of the failing test is imho not that big to justify a full
revert from integration branch (were it in master, then yes). I see the
bug and I hope Anand will fix it soon.

david
