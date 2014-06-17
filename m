Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:41360 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932135AbaFQR6y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 13:58:54 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: No more snapshot aware defrag ?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <1407090.0P4LdDZJ3g@zafu>
Date: Tue, 17 Jun 2014 11:58:52 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <5DD4C2CF-FD94-449F-AA92-21B6F27F50BC@colorremedies.com>
References: <1407090.0P4LdDZJ3g@zafu>
To: =?iso-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 17, 2014, at 11:27 AM, Swâmi Petaramesh <swami@petaramesh.org> wrote:

> Hi there,
> 
> Heck ! I discovered from the wiki
> 
> https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_defragment_many_files.3F
> 
> ...That defrag, which used to be snapshot-aware, isn't anymore :-/
> 
> ...And /me am still defraggging my snapshotted system on a regular basis :-(
> 
> Is there any plan to re-enable the snapshot-awareness of defrag anytime soon ?

Check the archive for "Snapshot aware defrag and qgroups thoughts" April 21st by Josef Bacik.

Chris Murphy