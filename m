Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:50874 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752938AbbAESwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 13:52:39 -0500
Message-ID: <54AADDF5.20205@inwind.it>
Date: Mon, 05 Jan 2015 19:54:45 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_IOC_TREE_SEARCH ioctl
References: <20150105171512.GA19126@gardel-login>
In-Reply-To: <20150105171512.GA19126@gardel-login>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-01-05 18:15, Lennart Poettering wrote:
> Heya,
> 
> I recently added some btrfs magic to systemd's machinectl/nspawn
> tool. More specifically it can now show the disk usage of a container
> that is stored in a btrfs subvolume. For that I made use of the btrfs
> quota logic. To read the current disk usage of a subvolume I took
> inspiration from btrfs-progs, most specifically the
> BTRFS_IOC_TREE_SEARCH ioctl(). Unfortunately, documentation for the
> ioctl seems to to be lacking, but there are some things about it I
> fail to grok:
> 
> What precisely are the semantics of the ioctl, regarding the search
> key min/max values (the fields of "struct btrfs_ioctl_search_key")? I
> kinda assumed that setting them would result in in only objects to be
> returned that are within the min/max ranges. However, that appears not
> to be the case. At least the min_offset/max_offset setting appears to
> be ignored?
> 
> The code I hacked up is this one:
> 
> http://cgit.freedesktop.org/systemd/systemd/tree/src/shared/btrfs-util.c#n427
> 
> I try to read the BTRFS_QGROUP_STATUS_KEY and BTRFS_QGROUP_LIMIT_KEY
> objects for the subvolume I care about. Hence I initialize .min_type
> and .max_type to the two types (in the right order), and then
> .min_offset and .max_offset to subvolume id. However, the search ioctl
> will still give me entries back with offsets != the subvolume id...
> 
> Is this intended behaviour of the search ioctl? If so, what's the
> rationale?

The search is done linearity; the min_* are the starting point, and
the max_* are the ending point; in the past someone gave me this example: 
if you think in two dimensions, the scan is *not* performed in a rectangular region but in a horizontal area...

My ascii art: this is what you are expecting:

	............
	..XXXXXXXX..
	..XXXXXXXX..
	..XXXXXXXX..
	............


this is what BTRFS_IOC_TREE_SEARCH returns:

	............
	..XXXXXXXXXX
	XXXXXXXXXXXX
	XXXXXXXXXX..
	............


> 
> My code currently invokes the search ioctl in a loop to work around
> the fact that .min_offset/.max_offset don't work as I wish they
> did... 

On the best of my (limited) btrfs knowledge, your "workaround"
is needed due to the ioctl behavior.

> I wish I could get rid of this loop and filtering out of the
> entries I get back that aren't in th range I specified...

See this thread [1] for what happened to me long time ago

> 
> Lennart

Goffreo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

[1] http://www.spinics.net/lists/linux-btrfs/msg07641.html
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
