From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [PATCH] Btrfs-progs: add btrfs filesystem disk-info command
Date: Wed, 29 Sep 2010 07:33:43 +0200
Message-ID: <201009290733.44028.kreijack@libero.it>
References: <1285707219-16304-1-git-send-email-josef@redhat.com> <201009290048.15214.kreijack@libero.it> <20100929003047.GE32420@dhcp231-156.rdu.redhat.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100929003047.GE32420@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 29 September, 2010, Josef Bacik wrote:
> On Wed, Sep 29, 2010 at 12:48:15AM +0200, Goffredo Baroncelli wrote:
> > Hi Josef,
> > 
> > please, if you add or change a command pay attention to update the man 
page 
> > too (man/btrfs.8.in).
> >
> 
> Hrm I missed that with git add, I'll fix that up.
[...]
> > > +
> > > +	ret = ioctl(fd, BTRFS_IOC_DISK_INFO, args);
> > > +	if (ret) {
> > > +		printf("failed ioctl\n");
> > Please use
> > 		fprintf(stderr,"ERROR: failed ioctl\n");
> >
> 
> Ugh oops sorry, forgot to get rid of my debug printing, I'll kill that.
If you use this command on a non btrfs filesystem, this is the first point of 
failure. So please don't kill it.




-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
