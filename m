Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:57686 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750742AbdILUBC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 16:01:02 -0400
Date: Tue, 12 Sep 2017 22:00:57 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Marat Khalili <mkh@rqc.ru>, Duncan <1i5t5.duncan@cox.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170912200057.3mrgtahlvszkg334@angband.pl>
References: <pan$556a1$a0a94487$f12a0554$4371a5e6@cox.net>
 <20170912103214.6dzjlugcr7q47x6g@angband.pl>
 <2a0186c7-7c56-2132-fa0d-da2129cde22c@rqc.ru>
 <CAGqmi776z5DzXZbXF=mS6wtUGk4YMhcWT9uJUXOFzwAd5KMU3g@mail.gmail.com>
 <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
 <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 12, 2017 at 03:11:52PM -0400, Austin S. Hemmelgarn wrote:
> On 2017-09-12 14:43, Adam Borowski wrote:
> > On Tue, Sep 12, 2017 at 01:36:48PM -0400, Austin S. Hemmelgarn wrote:
> > > On 2017-09-12 13:21, Adam Borowski wrote:
> > > > There's fallocate -d, but that for some reason touches mtime which makes
> > > > rsync go again.  This can be handled manually but is still not nice.
> > 
> > Yeah, the underlying ioctl does modify the file, it's merely fallocate -d
> > calling it on regions that are already zero.  The ioctl doesn't know that,
> > so fallocate would have to restore the mtime by itself.
> > 
> > There's also another problem: such a check + ioctl are racey.  Unlike defrag
> > or FILE_EXTENT_SAME, you can't thus use it on a file that's in use (or could
> > suddenly become in use).  Fixing this would need kernel support, either as
> > FILE_EXTENT_SAME with /dev/zero or as a new mode of fallocate.
> A new fallocate mode would be more likely.  Adding special code to the
> EXTENT_SAME ioctl and then requiring implementation on filesystems that
> don't otherwise support it is not likely to get anywhere.  A new fallocate
> mode though would be easy, especially considering that a naive
> implementation is easy

Sounds like a good idea.  If we go this way, there's a question about
interface: there's choice between:
A) check if the whole range is zero, if even a single bit is one, abort
B) dig many holes, with a given granulation (perhaps left to the
   filesystem's choice)
or even both.  The former is more consistent with FILE_EXTENT_SAME, the
latter can be smarter (like, digging a 4k hole is bad for fragmentation but
replacing a whole extent, no matter how small, is always a win).

> That said, I'm not 100% certain if it's necessary.  Intentionally calling
> fallocate on a file in use is not something most people are going to do
> normally anyway, since there is already a TOCTOU race in the fallocate -d
> implementation as things are right now.

_Current_ fallocate -d suffers from races, the whole gain from doing this
kernel-side would be eliminating those races.  Use cases about the same as
FILE_EXTENT_SAME: you don't need to stop the world.  Heck, as I mentioned
before, it conceptually _is_ FILE_EXTENT_SAME with /dev/null, other than
your (good) point about non-btrfs non-xfs.

> > For now, though, I wonder -- should we send fine folks at util-linux a patch
> > to make fallocate -d restore mtime, either always or on an option?
> It would need to be an option, because it also suffers from a TOCTOU race
> (other things might have changed the mtime while you were punching holes),
> and it breaks from existing behavior.  I think such an option would be
> useful, but not universally (for example, I don't care if the mtime on my VM
> images changes, as it typically matches the current date and time since the
> VM's are running constantly other than when doing maintenance like punching
> holes in the images).

Noted.  Both Marat's and my use cases, though, involve VMs that are off most
of the time, and at least for me, turned on only to test something. 
Touching mtime makes rsync run again, and it's freaking _slow_: worse than
40 minutes for a 40GB VM (source:SSD target:deduped HDD).


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
