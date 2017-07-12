Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbdGLWRy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Jul 2017 18:17:54 -0400
Date: Thu, 13 Jul 2017 00:16:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: fix the path use full_path as provided by
 the root info
Message-ID: <20170712221640.GO2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170712072027.2459-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170712072027.2459-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 12, 2017 at 03:20:27PM +0800, Anand Jain wrote:
> This is a kind of preparatory patch for the patch which will add
> --rootid and --uuid options for the btrfs subvol show command.
> 
> As of now btrfs subvol show is using the external user provided subvol
> path to show in the output. Which is kind of confusing.
> 
> btrfs su show /btrfs
> /btrfs <--
> 	Name: 			<FS_TREE>
> 
> It will be even more confusing when proposed --uuid or --rootid
> options are used.
> 
> btrfs su show --rootid 258 /btrfs
> /btrfs <--
> 	Name: 			snap <--
> 	UUID: 			9630a45f-e647-4242-bd19-97590b4e20b2
> 	Parent UUID: 		30129358-c69d-3e4a-a662-29509cc69c95
> 	Received UUID: 		-
> 	Creation time: 		2017-07-12 12:43:28 +0800
> 	Subvolume ID: 		258
> 	Generation: 		9
> 	Gen at creation: 	9
> 	Parent ID: 		257
> 	Top level ID: 		257
> 	Flags: 			-
> 	Snapshot(s):
> 
> Now with this patch, it will only show what is provided by the root_info.
> 
> btrfs su show --rootid 258 /btrfs
> sv1/snap <--
> 	Name: 			snap
> 	UUID: 			9630a45f-e647-4242-bd19-97590b4e20b2
> 	Parent UUID: 		30129358-c69d-3e4a-a662-29509cc69c95
> 	Received UUID: 		-
> 	Creation time: 		2017-07-12 12:43:28 +0800
> 	Subvolume ID: 		258
> 	Generation: 		9
> 	Gen at creation: 	9
> 	Parent ID: 		257
> 	Top level ID: 		257
> 	Flags: 			-
> 	Snapshot(s):
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
