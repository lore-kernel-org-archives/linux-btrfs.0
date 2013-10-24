Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:54461 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3JXXNT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Oct 2013 19:13:19 -0400
Date: Fri, 25 Oct 2013 01:13:49 +0200
From: Karl Kiniger <karl.kiniger@med.ge.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Why cannot I move a read-only snapshot around?
Message-ID: <20131024231349.GA15363@kipc2.localdomain>
References: <20131024152955.GA6110@kipc2.localdomain>
 <1D7328F7-EB4F-4C3F-8EAB-2EDB6331F77E@colorremedies.com>
 <20131024215715.GA14128@kipc2.localdomain>
 <97FC1966-5DC7-488F-8A6C-C8C8B2EB8490@colorremedies.com>
 <20131024224608.GA14904@kipc2.localdomain>
 <AD5E9D64-6AED-48E2-8635-4B599F58F3A8@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AD5E9D64-6AED-48E2-8635-4B599F58F3A8@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 131024, Chris Murphy wrote:
> 
> On Oct 24, 2013, at 4:46 PM, Karl Kiniger <karl.kiniger@med.ge.com> wrote:
 > In what way would a r/o snapshot be modified because of moving its
> > "mount point" ? No one is ever doing something inside.
> 
> For the same reason I can't move or rename a read only directory even though I'm not doing something inside.

I see now: the .. entry would change if the directory were being moved.

Still hoping there is a better way on btrfs than sending and receiving the snaps
just to a different folder.

Karl

> 
> Chris Murphy
