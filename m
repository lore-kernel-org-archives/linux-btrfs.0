Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38434 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751252AbdGUVfb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Jul 2017 17:35:31 -0400
Received: by mail-wm0-f53.google.com with SMTP id w191so23793193wmw.1
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jul 2017 14:35:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
References: <1500576442.3508802.1047392992.202A4606@webmail.messagingengine.com>
 <3dd83854-362d-001a-e075-2156931a5cc2@mendix.com> <1500593465.333509.1047657672.4D69CB55@webmail.messagingengine.com>
 <1500617212.422990.1047894640.3B975261@webmail.messagingengine.com>
 <6f8c41cc-39a0-270e-0b8b-5debbdf455c9@codepoets.co.uk> <1500663236.2611541.1048467944.0014B72B@webmail.messagingengine.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 21 Jul 2017 15:35:29 -0600
Message-ID: <CAJCQCtR2n7WYo3BA9hw3RM97R4T+8+q9afRzfvkVvRpbemePZg@mail.gmail.com>
Subject: Re: kernel btrfs file system wedged -- is it toast?
To: Paul Jackson <pj@usa.net>
Cc: David Goodwin <david@codepoets.co.uk>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 12:53 PM, Paul Jackson <pj@usa.net> wrote:
>
> My btrfs file system, after doing a "mount -oclear_cache", followed
> by a "mount -ospace_cache", eleven hours ago now, is still hung.
>
> David Goodwin suggested:
>>> 'perf top' is my first thought.... it might at least highlight the area
>>> gobbling up cpu time.
>
> Thanks for suggesting that. It has been a long time since I've done
> any kernel work, and I didn't know of (or had forgotten about)
> perf-tools.   I just now installed these perf tools, and perf-top shows
> this btrfs activity on the system stil trying to handle the above
> "mount -ospace_cache":
>
> +   78.00%    78.00%  [btrfs]                      [k] btrfs_merge_delayed_refs
> +   38.56%     0.00%  [btrfs]                      [k] transaction_kthread
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_commit_transaction
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_start_dirty_block_groups
> +   38.56%     0.00%  [btrfs]                      [k] btrfs_run_delayed_refs
> +   38.56%     0.00%  [btrfs]                      [k] __btrfs_run_delayed_refs
>
> Regarding the time to balance - yes I too have many  snapshots,
> perhaps 100's to over a 1000 snapshots on each of a half dozen
> subvolumes, with major sharing within the subvolumes.
>
> Graham Cobb wrote:
>>>  If I understand correctly, this is because btrfs does not have
>>> an efficient structure to help find all the references
>
> Yeah this feels like  an Order n^2 or n^3 algorithm, or worse,  in
> the wrong place(s).

No need to feel, the code is published.

[chris@f26s ~]$ grep -nR btrfs_merge_delayed_refs
/srv/scratch/gits.20170719/linux//fs/btrfs/
/srv/scratch/gits.20170719/linux//fs/btrfs/delayed-ref.c:269:void
btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
/srv/scratch/gits.20170719/linux//fs/btrfs/delayed-ref.h:262:void
btrfs_merge_delayed_refs(struct btrfs_trans_handle *trans,
/srv/scratch/gits.20170719/linux//fs/btrfs/extent-tree.c:2566:
btrfs_merge_delayed_refs(trans, fs_info, delayed_refs,

>
> If this conclusion  is anywhere close to acccurate, then I would
> STRONGLY encourage the key developers of btrfs to announce
> loudly and clearly to any potential users, in multiple places
> (perhaps a key announcement in a few places and links to that
> announcement from many places, such as prominent WARNING's
> in man pages, at the top of Wiki pages, and in posts on prominent
> forums and Youtube with "click-bait" titles):
>
> ... Do NOT create more  than a few btrfs snapshots  in file systems
> ... that cannot tolerate being unexpectedly locked in uninterruptible
> ... kernel code, for minutes, hours, even days, depending on the
> ... operations being performed on them.  DO expect to first have to
> ... learn, the hard way, of whatever special mitigations might apply
> ... in ones particular circumstances, before considering deploying
> ... btrfs into a production environment where this, or other (what
> ... other?) surprising limitations of btrfs may apply.
>
> (The above suggested warning text may be technically inaccurate.
>  I'm just  guessing.)
>
> The btrfs developers should have known this, and announced this,
> a long time ago, in various prominent ways that it would be difficult
> for potential new users to miss.  All the prominent places that
> respond to the question of whether btrfs is ready for production
> use (spanning several years now) should if possible display this
> warning.
>
> Would you buy a car with an "unusual" engine that, whenever


If you've bought Btrfs, you have an SLA with a company like SUSE and
you can bring your complaint and reproducible problem to them, and
they'll probably provide some work arounds or advice until such time
as code improvements are available.

But if you're coming on the development list for advice on your own,
the usual way this works is you're expected to evaluate a file system
with your workload and basically just ask questions and state what
behavior you're experiencing, and see if it happens to catch a
developer's interest.

For hangs and performance related problems, often a developer will
like to see sysrq + t output. Depending on your kernel you'll need to
enable it, and then issue it - since my keyboards don't have a literal
sysrq key, I use Terminal and echo the value as described here:

https://www.kernel.org/doc/html/v4.11/admin-guide/sysrq.html

It's best to attached the output, if it's small enough, so MUAs don't
hose the formatting and make it insanely difficult to read; if it's
too big to attach (decently likely) then it needs to go up on pastebin
or as an uploaded file to the cloud and post the URL.


> Back in my day, such a performance bug would have made the
> software containing it unreleasable, _especially_ in software such
> as a major file system that is expected to provide reliable service,
> where "reliable" means both preserving data integrity and
> doing so within an order of magnitude of a reasonably
> expected  time.

OK? What contract or normative behavior makes this relevant and
applicable in this context?


>
> P.S. -- Hopefully my above diatribe represents an embarrassing
> lack of understanding on my part, rather than an embrarrassing
> lack of integrity on the part of key btrfs developers.

I think the former is certain, so consider your wish granted.

-- 
Chris Murphy
