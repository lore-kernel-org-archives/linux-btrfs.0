From: Jan Schubert <Jan.Schubert@GMX.li>
Subject: Re: [PATCH v8 0/8] Btrfs scrub: print path to corrupted files and trigger nodatasum fixup
Date: Fri, 29 Jul 2011 15:53:27 +0000 (UTC)
Message-ID: <loom.20110729T174701-406@post.gmane.org>
References: <cover.1311778307.git.list.btrfs@jan-o-sch.net> <loom.20110727T183833-109@post.gmane.org> <loom.20110728T003246-429@post.gmane.org> <loom.20110728T163725-25@post.gmane.org> <4E31959B.60907@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Jan Schmidt <list.btrfs <at> jan-o-sch.net> writes:
> I think you shouldn't. The "errors 400" is reported constantly in
> #btrfs, it resolves to REF_ERR_NO_ROOT_BACKREF. There should be a
> backref, but I haven't heard of any negative impact.
> 
> If you are curious, you can try to grab the "inspect-internal" patches
> for btrfs-progs and use "btrfs inspect-internal resolve-inode 5067" to
> see what files are referenced by those inodes (given you are still
> running the kernel you used for scrubbing).

Thx Jan, I did not follow your advice but used the btrfs-debug-tree to
determine the affected files. After deleting them it has been OK. 
Interessting thing is, that in one case copying the file has been
possible to resolve one of these errors (after deleting the original file
of course). Other affected file throw an input/output error when trying
to access them.

Let me know when I can test some more things. I can offer to run the
newest kernels and patches and report any issues!?

Thx,
Jan

