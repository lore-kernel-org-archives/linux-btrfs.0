Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53140 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbbLHQGh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 11:06:37 -0500
Date: Tue, 8 Dec 2015 08:06:15 -0800
From: Marc MERLIN <marc@merlins.org>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Scrub: no spae left on device
Message-ID: <20151208160615.GO27889@merlins.org>
References: <20151208150638.GL27889@merlins.org> <5666F947.5010902@googlemail.com> <5666FB58.2040900@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <5666FB58.2040900@bouton.name>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 08, 2015 at 04:46:32PM +0100, Lionel Bouton wrote:
> Le 08/12/2015 16:37, Holger Hoffstätte a écrit :
> > On 12/08/15 16:06, Marc MERLIN wrote:
> >> Howdy,
> >>
> >> Why would scrub need space and why would it cancel if there isn't enough of
> >> it?
> >> (kernel 4.3)
> >>
> >> /etc/cron.daily/btrfs-scrub:
> >> btrfs scrub start -Bd /dev/mapper/cryptroot
> >> scrub device /dev/mapper/cryptroot (id 1) done
> >> 	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
> >> 	total bytes scrubbed: 130.84GiB with 0 errors
> >> btrfs scrub start -Bd /dev/mapper/pool1
> >> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
> >> scrub device /dev/mapper/pool1 (id 1) canceled
> > Scrub rewrites metadata (apparently even in -r aka readonly mode), and that
> > can lead to temporary metadata expansion (stuff gets COWed around); it's
> > a bit surprising but makes sense if you think about it.
> 
> How long must I think about it until it makes sense? :-)
> 
> Sorry I'm not sure why metadata is rewritten if no error is detected.
> I've several theories but lack information: is the fact that no error
> has been detected stored somewhere? is scrub using some kind of internal
> temporary snapshot(s) to avoid interfering with other operations? other
> reason I didn't think about?

Yeah, I was also wondering why metadata should be rewritten on a single
device scrub.
Does not make sense to me.

And this is what I got:
legolas:~# btrfs balance start -musage=10 -v /mnt/btrfs_pool1/ 
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=10
  SYSTEM (flags 0x2): balancing, usage=10
ERROR: error during balancing '/mnt/btrfs_pool1/' - No space left on device
There may be more info in syslog - try dmesg | tail

Ok, that sucks.

legolas:~# btrfs balance start -musage=0 -v /mnt/btrfs_pool1/
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=0
  SYSTEM (flags 0x2): balancing, usage=0
Done, had to relocate 0 out of 618 chunks

This worked. Mmmh, I thought this wouldn't be necessary anymore in 4.3 kernels?

legolas:~# btrfs balance start -musage=10 -v /mnt/btrfs_pool1
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=10
  SYSTEM (flags 0x2): balancing, usage=10
Done, had to relocate 1 out of 618 chunks

And now I'm back in business...

Still, this is a bit disappointing and at the very least very unexpected in 4.3.

legolas:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=604.88GiB, used=520.09GiB
System, DUP: total=32.00MiB, used=96.00KiB
Metadata, DUP: total=5.00GiB, used=4.17GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
legolas:~# btrfs fi show /mnt/btrfs_pool1
Label: 'btrfs_pool1'  uuid: 5ee24229-2431-448a-868e-2c325d10bfa7
	Total devices 1 FS bytes used 524.26GiB
	devid    1 size 615.01GiB used 614.94GiB path /dev/mapper/pool1


Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
