From: Felix Blanke <felixblanke@gmail.com>
Subject: Re: Bug in mkfs.btrfs?!
Date: Mon, 24 Jan 2011 14:01:04 +0100
Message-ID: <20110124130104.GA7354@scooter>
References: <20110122144513.GA2539@scooter>
 <20110122145222.GB2539@scooter>
 <20110122151124.GC29985@carfax.org.uk>
 <20110122155612.GA3664@scooter>
 <20110123181827.GF29985@carfax.org.uk>
 <4D3CA568.7050506@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo-lkml@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D3CA568.7050506@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

you were talking about the LOOP_GET_STATUS function. I'm not quite sure where does it
came from. Is it part of the kernel? Or does it come from the util-linux package?

I'm searching for the right location where do report that bug :)


Btw: I tested it with util-linux-2.19-rc1. The strace still contains the truncated
path, and no '*'. Therefore I think that ioctl is from the kernel.

Regards,
Felix

On 23. January 2011 - 23:02, Goffredo Baroncelli wrote:
> Date: Sun, 23 Jan 2011 23:02:16 +0100
> From: Goffredo Baroncelli <kreijack@libero.it>
> To: Hugo Mills <hugo-lkml@carfax.org.uk>, Felix Blanke
>  <felixblanke@gmail.com>
> CC: linux-btrfs@vger.kernel.org
> Subject: Re: Bug in mkfs.btrfs?!
> 
> On 01/23/2011 07:18 PM, Hugo Mills wrote:
> >    Hi, Felix,
> > 
> > On Sat, Jan 22, 2011 at 04:56:12PM +0100, Felix Blanke wrote:
> >> It was a simple:
> >>
> >> mkfs.btrfs -L backup -d single /dev/loop2
> >>
> >> But it also happens without the options, like:
> >>
> >> mkfs.btrfs /dev/loop2
> >>
> >>
> >> /dev/loop2 is a loop device, which is aes encrypted. The output of "losetup /dev/loop2":
> >>
> >> /dev/loop2: [0010]:5324 
> >> (/dev/disk/by-id/ata-WDC_WD6400AAKS-22A7B2_WD-WCASY7780706-part3) encryption=AES128
> >>
> >>
> >> Thanks you for looking into this!
> >> While writing this I read your second mail. The strace output is attached.
> > 
> >    OK, I've traced through the functions being called, and I really
> > can't see where it could be truncating the name, unless your system
> > has a stupidly small value of PATH_MAX.
> 
> It seems that when mkfs.btrfs checks if the passed block device is
> already mounted, uses the ioctl LOOP_GET_STATUS [1]. This ioctl has as
> argument the struct loop_info.
> 
> This ioctl, should return the info about the back-end of the loop
> device. The file name is returned via the "lo_name" field, which is an
> array of 64 char...[2]
> 
> Felix, what is the output of the following command ?
> 
> 	/sbin/losetup -a
> 
> If my analysis is correct, this command should return the filename
> trunked at the 64th character too.
> 
> Goffredo
> 
> [1] file util.c, function resolve_loop_device
> [2]
> http://lxr.e2g.org/source/bionic/libc/kernel/common/linux/loop.h?a=ppc#L26
>   and
> http://lxr.e2g.org/source/bionic/libc/kernel/common/linux/loop.h?a=ppc#L15
> 
> 
> 
> 
> 
> > 
> >    Can you apply the following patch (to the "next" branch of the
> > btrfs-progs git repo), rebuild, and try again? It's just adding some
> > debugging output to track what it's looking at.
> > 
> >    Hugo.
> > 
> > 
> > diff --git a/mkfs.c b/mkfs.c
> > index 2e99b95..51a5096 100644
> > --- a/mkfs.c
> > +++ b/mkfs.c
> > @@ -422,6 +422,7 @@ int main(int ac, char **av)
> >  	printf("WARNING! - see http://btrfs.wiki.kernel.org before using\n\n");
> >  
> >  	file = av[optind++];
> > +	printf("Checking whether %s is part of a mounted filesystem\n", file);
> >  	ret = check_mounted(file);
> >  	if (ret < 0) {
> >  		fprintf(stderr, "error checking %s mount status\n", file);
> > diff --git a/utils.c b/utils.c
> > index fd894f3..7fa3149 100644
> > --- a/utils.c
> > +++ b/utils.c
> > @@ -610,12 +610,16 @@ int resolve_loop_device(const char* loop_dev, char* loop_file, int max_len)
> >  	int ret_ioctl;
> >  	struct loop_info loopinfo;
> >  
> > +	printf("Resolving loop device %s (length %d)\n", loop_dev, max_len);
> > +
> >  	if ((loop_fd = open(loop_dev, O_RDONLY)) < 0)
> >  		return -errno;
> >  
> >  	ret_ioctl = ioctl(loop_fd, LOOP_GET_STATUS, &loopinfo);
> >  	close(loop_fd);
> >  
> > +	printf("Loop name = %s\n", loopinfo.lo_name);
> > +
> >  	if (ret_ioctl == 0)
> >  		strncpy(loop_file, loopinfo.lo_name, max_len);
> >  	else
> > @@ -639,6 +643,9 @@ int is_same_blk_file(const char* a, const char* b)
> >  		return -errno;
> >  	}
> >  
> > +	printf("Realpath of %s was %s\n", a, real_a);
> > +	printf("Realpath of %s was %s\n", b, real_b);
> > +
> >  	/* Identical path? */
> >  	if(strcmp(real_a, real_b) == 0)
> >  		return 1;
> > @@ -680,6 +687,9 @@ int is_same_loop_file(const char* a, const char* b)
> >  	const char* final_b;
> >  	int ret;
> >  
> > +	printf("is_same_loop_file: %s and %s\n", a, b);
> > +	printf("PATH_MAX = %d\n", PATH_MAX);
> > +
> >  	/* Resolve a if it is a loop device */
> >  	if((ret = is_loop_device(a)) < 0) {
> >  	   return ret;
> > @@ -784,8 +794,10 @@ int check_mounted(const char* file)
> >  			if(strcmp(mnt->mnt_type, "btrfs") != 0)
> >  				continue;
> >  
> > +			printf("Testing if btrfs device is in the dev list: %s\n", mnt->mnt_fsname);
> >  			ret = blk_file_in_dev_list(fs_devices_mnt, mnt->mnt_fsname);
> >  		} else {
> > +			printf("Testing if non-btrfs device is block or regular: %s\n", mnt->mnt_fsname);
> >  			/* ignore entries in the mount table that are not
> >  			   associated with a file*/
> >  			if((ret = is_existing_blk_or_reg_file(mnt->mnt_fsname)) < 0)
> > diff --git a/volumes.c b/volumes.c
> > index 7671855..2496fbd 100644
> > --- a/volumes.c
> > +++ b/volumes.c
> > @@ -130,6 +130,8 @@ static int device_list_add(const char *path,
> >  		device->fs_devices = fs_devices;
> >  	}
> >  
> > +	printf("Device added with name %s\n", device->name);
> > +
> >  	if (found_transid > fs_devices->latest_trans) {
> >  		fs_devices->latest_devid = devid;
> >  		fs_devices->latest_trans = found_transid;
> > @@ -223,6 +225,7 @@ int btrfs_scan_one_device(int fd, const char *path,
> >  		*total_devs = btrfs_super_num_devices(disk_super);
> >  	uuid_unparse(disk_super->fsid, uuidbuf);
> >  
> > +	printf("Adding device %s to list\n", path);
> >  	ret = device_list_add(path, disk_super, devid, fs_devices_ret);
> >  
> >  error_brelse:
> > 
> > 
> 
---end quoted text---
