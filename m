Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523AbaLEQlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 11:41:45 -0500
Date: Fri, 5 Dec 2014 17:41:44 +0100
From: David Sterba <dsterba@suse.cz>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: Chris Mason <clm@fb.com>, cwillu <cwillu@cwillu.com>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Zygo Blaxell <zblaxell@furryterror.org>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
Message-ID: <20141205164144.GK9754@suse.cz>
Reply-To: dsterba@suse.cz
References: <547B5724.1060507@libero.it>
 <CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
 <CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
 <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
 <1417793566.21214.11@mail.thefacebook.com>
 <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANBHLUgkY5YkFqe48H=vsS4w2uZr+nU0NBhy8o88A=vv3-nHkQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 05, 2014 at 04:01:37PM +0000, Dimitri John Ledkov wrote:
> On 5 December 2014 at 15:32, Chris Mason <clm@fb.com> wrote:
> > On Sun, Nov 30, 2014 at 5:57 PM, Dimitri John Ledkov <xnox@debian.org>
> > wrote:
> >>
> >> On 30 November 2014 at 22:31, cwillu <cwillu@cwillu.com> wrote:
> >>>
> >>>
> >>>  In ubuntu, the initfs runs a btrfs dev scan, which should catch
> >>>  anything that would be missed there.
> >>>
> >>
> >> I'm sorry, udev rule(s) is not sufficient in the initramfs-less case,
> >> as outlined.
> >>
> >> In case of booting with initramfs, indeed, both Debian & Ubuntu
> >> include snippets there to run btrfs scan.
> >
> >
> > In an initramfs-less system, the root filesystem mount is done by the
> > kernel, without calling any mount.btrfs.  The mount helper has all the same
> > problems that calling btrfs dev scan does, it's just being run by mount.
> >
> 
> Sure. in my initramfs-less system case the root filesystem was not
> btrfs. Simply there was a btrfs filesystem defined in /etc/fstab.

So you could add a 'btrfs dev scan' before the fstab is going to be
mounted. Either a local boot script or via some unit file. We're looking
for good reasons to justify the existence of the helper, but this is
still not enough IMHO. I can see the convenience to do it automatically,
but this assumes no udev available which is probably rare these days.
