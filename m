Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og116.obsmtp.com ([64.18.0.147]:52155 "EHLO
	exprod5og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129Ab3JXWpf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 18:45:35 -0400
Date: Fri, 25 Oct 2013 00:46:08 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Why cannot I move a read-only snapshot around?
Message-ID: <20131024224608.GA14904@kipc2.localdomain>
References: <20131024152955.GA6110@kipc2.localdomain>
 <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com>
 <20131024215715.GA14128@kipc2.localdomain>
 <97FC1966-5DC7-488F-8A6C-C8C8B2EB8490@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <97FC1966-5DC7-488F-8A6C-C8C8B2EB8490@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 131024, Chris Murphy wrote:
> dr--------. 1 chris chris   0 Oct 24 16:15 donotmove
> 
> [chris@f20s ~]$ mv donotmove/ Videos/
> mv: cannot move ‘donotmove/’ to ‘Videos/donotmove’: Permission denied'
> 
> I own that directory. But because it's read only, I can't move it because moving it changes it. Of course if I become root, that overrides posix permissions, but the readonly status of a subvolume isn't like posix permissions and I see now reason why root should be able to modify it. And moving it does modify it.

tries this all as root.

drwxr-xr-x. 1 root root 734 Oct 24 16:41 @20131024  (this is a r/o snap)

It looks to me similar to a read-only mounted filesystem:

pc2:/u2/F19/@20131024# touch foo
touch: cannot touch ‘foo’: Read-only file system

In what way would a r/o snapshot be modified because of moving its
"mount point" ? No one is ever doing something inside.

Karl

> Chris Murphy

