From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: State of btrfs send/receive
Date: Mon, 26 Mar 2012 19:17:15 +0200
Message-ID: <4F70A49B.7050808@jan-o-sch.net>
References: <CAB9VWqBM3n6ACp8tx42zwzyLyme-HXB-Ag-t0JMhZBjKjjwwcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alexander Block <ablock84@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB9VWqBM3n6ACp8tx42zwzyLyme-HXB-Ag-t0JMhZBjKjjwwcw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On 26.03.2012 17:46, Alexander Block wrote:
> I used btrfs some time to do incremental backups of large (200GB) VM
> images, which worked fine using snapshots and rsync (with --inplace to
> preserve COW).
> The only problem with this solution is that it takes extremely long
> due to rsync's performance on large files. For this reason, I can't
> await the btrfs send/receive feature.
> The latest discussion regarding send/receive that I know about is this one:
> 
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/12318/focus=12340
> 
> So my question is, especially to Jan Schmidt, are there any news on
> this feature?

Well. I'm currently on a side track. To do efficient send/receive, we
need working backref resolving. For this, we could define you'll need
read-only snapshots before you can send them. Backref resolving on
read-only tree structures is working fine[*].

We've got more candidates for backref resolving, though, one of which is
the qgroups patch set. This depends on backrefs in live trees, while
they're being changed.

Thus, although we've got working backref resolving[*] I still haven't
dropped that task. I want to get them working on live trees, where my
feeling is that I'm getting really close now, but it'll definitely not
hit this merge window. (Not to mention that I've been at false "really
close"-feelings before.)

I want to see the send/receive tool working as soon as possible. Some of
the required work for the user space part is already done in my private
repository. I could provide that to you, together with a description of
what I've got in mind for that tool. We could agree on an interface and
then split the task such that you could be doing the user space tool
while I'm fiddling with the kernel if you like.

-Jan

[*] Slightly broken for the scrub-repair case since 3.3-rc1, there's a
patch to come for 3.4-rc1 the next days.
