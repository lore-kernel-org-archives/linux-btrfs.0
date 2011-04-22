From: CACook@quantum-sci.com
Subject: Re: How Snapshots Inter-relate?
Date: Fri, 22 Apr 2011 08:03:20 -0700
Message-ID: <201104220803.20552.CACook@quantum-sci.com>
References: <201104211017.52341.CACook@quantum-sci.com> <1303411647.25281.2.camel@ayu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1303411647.25281.2.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 21 April, 2011 11:47:25 Calvin Walton wrote:
> You have nothing to worry about. You can delete any snapshot on btrfs
> without losing data from any other snapshot. Each snapshot is completely
> independent.
> 
> This works because data which is shared between multiple snapshots is
> reference counted, and won't be deleted until you remove the last
> snapshot that references that data.

Wow.  Awesome job, BTRFS team.

Would it be good practice to say, once a year, do a completely new fresh snapshot?

