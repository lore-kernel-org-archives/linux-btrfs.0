Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60104 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751755AbaAIBms convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Jan 2014 20:42:48 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: REQ: btrfs list <subvols only> option
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140109T020430-693@post.gmane.org>
Date: Wed, 8 Jan 2014 18:42:45 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <38A0596B-F366-453C-ABC2-D4FB25637403@colorremedies.com>
References: <loom.20140109T020430-693@post.gmane.org>
To: Alex <alex@bpmit.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 8, 2014, at 6:31 PM, Alex <alex@bpmit.com> wrote:

> Hello 
> 
> (Using btrfs userland 3.12)
> 
> I have my fs set up (below) I borrowed the Ubuntu scheme.
> 
> <FS_TREE>/@/
> <FS_TREE>/@/etc
> <FS_TREE>/@/var
> ..
> 
> get-default is 5 i.e. <FS_TREE>
> 
> AFAICT, perhaps I'm missing the obvious, getting the list of subvolumes only
> (no snapshots) is no longer trivial? 
> 
> # btrfs  sub list /@
> ERROR: can't access '/@'
> # btrfs  sub list /@
> ERROR: can't access '/@'
> # btrfs  sub list /@/
> ERROR: can't access '/@/'
> # btrfs  sub list @/
> ERROR: can't access '@/'
> # btrfs  sub list @
> 
> I know I'm going to be embarrassed at the answer, but go ahead bite me!

Specify the mount point for the Btrfs file system and it will list all subvols on that file system.


Chris Murphy