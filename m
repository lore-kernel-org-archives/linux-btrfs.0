Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:10058 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751285AbbKKDpx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Nov 2015 22:45:53 -0500
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: "'Anand Jain'" <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
References: <068f125cbb9037fbd06cf5db81db8ae4a22ae712.1447063147.git.zhaolei@cn.fujitsu.com> <5640767F.1030909@oracle.com>
In-Reply-To: <5640767F.1030909@oracle.com>
Subject: RE: [PATCH 1/3] btrfs-progs: cmds-device: use warning/error for error message
Date: Wed, 11 Nov 2015 11:44:54 +0800
Message-ID: <051c01d11c33$541afe20$fc50fa60$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, Anand Jain

> -----Original Message-----
> From: Anand Jain [mailto:anand.jain@oracle.com]
> Sent: Monday, November 09, 2015 6:34 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; dsterba@suse.cz
> Subject: Re: [PATCH 1/3] btrfs-progs: cmds-device: use warning/error for error
> message
> 
> Hi Zhao,
> 
> Hope you could do this/apply on top of patch set
> 
>     "Introduce device delete by devid"
> 
> I vaguely remember that patchset as well did some cleanups in this part of the
> code.
> 
Thanks for notice.

I'll rebase it after patchset of "Introduce device delete by devid" get applied
into devel branch.

Thanks
Zhaolei

> Thanks, Anand
> 
> 
> On 11/09/2015 05:59 PM, Zhao Lei wrote:
> > Switch to common warning()/error() for cmds-device.c.
> >
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >   cmds-device.c | 57 +++++++++++++++++++++++----------------------------------
> >   1 file changed, 23 insertions(+), 34 deletions(-)
> >
> > diff --git a/cmds-device.c b/cmds-device.c index 2ed32a2..e23ea61
> > 100644
> > --- a/cmds-device.c
> > +++ b/cmds-device.c
> > @@ -102,7 +102,7 @@ static int cmd_device_add(int argc, char **argv)
> >
> >   		devfd = open(argv[i], O_RDWR);
> >   		if (devfd < 0) {
> > -			fprintf(stderr, "ERROR: Unable to open device '%s'\n", argv[i]);
> > +			error("Unable to open device '%s'", argv[i]);
> >   			ret++;
> >   			continue;
> >   		}
> > @@ -117,9 +117,8 @@ static int cmd_device_add(int argc, char **argv)
> >
> >   		path = canonicalize_path(argv[i]);
> >   		if (!path) {
> > -			fprintf(stderr,
> > -				"ERROR: Could not canonicalize pathname '%s': %s\n",
> > -				argv[i], strerror(errno));
> > +			error("Could not canonicalize pathname '%s': %s",
> > +			      argv[i], strerror(errno));
> >   			ret++;
> >   			goto error_out;
> >   		}
> > @@ -129,8 +128,8 @@ static int cmd_device_add(int argc, char **argv)
> >   		res = ioctl(fdmnt, BTRFS_IOC_ADD_DEV, &ioctl_args);
> >   		e = errno;
> >   		if (res < 0) {
> > -			fprintf(stderr, "ERROR: error adding the device '%s' - %s\n",
> > -				path, strerror(e));
> > +			error("error adding the device '%s' - %s",
> > +			      path, strerror(e));
> >   			ret++;
> >   		}
> >   		free(path);
> > @@ -162,8 +161,7 @@ static int _cmd_device_remove(int argc, char
> **argv,
> >   		int	res;
> >
> >   		if (is_block_device(argv[i]) != 1) {
> > -			fprintf(stderr,
> > -				"ERROR: %s is not a block device\n", argv[i]);
> > +			error("%s is not a block device", argv[i]);
> >   			ret++;
> >   			continue;
> >   		}
> > @@ -178,9 +176,8 @@ static int _cmd_device_remove(int argc, char
> **argv,
> >   				msg = btrfs_err_str(res);
> >   			else
> >   				msg = strerror(e);
> > -			fprintf(stderr,
> > -				"ERROR: error removing the device '%s' - %s\n",
> > -				argv[i], msg);
> > +			error("error removing the device '%s' - %s",
> > +			      argv[i], msg);
> >   			ret++;
> >   		}
> >   	}
> > @@ -251,11 +248,9 @@ static int cmd_device_scan(int argc, char **argv)
> >   	if (all || argc == 1) {
> >   		printf("Scanning for Btrfs filesystems\n");
> >   		ret = btrfs_scan_lblkid();
> > -		if (ret)
> > -			fprintf(stderr, "ERROR: error %d while scanning\n", ret);
> > +		error_on(ret, "error %d while scanning", ret);
> >   		ret = btrfs_register_all_devices();
> > -		if (ret)
> > -			fprintf(stderr, "ERROR: error %d while registering\n", ret);
> > +		error_on(ret, "error %d while registering", ret);
> >   		goto out;
> >   	}
> >
> > @@ -263,16 +258,14 @@ static int cmd_device_scan(int argc, char **argv)
> >   		char *path;
> >
> >   		if (is_block_device(argv[i]) != 1) {
> > -			fprintf(stderr,
> > -				"ERROR: %s is not a block device\n", argv[i]);
> > +			error("%s is not a block device", argv[i]);
> >   			ret = 1;
> >   			goto out;
> >   		}
> >   		path = canonicalize_path(argv[i]);
> >   		if (!path) {
> > -			fprintf(stderr,
> > -				"ERROR: Could not canonicalize path '%s': %s\n",
> > -				argv[i], strerror(errno));
> > +			error("Could not canonicalize path '%s': %s",
> > +			      argv[i], strerror(errno));
> >   			ret = 1;
> >   			goto out;
> >   		}
> > @@ -313,16 +306,14 @@ static int cmd_device_ready(int argc, char
> > **argv)
> >
> >   	path = canonicalize_path(argv[argc - 1]);
> >   	if (!path) {
> > -		fprintf(stderr,
> > -			"ERROR: Could not canonicalize pathname '%s': %s\n",
> > -			argv[argc - 1], strerror(errno));
> > +		error("Could not canonicalize pathname '%s': %s",
> > +		      argv[argc - 1], strerror(errno));
> >   		ret = 1;
> >   		goto out;
> >   	}
> >
> >   	if (is_block_device(path) != 1) {
> > -		fprintf(stderr,
> > -			"ERROR: %s is not a block device\n", path);
> > +		error("%s is not a block device", path);
> >   		ret = 1;
> >   		goto out;
> >   	}
> > @@ -331,9 +322,8 @@ static int cmd_device_ready(int argc, char **argv)
> >   	strncpy_null(args.name, path);
> >   	ret = ioctl(fd, BTRFS_IOC_DEVICES_READY, &args);
> >   	if (ret < 0) {
> > -		fprintf(stderr, "ERROR: unable to determine if the device '%s'"
> > -			" is ready for mounting - %s\n", path,
> > -			strerror(errno));
> > +		error("unable to determine if the device '%s' is ready for mounting
> - %s",
> > +		      path, strerror(errno));
> >   		ret = 1;
> >   	}
> >
> > @@ -388,13 +378,13 @@ static int cmd_device_stats(int argc, char
> > **argv)
> >
> >   	ret = get_fs_info(dev_path, &fi_args, &di_args);
> >   	if (ret) {
> > -		fprintf(stderr, "ERROR: getting dev info for devstats failed: "
> > -				"%s\n", strerror(-ret));
> > +		error("getting dev info for devstats failed: %s",
> > +		      strerror(-ret));
> >   		err = 1;
> >   		goto out;
> >   	}
> >   	if (!fi_args.num_devices) {
> > -		fprintf(stderr, "ERROR: no devices found\n");
> > +		error("no devices found");
> >   		err = 1;
> >   		goto out;
> >   	}
> > @@ -412,9 +402,8 @@ static int cmd_device_stats(int argc, char **argv)
> >   		args.flags = flags;
> >
> >   		if (ioctl(fdmnt, BTRFS_IOC_GET_DEV_STATS, &args) < 0) {
> > -			fprintf(stderr,
> > -				"ERROR: ioctl(BTRFS_IOC_GET_DEV_STATS) on %s
> failed: %s\n",
> > -				path, strerror(errno));
> > +			error("ioctl(BTRFS_IOC_GET_DEV_STATS) on %s failed: %s",
> > +			      path, strerror(errno));
> >   			err = 1;
> >   		} else {
> >   			char *canonical_path;
> >

