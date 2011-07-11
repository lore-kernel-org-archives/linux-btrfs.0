From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Mon, 11 Jul 2011 21:45:55 +0100
Message-ID: <20110711204555.GL4325@carfax.org.uk>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
 <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="64LDleNqNegJ4g97"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--64LDleNqNegJ4g97
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   OK, here's the remainder of my comments for this file. Not much for
this bit -- just one comment about locking, a reminder, and an
observation.

On Wed, Mar 30, 2011 at 06:53:12PM +0200, Jan Schmidt wrote:
[...]

> +static int _scrub_write_buf(int fd, const void *data, int len)
> +{
> +	int ret;
> +	ret = write(fd, data, len);
> +	return ret - len;
> +}
> +
> +static int _scrub_writev(int fd, char *buf, int max, const char *fmt, ...)
> +				__attribute__ ((format (printf, 4, 5)));
> +static int _scrub_writev(int fd, char *buf, int max, const char *fmt, ...)
> +{
> +	int ret;
> +	va_list args;
> +	
> +	va_start(args, fmt);
> +	ret = vsnprintf(buf, max, fmt, args);
> +	va_end(args);
> +	if (ret >= max)
> +		return ret - max;
> +	return _scrub_write_buf(fd, buf, ret);
> +}
> +
> +#define _SCRUB_SUM(dest, data, name) dest->scrub_args.progress.name =	\
> +			data->resumed->p.name + data->scrub_args.progress.name
> +static struct scrub_progress *_scrub_resumed_stats(struct scrub_progress *data,
> +                                                   struct scrub_progress *dest)
> +{
> +	if (!data->resumed || data->skip)
> +		return data;
> +
> +	_SCRUB_SUM(dest, data, data_extents_scrubbed);
> +	_SCRUB_SUM(dest, data, tree_extents_scrubbed);
> +	_SCRUB_SUM(dest, data, data_bytes_scrubbed);
> +	_SCRUB_SUM(dest, data, tree_bytes_scrubbed);
> +	_SCRUB_SUM(dest, data, read_errors);
> +	_SCRUB_SUM(dest, data, csum_errors);
> +	_SCRUB_SUM(dest, data, verify_errors);
> +	_SCRUB_SUM(dest, data, no_csum);
> +	_SCRUB_SUM(dest, data, csum_discards);
> +	_SCRUB_SUM(dest, data, super_errors);
> +	_SCRUB_SUM(dest, data, malloc_errors);
> +	_SCRUB_SUM(dest, data, uncorrectable_errors);
> +	_SCRUB_SUM(dest, data, corrected_errors);
> +	_SCRUB_SUM(dest, data, last_physical);
> +	dest->stats.canceled = data->stats.canceled;
> +	dest->stats.finished = data->stats.finished;
> +	dest->stats.t_resumed = data->stats.t_start;
> +	dest->stats.t_start = data->resumed->stats.t_start;
> +	dest->stats.duration = data->resumed->stats.duration +
> +							data->stats.duration;
> +	dest->scrub_args.devid = data->scrub_args.devid;
> +	return dest;
> +}
> +
> +#define _SCRUB_KVWRITE(fd, buf, name, use) 		\
> +	_scrub_kvwrite(fd, buf, sizeof(buf), #name, 	\
> +	               use->scrub_args.progress.name)
> +#define _SCRUB_KVWRITE_STATS(fd, buf, name, use) 	\
> +	_scrub_kvwrite(fd, buf, sizeof(buf), #name, 	\
> +	               use->stats.name)
> +static int _scrub_kvwrite(int fd, char *buf, int max,
> +                          const char *key, u64 val)
> +{
> +	return _scrub_writev(fd, buf, max, "|%s:%lld", key, val);
> +}
> +
> +static int scrub_write_file(int fd, const char *fsid,
> +                            struct scrub_progress* data, int n)
> +{
> +	int ret = 0;
> +	int i;
> +	char buf[1024];
> +	struct scrub_progress local;
> +	struct scrub_progress *use;
> +
> +	if (n < 1) {
> +		return -EINVAL;
> +	}
> +
> +	ret = _scrub_write_buf(fd, SCRUB_FILE_VERSION_PREFIX SCRUB_FILE_VERSION
> +	                       "\n", sizeof(SCRUB_FILE_VERSION_PREFIX)-1
> +	                       + sizeof(SCRUB_FILE_VERSION)-1 + 1);
> +	if (ret)
> +		return -EOVERFLOW;
> +
> +	for (i=0; i<n; ++i) {
> +		use = _scrub_resumed_stats(&data[i], &local);
> +		if (_scrub_write_buf(fd, fsid, strlen(fsid)) ||
> +		    _scrub_write_buf(fd, ":", 1) ||
> +		    _scrub_writev(fd, buf, sizeof(buf), "%lld",
> +		                  use->scrub_args.devid) ||
> +		    _scrub_write_buf(fd, buf, ret) ||
> +		    _SCRUB_KVWRITE(fd, buf, data_extents_scrubbed, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, tree_extents_scrubbed, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, data_bytes_scrubbed, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, tree_bytes_scrubbed, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, read_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, csum_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, verify_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, no_csum, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, csum_discards, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, super_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, malloc_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, uncorrectable_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, corrected_errors, use) ||
> +		    _SCRUB_KVWRITE(fd, buf, last_physical, use) ||
> +		    _SCRUB_KVWRITE_STATS(fd, buf, t_start, use) ||
> +		    _SCRUB_KVWRITE_STATS(fd, buf, t_resumed, use) ||
> +		    _SCRUB_KVWRITE_STATS(fd, buf, duration, use) ||
> +		    _SCRUB_KVWRITE_STATS(fd, buf, canceled, use) ||
> +		    _SCRUB_KVWRITE_STATS(fd, buf, finished, use) ||
> +		    _scrub_write_buf(fd, "\n", 1)) {
> +			return -EOVERFLOW;
> +		}
> +	}
> +
> +	return 0;
> +}
> +#undef _SCRUB_KVWRITE
> +
> +static int scrub_write_progress(pthread_mutex_t *m, const char *fsid,
> +                                struct scrub_progress* data, int n)
> +{
> +	int ret;
> +	int fd;
> +	int old;
> +
> +	ret = pthread_mutex_lock(m);
> +	if (ret) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);

   Probably not massively important, but you don't check for the
return value of this call or its counterpart at the end of this
function.

> +	fd = scrub_open_file_w(SCRUB_DATA_FILE, fsid, "tmp");
> +	if (fd < 0) {
> +		ret = fd;
> +		goto out;
> +	}
> +	ret = scrub_write_file(fd, fsid, data, n);
> +	if (ret)
> +		goto out;

   This leaks the file handle fd.

> +	ret = scrub_rename_file(SCRUB_DATA_FILE, fsid, "tmp");
> +	if (ret)
> +		goto out;

   As does this.

> +	ret = close(fd);
> +	if (ret) {
> +		ret = -errno;
> +		goto out;
> +	}
> +
> +out:
> +	if (ret) {
> +		pthread_mutex_unlock(m);
> +	} else {
> +		ret = pthread_mutex_unlock(m);
> +		if (ret)
> +			ret = -errno;
> +	}
> +
> +	pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, &old);
> +
> +	return ret;
> +}
> +
> +static void *scrub_one_dev(void *ctx)
> +{
> +	struct scrub_progress *sp = ctx;
> +	int ret;
> +	struct timeval tv;
> +
> +	sp->stats.canceled = 0;
> +	sp->stats.duration = 0;
> +	sp->stats.finished = 0;
> +
> +	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
> +	gettimeofday(&tv, NULL);
> +	sp->ret = ret;
> +	sp->stats.duration = tv.tv_sec - sp->stats.t_start;
> +	sp->stats.canceled = !!ret;
> +	sp->ioctl_errno = errno;
> +	ret = pthread_mutex_lock(&sp->progress_mutex);
> +	if (ret)
> +		return ERR_PTR(-errno);
> +	sp->stats.finished = 1;
> +	ret = pthread_mutex_unlock(&sp->progress_mutex);

   If you downgrade .finished to a plain int, rather than a u64, then
is this locking actually be needed? You have one place where the lock
is held to write a single value (which is atomic for an int, IIRC),
and you have another place where you hold the lock to read and compare
it. I don't see any problem with removing the lock for that.

> +	if (ret)
> +		return ERR_PTR(-errno);
> +	
> +
> +	return NULL;
> +}
> +
> +static void *progress_one_dev(void *ctx)
> +{
> +	struct scrub_progress *sp = ctx;
> +	
> +	sp->ret = ioctl(sp->fd, BTRFS_IOC_SCRUB_PROGRESS, &sp->scrub_args);
> +	sp->ioctl_errno = errno;
> +
> +	return NULL;
> +}
> +
> +static void *scrub_progress_cycle(void *ctx)
> +{
> +	int ret;
> +	int i;
> +	char fsid[37];
> +	struct scrub_progress *sp;
> +	struct scrub_progress *sp_last;
> +	struct scrub_progress *sp_shared;
> +	struct timeval tv;
> +	struct scrub_progress_cycle *spc = ctx;
> +	int ndev = spc->fi->num_devices;
> +	int this = 1;
> +	int last = 0;
> +	int peer_fd = -1;
> +	struct pollfd accept_poll_fd = {
> +		.fd = spc->prg_fd,
> +		.events = POLLIN,
> +		.revents = 0,
> +	};
> +	struct pollfd write_poll_fd = {
> +		.events = POLLOUT,
> +		.revents = 0,
> +	};
> +	struct sockaddr_un peer;
> +	socklen_t peer_size = sizeof(peer);
> +
> +	pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &ret);
> +	uuid_unparse(spc->fi->fsid, fsid);
> +
> +	for (i=0; i<ndev; ++i) {
> +		sp = &spc->progress[i];
> +		sp_last = &spc->progress[i+ndev];
> +		sp_shared = &spc->shared_progress[i];
> +		sp->scrub_args.devid = sp_last->scrub_args.devid =
> +						sp_shared->scrub_args.devid;
> +		sp->fd = sp_last->fd = spc->fdmnt;
> +		sp->stats.t_start = sp_last->stats.t_start =
> +						sp_shared->stats.t_start;
> +		sp->resumed = sp_last->resumed = sp_shared->resumed;
> +		sp->skip = sp_last->skip = sp_shared->skip;
> +		sp->stats.finished = sp_last->stats.finished =
> +						sp_shared->stats.finished;
> +	}
> +
> +	while (1) {
> +		ret = poll(&accept_poll_fd, 1, 5*1000);
> +		if (ret == -1)
> +			return ERR_PTR(-errno);
> +		if (ret)
> +			peer_fd = accept(spc->prg_fd, (struct sockaddr *)&peer,
> +					 &peer_size);
> +		gettimeofday(&tv, NULL);
> +		this = (this+1)%2;
> +		last = (last+1)%2;
> +		for (i=0; i<ndev; ++i) {
> +			sp = &spc->progress[this*ndev+i];
> +			sp_last = &spc->progress[last*ndev+i];
> +			sp_shared = &spc->shared_progress[i];
> +			if (sp->stats.finished) {
> +				continue;
> +			}
> +			progress_one_dev(sp);
> +			sp->stats.duration = tv.tv_sec - sp->stats.t_start;
> +			if (!sp->ret)
> +				continue;
> +			if (sp->ioctl_errno != ENOTCONN &&
> +			    sp->ioctl_errno != ENODEV)
> +				return ERR_PTR(-sp->ioctl_errno);
> +			/*
> +			 * scrub finished or device removed, check the
> +			 * finished flag. if unset, just use the last
> +			 * result we got for the current write and go
> +			 * on. flag should be set on next cycle, then.
> +			 */
> +			ret = pthread_mutex_lock(&sp_shared->progress_mutex);
> +			if (ret)
> +				return ERR_PTR(-errno);
> +			if (!sp_shared->stats.finished) {
> +				ret = pthread_mutex_unlock(
> +						&sp_shared->progress_mutex);
> +				if (ret)
> +					return ERR_PTR(-errno);
> +				memcpy(sp, sp_last, sizeof(*sp));
> +				continue;
> +			}
> +			ret = pthread_mutex_unlock(&sp_shared->progress_mutex);
> +			if (ret)
> +				return ERR_PTR(-errno);
> +			memcpy(sp, sp_shared, sizeof(*sp));
> +			memcpy(sp_last, sp_shared, sizeof(*sp));
> +		}
> +		if (peer_fd != -1) {
> +			write_poll_fd.fd = peer_fd;
> +			ret = poll(&write_poll_fd, 1, 0);
> +			if (ret == -1)
> +				return ERR_PTR(-errno);
> +			if (ret) {
> +				ret = scrub_write_file(
> +					peer_fd, fsid,
> +					&spc->progress[this*ndev], ndev);
> +				if (ret)
> +					return ERR_PTR(ret);
> +			}
> +			close(peer_fd);
> +			peer_fd = -1;
> +		}
> +		if (!spc->do_record)
> +			continue;
> +		ret = scrub_write_progress(spc->write_mutex, fsid,
> +		                           &spc->progress[this*ndev], ndev);
> +		if (ret)
> +			return ERR_PTR(ret);
> +	}
> +}

[...]

> +int do_scrub_cancel(int argc, char **argv)
> +{
> +	char *path = argv[1];
> +	int ret;
> +	int fdmnt;
> +	int err;
> +	char mp[BTRFS_PATH_NAME_MAX+1];
> +	struct btrfs_fs_devices* fs_devices_mnt = NULL;
> +
> +	fdmnt = open_file_or_dir(path);
> +	if (fdmnt < 0) {
> +		fprintf(stderr, "ERROR: scrub cancel failed\n");
> +		return 12;
> +	}
> +
> +again:
> +	ret = ioctl(fdmnt, BTRFS_IOC_SCRUB_CANCEL, NULL);
> +	err = errno;
> +	close(fdmnt);
> +
> +	if (ret && err == EINVAL) {
> +		/* path is no mounted btrfs. try if it's a device */
> +		ret = check_mounted_where(fdmnt, path, mp, sizeof(mp),
> +					  &fs_devices_mnt);
> +		close(fdmnt);
> +		if (ret) {
> +			fdmnt = open_file_or_dir(mp);
> +			if (fdmnt >= 0) {
> +				path = mp;
> +				goto again;
> +			}
> +		}
> +	}
> +
> +	if (ret) {
> +		fprintf(stderr, "ERROR: scrub cancel failed on %s: %s\n", path,
> +		        err == ENOTCONN ? "not running" : strerror(errno));
> +		return 1;
> +	}
> +
> +	printf("scrub cancelled\n");
> +
> +	return 0;
> +}
> +
> +int do_scrub_status(int argc, char **argv)
> +{
> +
> +	char *path;
> +	struct btrfs_ioctl_fs_info_args fi_args;
> +	struct btrfs_ioctl_dev_info_args *di_args = NULL;
> +	struct scrub_file_record **past_scrubs = NULL;
> +	struct scrub_file_record *last_scrub;
> +	struct scrub_fs_stat fs_stat;
> +	struct sockaddr_un addr = {
> +		.sun_family = AF_UNIX,
> +	};
> +	int ret;
> +	int fdmnt;
> +	int i;
> +	optind = 1;
> +	int print_raw = 0;
> +	int do_stats_per_dev = 0;
> +	char c;
> +	char fsid[37];
> +	int fdres = -1;
> +	int err = 0;
> +
> +	while ((c = getopt(argc, argv, "dR")) != -1) {
> +		switch(c) {
> +		case 'd':
> +			do_stats_per_dev = 1;
> +			break;
> +		case 'R':
> +			print_raw = 1;
> +			break;
> +		case '?':
> +		default:
> +			fprintf(stderr, "ERROR: scrub status args invalid.\n"
> +			                " -d  stats per device\n");
> +			return 1;
> +		}
> +	}
> +
> +	path = argv[optind];
> +
> +	fdmnt = open_file_or_dir(path);
> +	if (fdmnt < 0) {
> +		fprintf(stderr, "ERROR: can't access to '%s'\n", path);
> +		return 12;
> +	}
> +
> +	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
> +	if (ret) {
> +		fprintf(stderr, "ERROR: getting dev info for scrub failed: "
> +		        "%s\n", strerror(-ret));
> +		err = 1;
> +		goto out;
> +	}
> +	if (!fi_args.num_devices) {
> +		fprintf(stderr, "ERROR: no devices found\n");
> +		err = 1;
> +		goto out;
> +	}
> +
> +	uuid_unparse(fi_args.fsid, fsid);
> +
> +	fdres = socket(AF_UNIX, SOCK_STREAM, 0);
> +	if (fdres == -1) {
> +		fprintf(stderr, "ERROR: failed to create socket to "
> +			"receive progress information: %s\n",
> +			strerror(errno));
> +		err = 1;
> +		goto out;
> +	}
> +	_scrub_datafile(SCRUB_PROGRESS_SOCKET_PATH, fsid,
> +			NULL, addr.sun_path, sizeof(addr.sun_path)-1);
> +	/* ignore EOVERFLOW, just use shorter name and hope for the best */

   Same comment as in the previous mail about ignoring EOVERFLOW in
this code...

> +	ret = connect(fdres, (struct sockaddr *)&addr, sizeof(addr));
> +	if (ret == -1) {
> +		fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
> +		if (fdres < 0 && fdres != -ENOENT) {
> +			fprintf(stderr, "WARNING: failed to open status file: "
> +				"%s\n", strerror(-fdres));
> +			err = 1;
> +			goto out;
> +		}
> +	}
> +
> +	if (fdres >= 0) {
> +		past_scrubs = scrub_read_file(fdres, 1);
> +		if (IS_ERR(past_scrubs))
> +			fprintf(stderr, "WARNING: failed to read status: %s\n",
> +				strerror(-PTR_ERR(past_scrubs)));
> +	}
> +
> +	printf("scrub status for %s\n", fsid);
> +
> +	/*
> +	 * TODO: rather communicate with scrub process instead of
> +	 *       dumping the file stats for instant results
> +	 */
> +	if (do_stats_per_dev) {
> +		for (i = 0; i < fi_args.num_devices; ++i) {
> +			last_scrub = last_dev_scrub(past_scrubs,
> +			                            di_args[i].devid);
> +			if (!last_scrub) {
> +				print_scrub_dev(&di_args[i], NULL, print_raw,
> +				                NULL, NULL);
> +				continue;
> +			}
> +			print_scrub_dev(&di_args[i], &last_scrub->p, print_raw,
> +				        last_scrub->stats.finished ?
> +			                "history" : "status",
> +			                &last_scrub->stats);
> +		}
> +	} else {
> +		init_fs_stat(&fs_stat);
> +		for (i = 0; i < fi_args.num_devices; ++i) {
> +			last_scrub = last_dev_scrub(past_scrubs,
> +			                            di_args[i].devid);
> +			if (!last_scrub)
> +				continue;
> +			add_to_fs_stat(&last_scrub->p, &last_scrub->stats,
> +			               &fs_stat);
> +		}
> +		print_fs_stat(&fs_stat, print_raw);
> +	}
> +
> +out:
> +	free_history(past_scrubs);
> +	free(di_args);
> +	close(fdmnt);
> +	if (fdres > -1)
> +		close(fdres);
> +
> +	return err;
> +}

   Hugo.

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- There is no dark side to the Moon, really. As a matter of ---    
                          fact,  it's all dark.                          

--64LDleNqNegJ4g97
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOG2EDIKyzvlFcI40RArt6AJ4wPtucpNKpRjB6oN4b1ERm7qARRgCfQcJa
bX9Y5vlHpkeCuV2/cR/MKak=
=bB2E
-----END PGP SIGNATURE-----

--64LDleNqNegJ4g97--
