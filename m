From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: btrfs: free space inode generation (0) did not match free	space
 cache generation
Date: Fri, 28 Jan 2011 14:56:24 +0100
Message-ID: <4D42CB08.5030904@wpkg.org>
References: <4D42939C.5020605@wpkg.org> <20110128134531.GB4884@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110128134531.GB4884@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 28.01.2011 14:45, Josef Bacik wrote:
> It's not a problem, it just means that the cache is being discarded, which is
> what is supposed to happen.  You probably ran out of space or one of the other
> corner cases where we can't write out the space cache.  Thanks,

FYI, there is plenty of free space (~150 GB).

It could be some corner case:

- filesystem is mounted with compress-force,
- one kvm process (the only writer to btrfs) writes to the btrfs 
filesystem, via the virtual guest using a 220 GB qcow2 image file (lots 
of writes) and a 7 GB qcow2 image file (very few writes).


-- 
Tomasz Chmielewski
http://wpkg.org
