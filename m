Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54139 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaEORjm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 13:39:42 -0400
Date: Thu, 15 May 2014 19:39:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: kreijack@inwind.it, linux-btrfs <linux-btrfs@vger.kernel.org>,
        jshubin@redhat.com
Subject: Re: PATCH V3] mkfs.btrfs: allow UUID specification at mkfs time
Message-ID: <20140515173940.GS6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5372C457.3000706@redhat.com>
 <53738D29.7020405@redhat.com>
 <5373AA3B.5000100@redhat.com>
 <5373E864.4040807@libero.it>
 <5373E908.4040800@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5373E908.4040800@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 05:07:04PM -0500, Eric Sandeen wrote:
> >> @@ -125,7 +154,20 @@ int make_btrfs(int fd, const char *device, const char *label,
> >>  	memset(&super, 0, sizeof(super));
> >>  
> >>  	num_bytes = (num_bytes / sectorsize) * sectorsize;
> >> -	uuid_generate(super.fsid);
> >> +	if (fs_uuid) {
> >> +		if (uuid_parse(fs_uuid, super.fsid) != 0) {
> >> +			fprintf(stderr, "could not parse UUID: %s\n", fs_uuid);
> >> +			ret = -EINVAL;
> >> +			goto out;
> >> +		}
> >> +		if (!test_uuid_unique(fs_uuid)) {
> >> +			fprintf(stderr, "non-unique UUID: %s\n", fs_uuid);
> >> +			ret = -EBUSY;
> >> +			goto out;
> >> +		}
> > 
> > Why a second call to test_uuid_unique(fs_uuid) ?
> 
> Because kdave said he thought it was worth being paranoid in an earlier email,
> if I understood him correctly.

I'm thinking about it again. My original idea was not to easily allow
to create a duplicate uuid to a regular user. But, if one uses --uuid
already, that's something I can count as a willful action and any
mistakes can be blamed on the user.

If we end up with a warning, then the documentation should say how
spectacularly it can blow up the system.
