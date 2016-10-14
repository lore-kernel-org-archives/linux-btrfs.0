Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:48123 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbcJNEnr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 00:43:47 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1buuLE-0001r1-Hd
        for linux-btrfs@vger.kernel.org; Fri, 14 Oct 2016 06:43:32 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Incremental send robustness question
Date: Fri, 14 Oct 2016 04:43:03 +0000 (UTC)
Message-ID: <pan$f1d6c$3285aa5a$373244fa$922392c4@cox.net>
References: <20161012222955.GB2412@fox.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sean Greenslade posted on Wed, 12 Oct 2016 18:29:55 -0400 as excerpted:

> Hi, all. I have a question about a backup plan I have involving
> send/receive. As far as I can tell, there's no way to to resume a send
> that has been interrupted. In this case, my interruption comes from an
> overbearing firewall that doesn't like long-lived connections. I'm
> trying to do the initial (non-incremental) sync of the first snapshot
> from my main server to my backup endpoint. The snapshot is ~900 GiB, and
> the internet link is 25 Mbps, so this'll be going for quite a long time.
> 
> What I would like to do is "fake" the first snapshot transfer by
> rsync-ing the files over. So my question is this: if I rsync a subvolume
> (with the -a option to make all file times, permissions, ownerships,
> etc. the same),
> is that good enough to then be used as a parent for future incremental
> sends?

I see the specific questions have been answered, and alternatives 
explored in one direction, but I've another alternative, in a different 
direction, to suggest.

First a disclaimer.  I'm a btrfs user/sysadmin and regular on the list, 
but I'm not a dev, and my own use-case doesn't involve send/receive, so 
what I know regarding send/receive is from the list and manpages, not 
personal experience.  With that in mind...

It's worth noting that send/receive are subvolume-specific -- a send 
won't continue down into a subvolume.

Also note that in addition to -p/parent, there's -s/clone-src.  The 
latter is more flexible than the super-strict parent option, at the 
expense of a fatter send-stream as additional metadata is sent that 
specifies which clone the instructions are relative to.

It should be possible to use the combination of these two facts to split 
and recombine your send stream in a firewall-timeout-friendly manner, as 
long as no individual files are so big that sending an individual file 
exceeds the timeout.

1) Start by taking a read-only snapshot of your intended source 
subvolume, so you have an unchanging reference.

2) Take multiple writable snapshots of it, and selectively delete subdirs 
(and files if necessary) from each writable snapshot, trimming each one 
to a size that should pass the firewall without interruption, so that the 
combination of all these smaller subvolumes contains the content of the 
single larger one.

3) Take read-only snapshots of each of these smaller snapshots, suitable 
for sending.

4) Do a non-incremental send of each of these smaller snapshots to the 
remote.

If it's practical to keep the subvolume divisions, you can simply split 
the working tree into subvolumes and send those individually instead of 
doing the snapshot splitting above, in which case you can then use -p/
parent on each as you were trying to do on the original, and you can stop 
here.

If you need/prefer the single subvolume, continue...

5) Do an incremental send of the original full snapshot, using multiple
-c <src> options to list each of the smaller snapshots.  Since all the 
data has already been transferred in the smaller snapshot sends, this 
send should be all metadata, no actual data.  It'll simply be combining 
the individual reference subvolumes into a single larger subvolume once 
again.

6) Once you have the single larger subvolume on the receive side, you can 
delete the smaller snapshots as you now have a copy of the larger 
subvolume on each side to do further incremental sends of the working 
copy against.

7) I believe the first incremental send of the full working copy against 
the original larger snapshot will still have to use -c, while incremental 
sends based on that first one will be able to use the stricter but 
slimmer send-stream -p, with each one then using the previous one as the 
parent.  However, I'm not sure on that.  It may be that you have to 
continue using the fatter send-stream -c each time.

Again, I don't have send/receive experience of my own, so hopefully 
someone who does can reply either confirming that this should work and 
whether or not -p can be used after the initial setup, or explaining why 
the idea won't work, but at this point based on my own understanding, it 
seems like it should be perfectly workable to me. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

