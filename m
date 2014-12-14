Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:48118 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750998AbaLNIpQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Dec 2014 03:45:16 -0500
Message-ID: <548D4E19.4040407@pobox.com>
Date: Sun, 14 Dec 2014 00:45:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com> <548B5FD6.5080306@pobox.com> <ce7dba343916e4262a92071af863d014@admin.virtall.com> <548B6D58.6080804@pobox.com> <a3dfa2330fae3ef52d19f9f2a951e7b9@admin.virtall.com> <548B7329.80208@pobox.com> <016ec9492d0340f8ac439ba4bcec03ad@admin.virtall.com> <548C0942.6020304@pobox.com> <a54531e35f70cb4d15a606385d2b581e@admin.virtall.com> <548CA76C.1060900@pobox.com> <df28609e5b5449b25076bfcf38f9a3de@admin.virtall.com> <548CD23E.8080702@pobox.com>
In-Reply-To: <548CD23E.8080702@pobox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2014 03:56 PM, Robert White wrote:
> ...

Dangit... On re-reading I think I was still less than optimally clear. I 
kept using the word "resent" when I should have been using a word like 
"re-written" or "re-stored" (as opposed to "restored"). On re-reading 
I'm not sure what the least confusing word would be.

So here is a contrived example with seriously simplified assumptions):

Lets say every day rsync coincidentally sends 1Gib and the receiving 
filesystem is otherwise almost quiescent. So as a side effect the 
receiving filesystem monotonically creates one 1GiB data extent. A 
snapshot is taken every day after the rsync. (This is all to just to 
make the mental picture easier.)

Lets say there is a file Aardvark that just happens to be the first file 
considered every time and also happens to grow by exactly 1MiB in pure 
append each day and started out at 1MiB. After ten days Aardvark is 
stored across the ten extents. After 100 days it is store across 100 
extents. Each successive 1MiB is exactly 1023MiB away from its 
predecessor and successor.

Now consider file Badger, the second file. It is 100MiB in size. It is 
also modified each day such that five percent of its total bytes are 
rewritten as exactly five records of exactly 1MiB aligned on 1MiB 
boundaries, all on convenient rsync boundaries. On the first day a 
100MiB chunk lands square in the first data Extent right next to 
Aardvark. On the second and every successive day 5MiB lands next to 
Aardvark in the next extent. But the 5MiB is not a contiguous, they are 
1MiB holes punched in a completely fair distribution across all the 
active fragments of Badger wherever they lie.

A linear read of Aardvark gets monotonically worse with each rsync. A 
linear read of Badger decays towards being 100 head seeks for every 
linear read.

Now how does rsync work? It does a linear read of each file. All of 
Aardvark, then all of Badger (etc) to create the progressive checksum 
stream that it uses to determine if a block needs to transmitted or not.

Now if we start "aging off" (and deleting) snapshots, we start realizing 
the holes in the oldest copies of Badger. There is a very high 
probability that the next chunk of Aardvark is going to end up somewhere 
in Badger-of-day-one. Worse still, some parts of Badger are going to end 
up in Badger-of-day-one but nicely out of order.

At this point the model starts to get too complex for my understanding 
(I don't know how BTRFS selects which data extent to put any one chunk 
of data in relative to the rest of the file contents of whether it tries 
to fill the fullest chunk, the least-full chunk, or if it does some 
other best-fit for this case, so I have to stop that half of the example 
there.)

Additionally: After (N*log(N))^2 days (where I think N is 5) [because of 
fair randomness] {so just shy of two months?} there is a high 
probability that no _current_ part of Badger is still mapped to data 
extent 1. But it is still impossible for snapshot removal to result in a 
reclaim of data extent 1... Aardvark's first block is there forever.

Now compare this to doing the copy.

A linear write of a file is supposed to be (if I understand what I'm 
reading here) laid out as closely-as-possible as a linear extent on the 
disk. Not guaranteed, but its a goal.  This would be "more true" if the 
application doing the writing called fallocate(). [I don't know if rsync 
does fallocate(), I'm just saying.]

So now on day one, Aardvark is one 1MiB chunk in Data extent 1, followed 
by all of Badger.

On day two Aardvark is one 2MiB chunk in Data extent 2, followed by all 
of Badger.

(magical adjustments take place in the source data stream so that we are 
still, by incredible coincidence, using up exactly one extent every day. 
[it's like one of those physics problems where we get to ignore 
friction. 8-)])

On every rsync pass, both the growing Aardvark and the active working 
set of Badger are available as linear reads while making the rolling 
checksums.

If Aardvark and/or Badger need to be used for any purpose from one or 
more of the snapshots, they will also benefit from locality and linear 
read optimization.

When we get around to deleting the first snapshot all of the active 
parts of Aardvark and Badger are long gone. (and since this is magical 
fairly land, data extent one is reclaimed!).

---

How realistic is this? Well clearly magical fairies were involved in the 
making of this play. But the role of Badger will be played by a database 
tablespace and his friend Aardvark will be played by the associated 
update journal. Meaning that both of those two file behaviors are 
real-world examples (not withstanding the cartoonish monotonic update 
profile).

And _clearly_ once you start deleting older snapshots the orderly 
picture would fall apart piecewise.

Then again, according to grep, my /usr/bin/rsync contains the string 
"fallocate". Not a guarantee it's being used, but a strong indicator. 
Any use of fallocate tends to imply that later defrag would not change 
efficiency, so there's another task you wouldn't need to undertake.

So it's a classic trade-off of efficiencies of space vs order.

Once you achieve your dynamic balance, with whole copies of things 
tending to find their homes your _overall_ performance should become 
more stable over time as it bounces back and forth about a mean 
performance for the first few cycles (a cycle being completed when the 
snapshot is deleted).

Right now you are reporting that it was becoming less stable over time.

So there is your deal right there.
