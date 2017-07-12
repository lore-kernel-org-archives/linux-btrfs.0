Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44077 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750805AbdGLXFG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 19:05:06 -0400
Date: Thu, 13 Jul 2017 01:03:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH V2] btrfs-progs: add support to search subvolume by
 rootid and uuid
Message-ID: <20170712230352.GV2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712072050.2531-1-anand.jain@oracle.com>
 <20170712224711.5771-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712224711.5771-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 06:47:11AM +0800, Anand Jain wrote:
> Unless the top level is mounted there is no way to know the
> details of all the subvolume.  For example:
> 
> mount -o subvol=sv1/newsv1 /dev/sdb /btrfs
> 
> btrfs su list /btrfs
> ID 257 gen 12 top level 5 path sv1
> ID 258 gen 9 top level 257 path sv1/snap
> ID 259 gen 11 top level 257 path sv1/newsv1
> 
> You can't subvol show for sv1 and sv1/snap as its paths aren't
> accessible to the user unless the its top level is mounted.
> 
> This patch adds two new options to the existing btrfs subvol show
> cli. They are --rootid/-r or --uuid/-u, with this now the user will
> be able to look for a subvolume using the rootid OR the uuid.
> 
> ./btrfs su show -r 257 /btrfs
> sv1
> 	Name: 			sv1
> 	UUID: 			30129358-c69d-3e4a-a662-29509cc69c95
> 	Parent UUID: 		-
> 	Received UUID: 		-
> 	Creation time: 		2017-07-11 20:32:57 +0800
> 	Subvolume ID: 		257
> 	Generation: 		12
> 	Gen at creation: 	7
> 	Parent ID: 		5
> 	Top level ID: 		5
> 	Flags: 			-
> 	Snapshot(s):
> 				sv1/snap
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: Check if both -u and -r are set by the user and fail if so.

Applied, thanks. I did some minor updates to the help text.
