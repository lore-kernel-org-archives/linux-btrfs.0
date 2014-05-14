Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56224 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbaENQBf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 12:01:35 -0400
Date: Wed, 14 May 2014 18:01:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jshubin@redhat.com
Subject: Re: [PATCH V2] mkfs.btrfs: allow UUID specification at mkfs time
Message-ID: <20140514160133.GN6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5372C457.3000706@redhat.com>
 <53738D29.7020405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53738D29.7020405@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for adding the uuid uniqueness check, that was my major
objection for previous patch iterations,

http://www.spinics.net/lists/linux-btrfs/msg30572.html

we can now use it for convert as well (to generate or copy the uuid).

On Wed, May 14, 2014 at 10:35:05AM -0500, Eric Sandeen wrote:
> @@ -125,7 +154,19 @@ int make_btrfs(int fd, const char *device, const char *label,
>  	memset(&super, 0, sizeof(super));
>  
>  	num_bytes = (num_bytes / sectorsize) * sectorsize;
> -	uuid_generate(super.fsid);
> +	if (fs_uuid) {
> +		if (uuid_parse(fs_uuid, super.fsid) != 0) {
> +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
> +			ret = -EINVAL;
> +			goto out;

I think the uuid validity check comes too late, IMHO it should be done
after the while/getopt block outside of make_btrfs. At this point eg.
the discard or device zeroing is already done.

I would not mind to keep the check here as well as a last sanity check,
though the number of mkfs_btrfs callers is 1 and the function is not
exported to the library.

> +		}
> +		if (!test_uuid_unique(fs_uuid)) {
> +			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +	} else
> +		uuid_generate(super.fsid);
>  	uuid_generate(super.dev_item.uuid);
>  	uuid_generate(chunk_tree_uuid);
