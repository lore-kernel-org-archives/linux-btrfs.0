From: Josef Bacik <josef@redhat.com>
Subject: Re: free space inode generation
Date: Tue, 24 May 2011 10:22:26 -0400
Message-ID: <4DDBBF22.20006@redhat.com>
References: <irg77u$r3s$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <irg77u$r3s$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/24/2011 08:10 AM, Lubos Kolouch wrote:
> Hello,
> 
> I am getting following errors in the syslog 
> (running 2.6.39-gentoo kernel, latest git btrfs-progs, 
> mounted with -o space_cache)
> 
> btrfs: free space inode generation (0) did not match free space cache 
> generation (325850) for block group 29360128
> btrfs: free space inode generation (0) did not match free space cache 
> generation (325850) for block group 55863934976
> btrfs: free space inode generation (0) did not match free space cache 
> generation (325865) for block group 63380127744
> 
> The filesystem is mountable and basically usable, only *very* slow and
> taking resources (load around 7 or more).
> 
> Should I ignore the messages or is there something wrong and I can
> do something about it?
> 

We couldn't save the free space cache for some reason or another, so
it's telling you that.  That means we have to load the free space cache
the old fashioned slow way which means load is going to be a little
higher than normal for a little bit.  Thanks,

Josef
