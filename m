Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbbBKTBC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 14:01:02 -0500
Date: Wed, 11 Feb 2015 20:01:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [PATCH 00/24 V2] provide frame work so that sysfs attributs from
 the fs_devices can be added
Message-ID: <20150211190101.GN28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 07:56:01AM +0800, Anand Jain wrote:
> This patch set will provide a framework and help to create attributes
> from the structure btrfs_fs_devices which are available even before
> fs_info is created. So by moving the parent kobject super_kobj from
> fs_info to btrfs_fs_devices, it will help to create attributes
> from the btrfs_fs_devices as well.
>     
> Just to note, this does not change any of the existing btrfs sysfs
> external kobject names and its attributes and not even the life
> cycle of them. Changes are internal only. And to ensure the same,
> this path has been tested with various device operations and,
> checking and comparing the sysfs kobjects and attributes with
> sysfs kobject and attributes with out this patch, and they remain
> same. These test cases are added to the progs as test-btrfs-devmgt.sh,
> its patch is below as well.

I went through the patchset, looks ok to me in general. The only concern
is about the new seeding representation, but the other changes seem ok
(but I did not do in-depth review).

I like the patch separation, that really helps to understand the changes
although there are 20+ patches in total.

We can merge patches 1-22, patch 23 should be folded into 24 as it fixes
a bug introduced there.
