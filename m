Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51094 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2KZC5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 21:57:10 -0500
Date: Mon, 26 Nov 2012 10:54:47 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Arendt <admin@prnet.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
Message-ID: <20121126025439.GA5923@liubo>
Reply-To: bo.li.liu@oracle.com
References: <50AFB620.6040707@prnet.org>
 <2925363.jTFvA7mLni@vfr>
 <50AFE5FC.7040304@prnet.org>
 <20121124033910.GA5680@gmail.com>
 <50B27C4A.7040702@prnet.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50B27C4A.7040702@prnet.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 25, 2012 at 09:15:06PM +0100, David Arendt wrote:
> Hi,
> 
> I have made some more tests:
> 
> ./testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing attribute system.posix_acl_default
> lgetxattr failed: No data available
> 
> getfattr /u00/root.20121121.210102.full/var/lib/nfs/sm
> (no result)
> 
> setfattr -x system.posix_acl_default
> /u00/root.20121121.210102.full/var/lib/nfs/sm
> 
> testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing attribute system.posix_acl_access
> 
> setfattr -x system.posix_acl_access
> /u00/root.20121121.210102.full/var/lib/nfs/sm
> 
> ./testxattr /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
> 
> Now a test with a manually set attribute:
> 
> setfattr -n user.testattribute -v testvalue
> /u00/root.20121121.210102.full/var/lib/nfs/sm
> 
> getfattr /u00/root.20121121.210102.full/var/lib/nfs/sm
> getfattr: Removing leading '/' from absolute path names
> # file: u00/root.20121121.210102.full/var/lib/nfs/sm
> user.testattribute
> 
> ./testxattr /u00/root.20121121.210102.full/var/lib/nfs/smprocessing file
> /u00/root.20121121.210102.full/var/lib/nfs/sm
> processing attribute user.testattribute
> value testvalue

So another manually set attribute proves the code is right, that means
the previous weird case is likely due to xattr metadata corruption somehow,
it maybe name hash mismatch, or the xattr name len mismatch.

thanks,
liubo

> 
> Thanks in advance,
> David Arendt
> 
> On 11/24/12 04:39, Liu Bo wrote:
> > On Fri, Nov 23, 2012 at 10:09:16PM +0100, David Arendt wrote:
> >> Well, this is only code to demonstrate the problem, the ; is normally a
> >> silly mistake, but for my test case valuelen is < 0 so, the ; doesn't
> >> change anything. With this corrected, the problem stays the same.
> >>
> >> On 11/23/12 21:43, Garry T. Williams wrote:
> >>> On Friday, November 23, 2012 18:45:04 David Arendt wrote:
> >>>>   for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
> >>>>   {
> >>>>     printf("processing attribute %s\n", &attrs[i]);
> >>>>
> >>>>     valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);
> >>>>
> >>>>     if (valuelen < 0);
> >>>   Hmmm ----------------^
> > Hi David,
> >
> > Any dmesg output for this?
> >
> > thanks,
> > liubo
> >
> >>>
> >>>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
