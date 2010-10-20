From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [RFC] Allow to exec "btrfs subvolume delete" by a non root user
Date: Wed, 20 Oct 2010 05:00:47 +0200
Message-ID: <201010200500.47793.kreijack@libero.it>
References: <201010182004.59352.kreijack@libero.it> <Pine.LNX.4.64.1010191653550.26790@cobra.newdream.net>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1010191653550.26790@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 20 October, 2010, Sage Weil wrote:
> On Mon, 18 Oct 2010, Goffredo Baroncelli wrote:
> 
> > Hi all
> > 
> > like my previous patch, this one allow to remove a subvolume by an 
ordinary
> >  user. Instead of adding this capability to the rmdir(2) syscall, I update 
the
> > BTRFS_IOC_SNAP_DESTROY ioctl, relaxing the rules to be execute.
> > The checks are the ones performed by the rmdir(2) syscall. So a 
> > subvolume must be empty to be removed by a non-root user. I think that 
this
> >  increases a lot the usefulness of the snapshot/subvolume.
> > 
> > It is possible to pull the code from the branch named "rm-subvolume-not-
root" 
> > of the following repository:
> > 
> >       http://cassiopea.homelinux.net/git/btrfs-unstable.git  
> > 
> > Comments are welcome.
> 
> This looks okay to me.  I posted a similar patch a while back[1], but 
> didn't want to duplicate the check_sticky and may_delete code and 
> implemented a simpler set of checks instead.  The full checks are probably 
> a better route, although it would be nice if we could avoid duplicating 
> the VFS checks in the process.  Whether those helpers should be exported 
> is someone else's call, though.  (The only other may_ functions that are 
> exported are may_umount and may_umount_tree.)

I agree about the may_* function. But also there is the case of the 
may_create..
Anyway I want to highlight that the main differences between our patches is 
the fact that may patches needed the subvolume to be empty. So I skip all the 
problem related to removing a "not owned directory - not empty directory"

> 
> sage
> 
> [1] http://marc.info/?l=linux-btrfs&m=128086492512628&w=2


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
