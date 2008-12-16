From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs trees for linux-next
Date: Mon, 15 Dec 2008 20:37:27 -0500
Message-ID: <1229391447.27573.6.camel@think.oraclecorp.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Andreas Dilger <adilger@sun.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-15 at 23:55 +0100, Kay Sievers wrote:
> On Mon, Dec 15, 2008 at 22:03, Andreas Dilger <adilger@sun.com> wrote:
> > On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
> >> The multi-device code uses a very simple brute force scan from userland
> >> to populate the list of devices that belong to a given FS.  Kay Sievers
> >> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
> >> required for single device filesystems).
> >
> > This should use libblkid to do the scanning of the devices, and it can
> > cache the results for efficiency.  Best would be to have the same LABEL+UUID
> > for all devices in the same filesystem, and then once any of these devices
> > are found the mount.btrfs code can query the rest of the devices to find
> > the remaining parts of the filesystem.
> 
> Which is another way to do something you should not do that way in the
> first place, just with a library instead of your own code.
> 

Well, its the same library everyone else is using to do things they
shouldn't be doing ;)

I'm very interested in your new  scheme for device discovery.  It seems
like the best and most reasonable way to go forward.

But, tossing things into libblkid also makes sense.  It isn't much work,
and it allows btrfs to fit in with the established norms while we
experiment with new and better ways to hook it all together.

-chris


