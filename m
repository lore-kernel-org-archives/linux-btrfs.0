Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbcEMI0m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 04:26:42 -0400
Date: Fri, 13 May 2016 10:26:17 +0200
From: David Sterba <dsterba@suse.cz>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/1] btrfs-progs: Typo review of strings and comments
Message-ID: <20160513082617.GV29353@suse.cz>
Reply-To: dsterba@suse.cz
References: <1463010636-18514-1-git-send-email-nsteeves@gmail.com>
 <20160512112916.GN29353@twin.jikos.cz>
 <CAD=QJKhQHeL5JnA+X1=e2DPqHS5UXVyPsDgaGMoTM15CyyCpLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAD=QJKhQHeL5JnA+X1=e2DPqHS5UXVyPsDgaGMoTM15CyyCpLQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 12, 2016 at 04:56:46PM -0400, Nicholas D Steeves wrote:
> Thank you for reviewing this patch.  Sorry for missing the context of
> the strtoull comment; I should have been able to infer that and am
> embarrassed that I failed to.  Also, embarrassed because I think I've
> used it in some C++ code!
> 
> I learned how to use git rebase and git reset today, and can submit a
> v2 patch diffed against master at your earliest convenience.  My only
> remaining question is this:

No need to send v2, I fixed the issues (and usually do if they seem
easy).

> mkfs.c: printf:("Incompatible features:  %s", features_buf)
>   * Should this be left as "Imcompat features"?

Actually yes, it should be 'Incompat', patch updated.
