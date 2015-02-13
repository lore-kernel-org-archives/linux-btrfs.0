Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbbBMRvF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 12:51:05 -0500
Date: Fri, 13 Feb 2015 18:51:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com,
        Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 23/24] Btrfs: sysfs: support seed devices in the sysfs
 layout
Message-ID: <20150213175102.GN8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-24-git-send-email-anand.jain@oracle.com>
 <20150211185259.GM28877@twin.jikos.cz>
 <54DC475C.4000002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54DC475C.4000002@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 02:25:32PM +0800, Anand Jain wrote:
> Since we are on this topic: btrfs-progs shouldn't have had this patch:
>     git log -p 2513077
> -------------------------
> commit 2513077f2f830b4bc83d528bfb6979eb461918bd
> Author: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Date:   Mon Oct 6 18:16:46 2014 +0800
> 
>      btrfs-progs: fix device missing of btrfs fi show with seed devices
> -------------------------
> 
> it doesn't work with nested seed as I commented
>    http://marc.info/?l=linux-btrfs&m=141102300324251&w=2
> -------------------------
>    btrfs fi show -d
> warning devid 1 not found already
> warning devid 2 not found already
> Check tree block failed, want=29425664, have=0
> read block failed check_tree_block
> Couldn't setup csum tree
> Check tree block failed, want=29360128, have=0
> read block failed check_tree_block
> -------------------------
> 
> I haven't see next version of this patch from Gui. (Gui ?, copied)

The fixed version was "[PATCH v2 3/3] btrfs-progs: fix device missing of
btrfs fi show with seed devices"

http://article.gmane.org/gmane.comp.file-systems.btrfs/39186/

and that's what I have merged.
