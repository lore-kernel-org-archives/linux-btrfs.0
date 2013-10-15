Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57034 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396Ab3JORWi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 13:22:38 -0400
Date: Tue, 15 Oct 2013 19:22:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/3 v2] btrfs-progs: add more parameter to the filesystem
 show
Message-ID: <20131015172236.GN5787@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com>
 <1381203700-17558-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381203700-17558-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 11:41:39AM +0800, Anand Jain wrote:
> for mounted btrfs filesystem this patch proposes to add
> mount point and group profile to the filesystem show output.
> this helps user to quickly understand short details of the
> btrfs filesystem quickly.
> 
> end user using this new btrfs fi show would surely notice this
> will reduce other commands normally used following the current
> btrfs fi show command. (like mount and btrfs fi df). of course
> user should use fi df to know detailed info about the sizes.
> 
> preview as below..
> 
> Label: none  uuid: 26d539a5-8968-4cf0-b4b5-5fd50105f8a0 mounted: /btrfs
> 	Group profile: Metadata: single  Metadata: DUP  Data: single

It would look better if the profile types are grouped together,
otherwise it can drift to the right quite far. Why is
Sytem not listed here?

The 'fi show' command is kind of high-level overview, so I'm kind of ok
to print the group profiles here.

david
