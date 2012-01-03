From: cwillu <cwillu@cwillu.com>
Subject: Re: ENOSPC on file deletion with 3.1.6
Date: Tue, 3 Jan 2012 08:44:11 -0600
Message-ID: <CAE5mzvjR71sCt3SE7HxHn4GjZvFij944QpVMQv3bO3aV2-jwtA@mail.gmail.com>
References: <24549767.TiRljH7Edl@a4>
	<20120103140643.GA18405@attic.humilis.net>
	<3462742.4OipIWmN91@a4>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Arie Peterson <ariep@xs4all.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3462742.4OipIWmN91@a4>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 3, 2012 at 8:12 AM, Arie Peterson <ariep@xs4all.nl> wrote:
> On Tuesday 03 January 2012 15:06:43 Sander wrote:
>
>> Maybe your snapshots take up space. Can you show 'btrfs filesystem df /' ?
>
> Data, RAID1: total=22.72GB, used=14.73GB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=12.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=2.25GB, used=1.88GB
> Metadata: total=8.00MB, used=0.00
>
>> FWIW, I also had a disk full just a few days ago. Removed all snapshots
>> and some big files, but to no avail. Likely the background cleanup took
>> too much time. A reboot fixed this.
>
> OK, I'll keep this in mind. I'm a bit anxious to reboot, because I'm afraid
> booting will fail if the root file system cannot be written to.

I'd probably run a "btrfs fi balance /", it should be able to recover
the space.  I'd typically be a little anxious if it was a large
filesystem as it's not interruptable except via power-button (in
principle it shouldn't matter, but...), but given that your filesystem
is quite small, it shouldn't take more than an hour or so.
