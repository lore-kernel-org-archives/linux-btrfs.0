Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36283 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964983AbeCHGGV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 Mar 2018 01:06:21 -0500
Date: Wed, 7 Mar 2018 22:06:12 -0800
From: Marc MERLIN <marc@merlins.org>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Andrei Borzenkov <arvidjaar@gmail.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, fdmanana@gmail.com
Message-ID: <20180308060612.n655pfxsfh2ehrsf@merlins.org>
References: <20180305161619.prnkl4q4zcyibzhc@merlins.org>
 <32dcf3b9-e810-dc14-1a0b-005f9c49df0a@gmail.com>
 <20180305194718.GC613@merlins.org>
 <b323d987-9d97-f57e-b0d6-4ff405abf91c@mendix.com>
 <20180306200247.svrsko5zr5vldaes@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180306200247.svrsko5zr5vldaes@merlins.org>
Subject: Re: How to change/fix 'Received UUID'
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 06, 2018 at 12:02:47PM -0800, Marc MERLIN wrote:
> > https://github.com/knorrie/python-btrfs/commit/1ace623f95300ecf581b1182780fd6432a46b24d
> 
> Well, I had never heard about it until now, thank you.
> 
> I'll see if I can make it work when I get a bit of time.

Sorry, I missed the fact that there was no code to write at all.
gargamel:/var/local/src/python-btrfs/examples# ./set_received_uuid.py 2afc7a5e-107f-d54b-8929-197b80b70828 31337 1234.5678 /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41
Current subvolume information:
  subvol_id: 94887
  received_uuid: 00000000-0000-0000-0000-000000000000
  stime: 0.0 (1970-01-01T00:00:00)
  stransid: 0  
  rtime: 0.0 (1970-01-01T00:00:00)
  rtransid: 0  

Setting received subvolume...

Resulting subvolume information:
  subvol_id: 94887
  received_uuid: 2afc7a5e-107f-d54b-8929-197b80b70828
  stime: 1234.5678 (1970-01-01T00:20:34.567800)
  stransid: 31337
  rtime: 1520488877.415709329 (2018-03-08T06:01:17.415709)
  rtransid: 255755

gargamel:/var/local/src/python-btrfs/examples# btrfs property set -ts /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41 ro true


ABORT: btrfs send -p /mnt/btrfs_pool1/Video_ro.20180205_21:05:15 Video_ro.20180307_22:03:03 |  btrfs receive /mnt/btrfs_bigbackup/DS1//. failed
At subvol Video_ro.20180307_22:03:03
At snapshot Video_ro.20180307_22:03:03
ERROR: cannot find parent subvolume

gargamel:/mnt/btrfs_pool1# btrfs subvolume show /mnt/btrfs_pool1/Video_ro.20180220_21\:03\:41/
Video_ro.20180220_21:03:41
        Name:                   Video_ro.20180220_21:03:41
        UUID:                   2afc7a5e-107f-d54b-8929-197b80b70828
        Parent UUID:            e5ec5c1e-6b49-084e-8820-5a8cfaa1b089
        Received UUID:          0e220a4f-6426-4745-8399-0da0084f8b23
        Creation time:          2018-02-20 21:03:42 -0800
        Subvolume ID:           11228
        Generation:             4174
        Gen at creation:        4150
        Parent ID:              5
        Top level ID:           5
        Flags:                  readonly
        Snapshot(s):
                                Video_rw.20180220_21:03:41
                                Video


Wasn't I supposed to set 2afc7a5e-107f-d54b-8929-197b80b70828 onto the destination?

Doesn't that look ok now? Is there something else I'm missing?
gargamel:/mnt/btrfs_pool1# btrfs subvolume show /mnt/btrfs_bigbackup/DS1/Video_ro.20180220_21:03:41
DS1/Video_ro.20180220_21:03:41
        Name:                   Video_ro.20180220_21:03:41
        UUID:                   cb4f343c-5e79-7f49-adf0-7ce0b29f23b3
        Parent UUID:            0e220a4f-6426-4745-8399-0da0084f8b23
        Received UUID:          2afc7a5e-107f-d54b-8929-197b80b70828
        Creation time:          2018-02-20 21:13:36 -0800
        Subvolume ID:           94887
        Generation:             250689
        Gen at creation:        250689
        Parent ID:              89160
        Top level ID:           89160
        Flags:                  readonly
        Snapshot(s):

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
