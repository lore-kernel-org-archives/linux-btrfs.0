From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: Re: [PATCH] btrfs: prevent heap corruption in
 btrfs_ioctl_space_info()
Date: Wed, 09 Feb 2011 11:45:24 -0500
Message-ID: <1297269924.11434.26.camel@Dan>
References: <1297260766.2327.40.camel@dan>
	 <20110209155130.GA2564@localhost.localdomain>
	 <20110209161654.GB2564@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: chris.mason@oracle.com, security@kernel.org,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110209161654.GB2564@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


> 
> Argh sorry I take it back, this is wrong, we can have multiple raid types per
> space info, so you need to put the slot_count-- in the inner loop farther down
> to count the actual slots we're adding.  Thanks,
> 

Good catch, thanks.

Reviewed-by: Dan Rosenberg <drosenberg@vsecurity.com>

-Dan

