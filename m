Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:32636 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754937Ab3JXWvK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 18:51:10 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Why cannot I move a read-only snapshot around?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131024224608.GA14904@kipc2.localdomain>
Date: Thu, 24 Oct 2013 16:51:06 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <AD5E9D64-6AED-48E2-8635-4B599F58F3A8@colorremedies.com>
References: <20131024152955.GA6110@kipc2.localdomain> <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com> <20131024215715.GA14128@kipc2.localdomain> <97FC1966-5DC7-488F-8A6C-C8C8B2EB8490@colorremedies.com> <20131024224608.GA14904@kipc2.localdomain>
To: Karl Kiniger <karl.kiniger@med.ge.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 24, 2013, at 4:46 PM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:

> On Thu 131024, Chris Murphy wrote:
>> dr--------. 1 chris chris   0 Oct 24 16:15 donotmove
>> 
>> [chris@f20s ~]$ mv donotmove/ Videos/
>> mv: cannot move ‘donotmove/’ to ‘Videos/donotmove’: Permission denied'
>> 
>> I own that directory. But because it's read only, I can't move it because moving it changes it. Of course if I become root, that overrides posix permissions, but the readonly status of a subvolume isn't like posix permissions and I see now reason why root should be able to modify it. And moving it does modify it.
> 
> tries this all as root.
> 
> drwxr-xr-x. 1 root root 734 Oct 24 16:41 @20131024  (this is a r/o snap)
> 
> It looks to me similar to a read-only mounted filesystem:
> 
> pc2:/u2/F19/@20131024# touch foo
> touch: cannot touch ‘foo’: Read-only file system
> 
> In what way would a r/o snapshot be modified because of moving its
> "mount point" ? No one is ever doing something inside.

For the same reason I can't move or rename a read only directory even though I'm not doing something inside.



Chris Murphy