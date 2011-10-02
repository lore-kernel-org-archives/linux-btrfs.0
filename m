From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: recursive subvolume delete
Date: Sun, 2 Oct 2011 22:33:41 +0100
Message-ID: <20111002213341.GA4569@yahoo.fr>
References: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: "krzf83@gmail.com " <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=7HGupXFP1ma-rTyFnxvtCge2Ajipg1wLmGhZTAuDKrg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-10-02 16:38:21 +0200, krzf83@gmail.com :
> Also I think there are no real tools to find out which
> directories are subvolumes/snapshots
[...]

On my system (debian), there's "mountpoint" command (from the
initscript package from
http://savannah.nongnu.org/projects/sysvinit) that will tell you
that (it compares the st_dev of the given directory with that of
directory/..).

-- 
Stephane
