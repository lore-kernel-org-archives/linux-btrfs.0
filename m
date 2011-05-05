From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Thu, 5 May 2011 15:33:07 -0700
Message-ID: <201105051533.07880.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105051440.07434.CACook@quantum-sci.com> <BANLkTi=qRCM3Rt5oBkCfxi4af2GYeHWJGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=qRCM3Rt5oBkCfxi4af2GYeHWJGg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 5 May, 2011 14:48:49 cwillu wrote:
> How old was the filesystem?  It might just have been lingering
> problems from an older kernel, which would be cleared up entirely by
> the balance you just ran.

I specifically set up the filesystem with the Live CD of the M- release of Ubuntu, so as to be using a much newer kernel than Debian's.  This was in December.  Then I used the Debian net install CD in Expert mode to install the OS.

I took all pains to be using the newest OS available to set up the disks, so as to take advantage of WD's Advanced Format, and the newest improvements to BTRFS.  But the balance is still going after more than an hour.

I am seeing drastically conflicting info from df and btrfs filesystem df, which is inexplicable.

