From: Josef Bacik <josef@redhat.com>
Subject: Re: WARNING: at fs/btrfs/inode.c:2198
 btrfs_orphan_commit_root+0xa8/0xc0
Date: Tue, 15 Nov 2011 14:29:26 -0500
Message-ID: <20111115192926.GB1944@localhost.localdomain>
References: <4EBA54F2.3030801@unilogicnetworks.net>
 <20111109153552.GB1810@localhost.localdomain>
 <4EBBBFFA.5090000@unilogicnetworks.net>
 <20111114160342.GB1947@localhost.localdomain>
 <4EC2B9E7.7020609@unilogicnetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Stefan Kleijkers <stefan@unilogicnetworks.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EC2B9E7.7020609@unilogicnetworks.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2011 at 08:13:43PM +0100, Stefan Kleijkers wrote:
> Hello Josef,
> 
> We have patched the 3.1.1 kernel with your patch and after a short
> time one of the ceph osds crashed (core dumped) and I found this in
> the dmesg, please let me know if that's enough information or if you
> need more.
> 

Yeah I was hoping for a WARN_ON() that should have shown up before that, do you
have the entire dmesg?  Thanks,

Josef
