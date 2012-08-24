Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44896 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab2HXOKw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 10:10:52 -0400
Date: Fri, 24 Aug 2012 16:10:49 +0200
From: David Sterba <dave@jikos.cz>
To: Not Zippy <notzippy@gmail.com>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: Computer crash, btrfs partition errors
Message-ID: <20120824141049.GZ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CANDob0+VQ0UJJaDS89CGK5YNXys40SWgWMgeTjeZoca4teVEUw@mail.gmail.com>
 <CANDob0+XEHbYmp2PF-UW1EXRP6YbKw3Fn00th8u9A2R7XdCrJg@mail.gmail.com>
 <20120821160019.GN17430@twin.jikos.cz>
 <CANDob0LpwsWP=jcyMkxZor0_6AnFeHY6zt-Sp6V0HH+Pd2SH=w@mail.gmail.com>
 <20120822143705.GR17430@twin.jikos.cz>
 <CANDob0J40BuLhJ2g0Et+-Gq0Nu6V=QkgLfTPGRT5rQUQpBRQaA@mail.gmail.com>
 <CANDob0+b2nPF7eRQ6wuQ0SwyuO2NDvfUM_R1-bbVRZ1FiHX0pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANDob0+b2nPF7eRQ6wuQ0SwyuO2NDvfUM_R1-bbVRZ1FiHX0pQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 22, 2012 at 10:19:13AM -0700, Not Zippy wrote:
> The full output of the btrfs-debug-tree is 190MB compressed, did you
> want it still ?

That's not the biggest one I've received :) (2.5G xz compressed) Please
note that it contains filenames, so you may want to filter them out
with

sed -e 's/\(.* name: \).*/\1FILENAME/'

(though sometimes the filename can be useful to give further hints).

> As far as the conditions, I was running a repo sync which I had
> CTRL-Z, I then got distracted and mistakenly started the sync again
> (not sure if you are familiar with repo command, it spawns git
> processes to checkout project). The crash did not occur immediately
> but it was probably within 2 minutes of me starting this second repo
> sync. The lock up was bad enough that BUSIER did not reboot the PC, I
> had to power down.

Thanks. Does not seem to be doing anything special and uncommon. The
hard power off could have caught the filesystem in some intermediate
state (ie. a bug to resolve, this should not happen) or the disk wrote
bad data. smartctl may show if there are hard erros on the disk.

> After the patch to btrfsck, I got this error:
> 
> # ./work/builds/btrfs-progs/btrfsck --repair /dev/sda2
[...]

I'm afraid that the corrupted block confuses fsck too much.

david
