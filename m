From: Mike Hommey <mh@glandium.org>
Subject: Re: btrfs and apt package manager in ubuntu
Date: Mon, 1 Nov 2010 09:10:59 +0100
Message-ID: <20101101081059.GA4014@glandium.org>
References: <1288531046.3486.2.camel@home>
 <1288542096.16108.34.camel@ceedasus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Christian <gmane.20.ceed@spamgourmet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288542096.16108.34.camel@ceedasus>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 31, 2010 at 11:21:36AM -0500, Christian wrote:
> On Sun, 2010-10-31 at 16:17 +0300, Abdullah Ansari wrote:
> > it's very slow in installtion with apt in ubuntu
> 
> I'm seeing the same thing. When installing using apt the disk grinds
> "forever" before the installation completes. I have two identical
> laptops running Linux Mint 10 (rc) with similar disk layout except that
> one has two btrfs partitions while the other only has ext4. The one with
> btrfs takes at least 10 times longer to install updates on than the ext4
> one.

That's because dpkg uses sync when unpacking each package.

Mike
