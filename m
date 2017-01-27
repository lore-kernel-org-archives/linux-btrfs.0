Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:45355 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750808AbdA0U3g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Jan 2017 15:29:36 -0500
Date: Fri, 27 Jan 2017 21:28:42 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Hans Deragon <hans@deragon.biz>, linux-btrfs@vger.kernel.org
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Message-ID: <20170127202842.ae2uutz4x45uxmzd@angband.pl>
References: <54678ac94c95687e00485d41fa5b5bc9@server1.deragon.biz>
 <W75Sc6PDCBok7W75TcCgc7@videotron.ca>
 <51114ea93a0f76a5ff6621e4d8983944@server1.deragon.biz>
 <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fab34ac1-03c0-76ea-eac2-ef4a210a48de@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 27, 2017 at 03:03:18PM -0500, Austin S. Hemmelgarn wrote:
> On 2017-01-27 11:47, Hans Deragon wrote:
> > However, as a user, I am seeking for an easy, no maintenance raid
> > solution.  I wish that if a drive fails, the btrfs filesystem still
> > mounts rw and leaves the OS running, but warns the user of the failing
> > disk and easily allow the addition of a new drive to reintroduce
> > redundancy.

> Before I make any suggestions regarding this, I should point out that
> mounting read-write when a device is missing is what caused this issue in
> the first place.  Doing so is extremely dangerous in any RAID setup,
> regardless of your software stack.  The filesystem is expected to store
> things reliably when a write succeeds, and if you've got a broken RAID
> array, claiming that you can store things reliably is generally a lie. MD
> and LVM both have things in place to mitigate most of the risk, but even
> there it's still risky.  Yes, it's not convenient to have to deal with a
> system that won't boot, but it's at least a whole lot easier from Linux than
> it is in most other operating systems.

Now, now.  Other RAID implementations already have this feature that you're
clamoring for!  When it is degraded, they will continue without a hitch, and
perform their duties not even bothering the user.  Then a couple years
later, the other disk will fail.  Obviously, there are no backups -- "we
have RAID".  This is when I get a call.

> The second is proper monitoring.  A well set up monitoring system will let
> you know when the disk is failing before it gets to the point of just
> disappearing from the system most of the time.

No problem, the second busted disk I mentioned above will include a full
mbox with a mail from mdadm for every single day.  They were either unread,
or read by an admin who ignored them and perhaps even wrote a filter to send
them to /dev/null.  Because the system still works, what's the hurry?


Meow!
-- 
Autotools hint: to do a zx-spectrum build on a pdp11 host, type:
  ./configure --host=zx-spectrum --build=pdp11
