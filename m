Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57217 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbcCJQlR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 11:41:17 -0500
Date: Thu, 10 Mar 2016 17:40:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH V4 2/2] btrfs-progs: Introduce device delete by devid
Message-ID: <20160310164056.GI18908@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444123990-8832-1-git-send-email-anand.jain@oracle.com>
 <1457518226-601-1-git-send-email-anand.jain@oracle.com>
 <20160309165515.GA18908@suse.cz>
 <56E0E569.5010309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56E0E569.5010309@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 11:09:29AM +0800, Anand Jain wrote:
> 
> > Please send any followup changes on top of the current devel patch.
> 
>   I kind of missed this point at the wiki.
>     --
>     The git repositories on kernel.org are not used for development
>     or integration branches.
>     --
>   Thanks for the update on how things work at your end, which helps
>   to keep loss of productive at low.

The development branch workflow in progs has been used for months, I
don't know why that would be news for you.

>   Suggest that we need to update similar for the kernel
>   section as well. I see some of the inactive branches
>   being mentioned there. And its bit confusing as of now.

That's probably the section about btrfs-next tree that is not active for
a long time. Apparently nobody cared enough to fix it which just
underlines lack of active wiki editors.

I don't understand why you bring it up now, you're a long-term
contributor so you're supposed to know how the patches get merged.
