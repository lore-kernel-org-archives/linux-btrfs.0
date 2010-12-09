From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Permissions model for btrfs?
Date: Thu, 9 Dec 2010 13:02:33 -0500
Message-ID: <20101209180233.GA3153@flcl.lan>
References: <4D011367.70501@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Wayne Pollock <pollock@acm.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D011367.70501@acm.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 09, 2010 at 12:35:35PM -0500, Wayne Pollock wrote:
> I looked though the wiki (and "searched" the archives) but
> don't see an answer.  Will btrfs support old POSIX-style ACLs
> and permissions, or the new NFS/NT style ACLs like ZFS?  From
> the patch I saw, it seems old POSIX ACLs and permissions, but
> I'd like to know for sure.  (And maybe the FAQ on the wiki could
> address this?)  If it is the older POSIC ACLs, is there any plan
> to support NFSv4 ACLs in the future?

Right now it supports POSIX ACLs. I don't know about future plans.

> On a related note, will btrfs support any ext4 attributes (via chattr)?

It currently supports AaDdiS.
