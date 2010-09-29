From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs-progs: add btrfs filesystem disk-info command
Date: Tue, 28 Sep 2010 20:30:48 -0400
Message-ID: <20100929003047.GE32420@dhcp231-156.rdu.redhat.com>
References: <1285707219-16304-1-git-send-email-josef@redhat.com> <201009290048.15214.kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201009290048.15214.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 12:48:15AM +0200, Goffredo Baroncelli wrote:
> Hi Josef,
> 
> please, if you add or change a command pay attention to update the man page 
> too (man/btrfs.8.in).
>

Hrm I missed that with git add, I'll fix that up.
 
> See my comments below
> 
> On Tuesday, 28 September, 2010, Josef Bacik wrote:
> > This command just implements the BTRFS_IOC_DISK_INFO ioctl.  It gets all the
> > devices for a filesystem, reads /proc/partitions for the right dev info and
> > spits out pretty names.
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  btrfs.c      |    4 ++
> >  btrfs_cmds.c |  101 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  btrfs_cmds.h |    1 +
> >  ioctl.h      |    8 ++++
> >  4 files changed, 114 insertions(+), 0 deletions(-)
> > 
> > diff --git a/btrfs.c b/btrfs.c
> > index ab5e57f..22b241b 100644
> > --- a/btrfs.c
> > +++ b/btrfs.c
> > @@ -91,6 +91,10 @@ static struct Command commands[] = {
> >  	  "filesystem df", "<path>\n"
> >  		"Show space usage information for a mount point\n."
> >  	},
> > +	{ do_disk_info, 1,
> > +	  "filesystem disk-info", "<path>\n"
> > +		"Show disks contained within this filesysten."
> > +	},
> >  	{ do_balance, 1,
> >  	  "filesystem balance", "<path>\n"
> >  		"Balance the chunks across the device."
> > diff --git a/btrfs_cmds.c b/btrfs_cmds.c
> > index 683aec0..b1a4d8d 100644
> > --- a/btrfs_cmds.c
> > +++ b/btrfs_cmds.c
> > @@ -835,6 +835,107 @@ int do_set_default_subvol(int nargs, char **argv)
> >  	return 0;
> >  }
> >  
> > +int do_disk_info(int nargs, char **argv)
> > +{
> > +	struct btrfs_ioctl_disk_info_args *args;
> > +	char *path = argv[1];
> > +	int devs;
> > +	int fd;
> > +	int ret;
> > +	int i;
> > +
> > +	fd = open_file_or_dir(path);
> > +	if (fd < 0) {
> > +		fprintf(stderr, "Error: can't access '%s'\n", path);
> > +		return 12;
> > +	}
> > +
> > +	args = malloc(sizeof(*args));
> > +	if (!args)
> > +		return -ENOMEM;
> > +
> > +	args->num_devices = 0;
> > +
> > +	ret = ioctl(fd, BTRFS_IOC_DISK_INFO, args);
> > +	if (ret) {
> > +		printf("failed ioctl\n");
> Please use
> 		fprintf(stderr,"ERROR: failed ioctl\n");
>

Ugh oops sorry, forgot to get rid of my debug printing, I'll kill that.
 
> > +		free(args);
> > +		return ret;
> > +	}
> > +
> > +	if (!args->num_devices) {
> > +		printf("no devs\n");
> > +		free(args);
> > +		return 0;
> > +	}
> > +
> > +	devs = args->num_devices;
> > +	args = realloc(args, sizeof(*args) + (devs * sizeof(dev_t)));
> > +	if (!args) {
> > +		printf("enomem\n");
> Please use
> 		fprintf(stderr,"ERROR: not enough memory\n");

Yeah another debug print.

> > +		return -ENOMEM;
> > +	}
> > +	args->num_devices = devs;
> > +
> > +	ret = ioctl(fd, BTRFS_IOC_DISK_INFO, args);
> > +	if (ret) {
> > +		printf("ioctl failed second time\n");
> Please use
> 		fprintf(stderr,"ERROR: ioctl failed (second time)\n");
> 
> > +		free(args);
> > +		return -ENOMEM;
> > +	}
> > +	close(fd);
> > +
> > +	fd = open_file_or_dir("/proc/partitions");
> 
> Why not
> 
> 	f = fopen("/proc/partitions","r")
> 
> So you can avoid "f = fdopen(fd,"r")" and the "goto print"
> 
> > +	if (fd < 0) {
> > +print:
> > +		printf("Devices in %s\n", path);
> > +		for (i = 0; i < args->num_devices; i++)
> > +			printf("\t%d:%d\n", major(args->devices[i]),
> > +			       minor(args->devices[i]));
> > +		close(fd);
> 		^^^^^^^^^
> why close fd ? ... ok, in case of fdopen(fd,"r") == 0
>

Yeah I didn't think this through well, I'll fix it up.  I mostly just sent this
as an afterthought.  When we figure out how the interface is going to look I'll
fix everything up and re-send.  Thanks,

Josef 
