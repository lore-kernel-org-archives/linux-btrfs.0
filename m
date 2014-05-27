Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1025 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121AbaE0RGM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 May 2014 13:06:12 -0400
Message-ID: <5384C68C.507@fb.com>
Date: Tue, 27 May 2014 13:08:28 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v4] btrfs: allocate raid type kobjects dynamically
References: <5384C48D.7040707@suse.com>
In-Reply-To: <5384C48D.7040707@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2014 12:59 PM, Jeff Mahoney wrote:
> We are currently allocating space_info objects in an array when we
> allocate space_info. When a user does something like:
> 
> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /mnt
> # btrfs balance start -mconvert=single -dconvert=single /mnt -f
> # btrfs balance start -mconvert=raid1 -dconvert=raid1 /
> 
> We can end up with memory corruption since the kobject hasn't
> been reinitialized properly and the name pointer was left set.
> 
> The rationale behind allocating them statically was to avoid
> creating a separate kobject container that just contained the
> raid type. It used the index in the array to determine the index.
> 
> Ultimately, though, this wastes more memory than it saves in all
> but the most complex scenarios and introduces kobject lifetime
> questions.
> 
> This patch allocates the kobjects dynamically instead. Note that
> we also remove the kobject_get/put of the parent kobject since
> kobject_add and kobject_del do that internally.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>

Lets see how smart patchwork is:

Reported-by:David Sterba <dsterba@suse.cz>

-chris
