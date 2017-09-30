Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:50533 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751467AbdI3Qii (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 12:38:38 -0400
Received: by mail-lf0-f65.google.com with SMTP id d4so2254841lfj.7
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 09:38:38 -0700 (PDT)
Subject: Re: What means "top level" in "btrfs subvolume list" ?
To: Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <762acea0-3f55-4fc0-c5eb-604304152f3e@inwind.it>
 <22991.45029.564275.154171@tree.ty.sabi.co.uk>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <ba6dad59-602b-61d8-8e55-1aa37028db29@gmail.com>
Date: Sat, 30 Sep 2017 19:38:35 +0300
MIME-Version: 1.0
In-Reply-To: <22991.45029.564275.154171@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

30.09.2017 17:53, Peter Grandi пишет:
>> I am trying to figure out which means "top level" in the
>> output of "btrfs sub list"
> 
> The terminology (and sometimes the detailed behaviour) of Btrfs
> is not extremely consistent, I guess because of permissive
> editorship of the design, in a "let 1000 flowers bloom" sort
> of fashion so that does not matter a lot.
> 
>> [ ... ] outputs a "top level ID" equal to the "parent ID" (on
>> the basis of the code).
> 
> You could have used option '-p' and it would have printed out
> both "top level ID" and "parent ID" for extra enlightenment.
> 

How does it explain what "top level" is?

>> But I am still asking which would be the RIGHT "top level id".
> 
> But perhaps one of them is now irrelevant, because 'man btrfs
> subvolume says:
> 
>   "If -p is given, then parent <ID> is added to the output
>   between ID and top level. The parent’s ID may be used at mount
>   time via the subvolrootid= option."
> 
> and 'man 5 btrfs' says:
> 
>   "subvolrootid=objectid
>     (irrelevant since: 3.2, formally deprecated since: 3.10)
>     A workaround option from times (pre 3.2) when it was not
>     possible to mount a subvolume that did not reside directly
>     under the toplevel subvolume."
> 

This still does not explain what "top level" in "btrfs sub list" means.

>> My Hypothesis, it should be the ID of the root subvolume ( or
>> 5 if it is not mounted). [ ... ]
> 
> Well, a POSIX filesystem typically has a root directory, and it
> can be mounted as the system root or any other point. A Btrfs
> filesystem has multiple root directories, that are mounted by
> default "somewhere" (a design decision that I think was unwise,
> but "whatever").
> 
> The subvolume containing the mountpoint directory of another
> subvolume's root directory is is no way or sense its "parent",
> as there is no derivation relationship; root directories are
> independent of each other and their mountpoint is (or should be)
> a runtime entity.
> 

With all respect that is not how it looks like. Each subvolume has very
precise relationship to containing subvolume; you can only traverse
subvolumes via this very explicit relationship. The fact that subvolumes
can also be mounted individually on VFS level is rather irrelevant for
filesystem structure.

Whether "parent" is correct name for containing subvolume is of course
subject to opinion, but for me it fits - subvolumes do form a tree and
have very well defined parent/child relationship.

> If there is a "parent" relationship that maybe be between
> snapshot and origin subvolume (ignoring 'send'/'receive'...),

Yes, having the same name for entirely different types of hierarchical
relationships is unfortunate. But it still does not explain what "top
level" means :)
