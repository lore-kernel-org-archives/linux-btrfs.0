Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57299 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753342AbdFMOZ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 10:25:58 -0400
Date: Tue, 13 Jun 2017 16:24:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 6/7] Btrfs: __tree_mod_log_insert decrease max compare
 count
Message-ID: <20170613142452.GX25451@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170607005844.2078-1-nefelim4ag@gmail.com>
 <20170607005844.2078-7-nefelim4ag@gmail.com>
 <CAL3q7H7m0XmLDYoox6QeuiwGw6sw-ftTp-TDgO+PdJBj-i39ig@mail.gmail.com>
 <CAGqmi75iWukq=EVc7EnECywTwJz3wjyye==Hy3eMrY6SgcfmvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi75iWukq=EVc7EnECywTwJz3wjyye==Hy3eMrY6SgcfmvQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 07, 2017 at 02:01:46PM +0300, Timofey Titovets wrote:
> 2017-06-07 12:45 GMT+03:00 Filipe Manana <fdmanana@gmail.com>:
> > On Wed, Jun 7, 2017 at 1:58 AM, Timofey Titovets <nefelim4ag@gmail.com> wrote:
> >> In worst case code do 4 comparison,
> >> just add some new checks to switch check branch faster
> >> now in worst case code do 3 comparison
> >
> > Some comments below.
> >
> >>
> >> Signed-off-by: Timofey Titovets <nefelim4ag@gmail.com>
> >> ---
> >>  fs/btrfs/ctree.c | 20 +++++++++++---------
> >>  1 file changed, 11 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> >> index a3a75f1de..318379531 100644
> >> --- a/fs/btrfs/ctree.c
> >> +++ b/fs/btrfs/ctree.c
> >> @@ -460,15 +460,17 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
> >>         while (*new) {
> >>                 cur = rb_entry(*new, struct tree_mod_elem, node);
> >>                 parent = *new;
> >> -               if (cur->logical < tm->logical)
> >> -                       new = &((*new)->rb_left);
> >> -               else if (cur->logical > tm->logical)
> >> -                       new = &((*new)->rb_right);
> >> -               else if (cur->seq < tm->seq)
> >> -                       new = &((*new)->rb_left);
> >> -               else if (cur->seq > tm->seq)
> >> -                       new = &((*new)->rb_right);
> >> -               else
> >> +               if (cur->logical != tm->logical) {
> >> +                       if (cur->logical < tm->logical)
> >> +                               new = &((*new)->rb_left);
> >
> > So now when cur->logical is less then tm->logical, we do 2 comparisons
> > instead of 1.
> > Is this case much less common always? If it were it could be a good change.
> > What guarantees that this change will give better performance for
> > common workloads? What guarantees you the example I just gave isn't
> > typical for most/many common workloads?
> >
> > And most importantly, did you actually do some benchmarks that justify
> > this change? Is this a hot code path that would benefit from such
> > changes?
> > (Since it's the tree mod log, seldom used, I really doubt it).
> >
> > Same comments apply to all the other similar patches you have sent.
> 
> Nope, i just lack of expirience to do such benchmarks,
> same for understand all btrfs code, it's difficult to say that path is hot/cold.

So if you call the patchset cleanups and then claim some
performance-related improvements, you can expect to be called out to
provide numbers or an analysis.

I've checked the resulting assembly of "Btrfs: backref_comp decrease max
compare count" that does similar conversion of the sequence of ifs.
Surprise surprise, the assembly does not differ regarding number of
branches. This at mininimum can be done before any profiling to see if
this makes sense.

If the assembly stays the same, the code readability may be preferred,
which is one of the points of cleanup patches. In that case I prefer the
current code over your change, but it may be just personal preference
and because I'm used to reading the "linear ifs" pattern.

> I just did reread all btrfs code, analize that i understand and trying
> fix places that looks questionably.
> 
> In most cases i can explain why this can help (IMHO):
> 01 - __compare_inode_defrag - we compare inodes, by my expirience
> in most distros and setups btrfs have 1-2 subvolumes (root_ids), so in
> most time root_id1 == root_id2
> 02 - backref_comp - same
> 03 - ref_node_cmp - same
> 04 - ref_tree_add - just a cleanup, compiller do the same
> https://godbolt.org/g/Ww93ws
> 05 - add_all_parents - just a cleanup, compiller do the same
> https://godbolt.org/g/srSGeW
> 07 - end_workqueue_bio - if i understand correctly this code executed
> on every write,
> so by convertion to switch case will save several cpu cycles on every write
> 
> For that function (06 -  __tree_mod_log_insert):
> i do the same as for 01-03 "by inertia" - as i just not know all code,
> i just assume that as this fuction work with rb tree, values will be
> equally distributed

>From my point above, I'll not merge patches 1, 2, 3 and 6. Patches 4 and 5
seem ok.

Patch 7 does not result in the equivalent code, as reported by the
kbuild robot. But converting the ifs to switch is desired in
end_workqueue_bio, namely the second branch as it's not clear how are
some of the BTRFS_WQ_ENDIO_* values handled.

If you still care, please resend 4 and 5. The changelog does not need to
repeat the code, more describe that the change simplifies the code to
make it more readable.
