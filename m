From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: [PATCH v8 0/8] Btrfs scrub: print path to corrupted files and trigger nodatasum fixup
Date: Wed, 27 Jul 2011 22:34:45 +0000 (UTC)
Message-ID: <loom.20110728T003246-429@post.gmane.org>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <loom.20110727T183833-109@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schubert <Jan.Schubert <at> GMX.li> writes:

> 
> Jan Schmidt <list.btrfs <at> jan-o-sch.net> writes:
> > - bugfix for the case where refs exist but none are inline (reported by Jan
> >   Schubert)
> 
> Thx Jan, will give it try as soon as possible.

OK, Patch 1 to 3 did apply and run successfully on 3.0-git8. I've sent Jan some 
more details about the output of the affected files (which is actually just one 
quite large one).

Thx,
Jan


