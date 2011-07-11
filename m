From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Mon, 11 Jul 2011 16:29:24 +0200
Message-ID: <4E1B08C4.8070000@jan-o-sch.net>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net> <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net> <20110710182300.GI4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110710182300.GI4325@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 10.07.2011 20:23, Hugo Mills wrote:
>    Yes, this is over three months after the initial posting, but since
> nobody else has looked at it yet, and the patch is in my integration
> stack...

... thanks!

>    I've not reviewed the whole thing -- just the "scrub start" code so
> far. I've removed the bits I've not checked from the file below.

I rebased the old branch I found to your current integration branch and
fixed up a most of what you mentioned. I'll not send a new version out
until after your complete review (or your statement that this is it or
your statement that you would rather going on reviewing the revised
version).

Things I ripped out are accepted and corrected without resistance.
Comments follow.

> On Wed, Mar 30, 2011 at 06:53:12PM +0200, Jan Schmidt wrote:
> 
>    No commit message at all?

Didn't know what to put there. Cover letter says it all. And as
mentioned, this is the initial implementation.

>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>> ---
>>  scrub.c | 1568 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 1568 insertions(+), 0 deletions(-)
> 
>    This is quite big to review in one lump... Is it possible to split
> the patch into functional sections? (Add shared infrastructure, then
> each of the four functions separately, maybe?)

Thought about that, but it doesn't make sense to me. It is the initial
implementation. A lot of the code is shared, thus adding one lump and
patching the patch with four small additional commits wouldn't help much.

>> diff --git a/scrub.c b/scrub.c
>> new file mode 100644
>> index 0000000..22052ed
>> --- /dev/null
>> +++ b/scrub.c
>> +#define SCRUB_DATA_FILE "/var/btrfs/scrub.status"
>> +#define SCRUB_PROGRESS_SOCKET_PATH "/var/btrfs/scrub.progress"
> 
>    I'd suggest /var/lib/btrfs/[...] instead. Putting it in the top
> level of /var seems a bit presumptuous (and contravenes the FHS).

I wasn't sure if I can expect /var/lib to be present anywhere btrfs
could run. But I changed it to what you suggested.

>> +	printf("\ttotal bytes scrubbed: %s with %llu errors\n",
>> +		pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
>> +		max(err_cnt, err_cnt2));
> 
>    Memory leak: pretty_sizes() mallocs space for its result.

Pah... In a user space function of a run-once utility right before it
exits. But I fixed that one, just to please you :-)

>> +static void init_fs_stat(struct scrub_fs_stat *fs_stat)
>> +{
>> +	memset(fs_stat, 0, sizeof(*fs_stat));
>> +	fs_stat->s.finished = 2;
> 
>    What does 2 mean? ->s.finished seems to be a boolean everywhere
> except here. Can you turn this value into a more descriptive #define?
> Or just use 1?

Good question. I guess I once wanted to distinguish really finished
scrub runs from not-even-started ones. I changed it to 1 (which makes it
much more likely we'll need that distinction quite soon).

>> +static int cancel_fd = -1;
>> +static void scrub_sigint_record_progress(int signal)
> 
>    What does this function have to do with recording progress? Seems a
> bit of a misnomer to me. (Call it scrub_sigint_cancel_scrub, maybe?)

I added a comment and left the name unchanged.

>> +{
>> +	ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
>> +}
>> +
>> +static int scrub_handle_sigint_parent(void)
>> +{
>> +	struct sigaction sa = {
>> +		.sa_handler = SIG_IGN,
>> +		.sa_flags = SA_RESTART,
>> +	};
>> +
>> +	return sigaction(SIGINT, &sa, NULL);
>> +}
>> +
>> +static int scrub_handle_sigint_child(int fd)
>> +{
>> +	struct sigaction sa = {
>> +		.sa_handler = fd == -1 ? SIG_DFL : scrub_sigint_record_progress,
>> +	};
>> +
>> +	cancel_fd = fd;
>> +	return sigaction(SIGINT, &sa, NULL);
>> +}
>> +
>> +static int _scrub_datafile(const char *fn_base, const char *fn_local,
>> +                           const char *fn_tmp, char *datafile, int max)
>> +{
>> +	int ret;
>> +
>> +	strncpy(datafile, fn_base, max);
> 
>    You need to put a zero byte at datafile[max], otherwise it could be
> unterminated (if max <= strlen(fn_base)), and the strlen will then run
> off the end of the string.

Damn. strncpy is a mess. I want strlcpy.

I Modified the code another way. I rather return an error than throwing
away bytes and continue happily.

strncpy third arg always - 1, thus we always have a 0 byte at the end of
the buffer. I then compare strlen to the buffer size.

>> +	ret = strlen(datafile);
>> +	
>> +	if (ret + 1 >= max)
>> +		return -EOVERFLOW;
> 
>    This will never happen (if you put the zero terminator in)
> 
>> +	datafile[ret] = '.';
>> +	strncpy(datafile+ret+1, fn_local, max-ret-1);
> 
>    ... and add a zero byte here, too (or use strncat)
> 
>> +	ret = strlen(datafile);
>> +
>> +	if (ret + 1 >= max)
>> +		return -EOVERFLOW;
> 
>    as above: won't happen
> 
>> +	if (fn_tmp) {
>> +		datafile[ret] = '_';
>> +		strncpy(datafile+ret+1, fn_tmp, max-ret-1);
> 
>    ... and add a zero byte here (or use strncat)
> 
>> +		ret = strlen(datafile);
>> +
>> +		if (ret >= max)
>> +			return -EOVERFLOW;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int _scrub_open_file(const char *datafile, int m)
> 
>    Just a niggle: Why the leading _ when other scrub-specific
> functions don't have it? (There's about a dozen other such symbols --
> was there a criterion you used to decide which ones have _ and which
> don't?)

Looking at the function names today, I think the criterion was
"everything i/o based get's a _", which is rubbish. I dropped all the '_'s.

>> +static struct scrub_file_record **scrub_read_file(int fd, int report_errors)
>> +{
>> +	int avail = 0;
>> +	int old_avail = 0;
>> +	char l[512];
>> +	int state = 0;
>> +	int curr = -1;
>> +	int i = 0;
>> +	int j;
>> +	int ret;
>> +	int eof = 0;
>> +	int lineno = 0;
>> +	u64 version;
>> +	char empty_uuid[BTRFS_FSID_SIZE] = {0};
>> +	struct scrub_file_record **p = NULL;
>> +
>> +	if (fd < 0)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +again:
>> +	old_avail = avail-i;
>> +	BUG_ON(old_avail < 0);
>> +	if (old_avail)
>> +		memmove(l, l+i, old_avail);
>> +	avail = read(fd, l+old_avail, sizeof(l)-old_avail);
>> +	if (avail == 0) {
>> +		eof = 1;
>> +	}
>> +	if (avail + old_avail == 0) {
>> +		if (curr >= 0 &&
>> +		    memcmp(p[curr]->fsid, empty_uuid, BTRFS_FSID_SIZE) == 0) {
>> +			p[curr] = NULL;
>> +		} else if (curr == -1) {
>> +			p = ERR_PTR(-ENODATA);
>> +		}
>> +		return p;
>> +	}
>> +	if (avail == -1)
>> +		return ERR_PTR(-errno);
> 
>    If avail == -1 (i.e. the read failed) and old_avail == 1
> (i.e. there was only one character left in the buffer), then that
> triggers the code in the previous if statement (avail+old_avail == 0)
> as well.
> 
>> +	avail += old_avail;
>> +
>> +	i = 0;
>> +	while (i < avail) {
>> +		switch (state) {
>> +		case 0: /* start if file */
>                          of
> 
>> +			ret = _scrub_kvread(&i,
>> +				sizeof(SCRUB_FILE_VERSION_PREFIX)-1, avail, l,
> 
>    [1] Drop the colon from SCRUB_FILE_VERSION_PREFIX and leave out the
> -1 here.
> 
>> +				SCRUB_FILE_VERSION_PREFIX, &version);
>> +			if (ret != 1)
>> +				_SCRUB_ILLEGAL;
>> +			if (version != atoll(SCRUB_FILE_VERSION))
>> +				return ERR_PTR(-ENOTSUP);
>> +			state = 6;
>> +			continue;
>> +		case 1: /* start of line, alloc */
>> +			if (!eof && !memchr(l+i, '\n', avail-i))
>> +				goto again;
> 
>    This will cause problems (an infinite loop), I think, if there's an
> input line greater than 512 bytes in length -- you can't find a line
> ending, so you go back to "again", read in zero bytes because you've
> not consumed anything in your buffer, and come back here to discover
> that there's no line ending...

No, it will complain about a too long line. We go to "again", read 0
characters (which is fine, returns 0), then set the eof flag (which is
kind of a bug) and stop processing. I.e., whenever we encounter a line
longer than sizeof(l), we tell this fact to the user and stop processing
for that file completely.

I increased that buffer to 16k, which sounds big enough for quite some
file format extensions.

>> +			++lineno;
>> +			if (curr > -1 && memcmp(p[curr]->fsid, empty_uuid,
>> +			                        BTRFS_FSID_SIZE) == 0) {
>> +				state = 2;
>> +				continue;
>> +			}
>> +			++curr;
>> +			p = realloc(p, (curr+2)*sizeof(*p));
>> +			if (p)
>> +				p[curr] = malloc(sizeof(**p));
>> +			if (!p || !p[curr])
>> +				return ERR_PTR(-errno);
>> +			memset(p[curr], 0, sizeof(**p));
>> +			p[curr+1] = NULL;
>> +			++state;
> 
>    You probably need a comment here (and below, as appropriate) to
> indicate that the lack of a continue or break is intended, and not a
> bug.
> 
>> +		case 2: /* start of line, skip space */
>> +			while (isspace(l[i]) && i<avail) {
>> +				if (l[i] == '\n')
>> +					++lineno;
>> +				++i;
>> +			}
>> +			if (i >= avail || (!eof && !memchr(l+i, '\n', avail-i)))
>> +				goto again;
>> +			++state;
>> +		case 3: /* read fsid */
>> +			if (i == avail)
>> +				continue;
>> +			for (j=0; l[i+j] != ':' && i+j < avail; ++j)
>> +				;
>> +			if (i+j+1 >= avail)
>> +				_SCRUB_ILLEGAL;
> 
>    Possibly a comment needed here to indicate that state 1 guarantees
> a full line of text in the buffer, so hitting the end of the buffer
> here is a fatal error. (It took me a while to work out why this case
> was always an error).

Comment added in "case 1", instead, because this holds true for each
_SCRUB_INVALID (let's call it invalid) in this block.

>> +			if (j != 36)
>> +				_SCRUB_ILLEGAL;
>> +			l[i+j] = '\0';
>> +			ret = uuid_parse(l+i, p[curr]->fsid);
>> +			if (ret)
>> +				_SCRUB_ILLEGAL;
>> +			i += j + 1;
>> +			++state;
>> +		case 4: /* read dev id */
>> +			for (j=0; isdigit(l[i+j]) && i+j < avail; ++j)
>> +				;
>> +			if (!j || i+j+1 >= avail)
> 
>    j == 0 is clearer than !j here, IMO
> 
>> +				_SCRUB_ILLEGAL;
>> +			p[curr]->devid = atoll(&l[i]);
>> +			i += j + 1;
> 
>    Is there any reason that you couldn't just use strtoull here? We
> know that the string is terminated with a \n (by the guarantee of
> state 1), so strtoull will always finish within the buffer.

I just found it way easier to use atoll. We already know the first
character really is a digit, so why bother with a more cumbersome function?

>> +			++state;
>> +		case 5: /* read key/value pair */
>> +			ret = _SCRUB_KVREAD(&i, data_extents_scrubbed, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, data_extents_scrubbed, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, tree_extents_scrubbed, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, data_bytes_scrubbed, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, tree_bytes_scrubbed, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, read_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, csum_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, verify_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, no_csum, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, csum_discards, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, super_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, malloc_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, uncorrectable_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, corrected_errors, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, last_physical, avail,
>> +			                    l, &p[curr]->p) ||
>> +			      _SCRUB_KVREAD(&i, finished, avail,
>> +			                    l, &p[curr]->stats) ||
>> +			      _SCRUB_KVREAD(&i, t_start, avail,
>> +			                    l, (u64*)&p[curr]->stats) ||
>> +			      _SCRUB_KVREAD(&i, t_resumed, avail,
>> +			                    l, (u64*)&p[curr]->stats) ||
>> +			      _SCRUB_KVREAD(&i, duration, avail,
>> +			                    l, (u64*)&p[curr]->stats) ||
>> +			      _SCRUB_KVREAD(&i, canceled, avail,
>> +			                    l, &p[curr]->stats);
>> +			if (ret != 1)
>> +				_SCRUB_ILLEGAL;
> 
>    If there's a syntax error in the parser (i.e. the matched key is
> not followed by a colon, or we run out of data), then _SCRUB_KVREAD
> returns -1, which is converted to 1 by the ||, and the error is
> dropped silently.

Oops. Fixed by defining 0 to be the success return value for
scrub_kvread (sounds better, anyway). The check then looks for ret != 0
instead.

>> +static int scrub_fs_info(int fd, char *path,
>> +                         struct btrfs_ioctl_fs_info_args *fi_args,
>> +                         struct btrfs_ioctl_dev_info_args **di_ret)
>> +{
>> +	int ret = 0;
>> +	int ndevs = 0;
>> +	int i = 1;
>> +	struct btrfs_fs_devices* fs_devices_mnt = NULL;
>> +	struct btrfs_ioctl_dev_info_args *di_args;
>> +	char mp[BTRFS_PATH_NAME_MAX+1];
>> +
>> +	memset(fi_args, 0, sizeof(*fi_args));
>> +
>> +	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
>> +	if (ret && errno == EINVAL) {
>> +		/* path is no mounted btrfs. try if it's a device */
>> +		ret = check_mounted_where(fd, path, mp, sizeof(mp),
>> +		                          &fs_devices_mnt);
>> +		if (!ret)
>> +			return -EINVAL;
>> +		fi_args->num_devices = 1;
> 
>    Is this a valid assumption? What happens if I pass just one device
> of a multi-device FS to "btrfs scrub start"?

You tell scrub to scrub that one device, then. At least for raid1, this
option makes sense.

>> +static int scrub_start(int argc, char **argv, int resume)
>> +{
>> +	int fdmnt;
>> +	int prg_fd = -1;
>> +	int fdres = -1;
>> +	int ret;
>> +	pid_t pid;
>> +	int c;
>> +	int i;
>> +	int err = 0;
> 
>    This clashes with the macro err(). OK, I know the compiler's clever
> enough to disambiguate, but it leads to nastiness like [2], below.

Okok. Macro is now ERR().

>> +	int print_raw = 0;
>> +	char *path;
>> +	int do_background = 1;
>> +	int do_wait = 0;
>> +	int do_print = 0;
>> +	int do_quiet = 0;
>> +	int do_record = 1;
>> +	int readonly = 0;
>> +	int do_stats_per_dev = 0;
>> +	int n_start = 0;
>> +	int n_skip = 0;
>> +	int n_resume = 0;
>> +	struct btrfs_ioctl_fs_info_args fi_args;
>> +	struct btrfs_ioctl_dev_info_args *di_args = NULL;
>> +	struct scrub_progress *sp = NULL;
>> +	struct scrub_fs_stat fs_stat;
>> +	struct timeval tv;
>> +	struct sockaddr_un addr = {
>> +		.sun_family = AF_UNIX,
>> +	};
>> +	pthread_t *t_devs = NULL;
>> +	pthread_t t_prog;
>> +	pthread_attr_t t_attr;
>> +	struct scrub_file_record **past_scrubs = NULL;
>> +	struct scrub_file_record *last_scrub = NULL;
>> +	char *datafile = strdup(SCRUB_DATA_FILE);
> 
>    This is never freed.
> 
>> +	char fsid[37];
> 
>    Magic number. is there a #define in libuuid for this value?

At least the man page of uuid_parse clearly states uuids have 36 bytes
plus a \0 in printf format. uuid/uuid.h doesn't contain such a constant.
But volumes.c, print-tree.c and others do it with 37, too.

>> +	char sock_path[BTRFS_PATH_NAME_MAX+1] = "";
>> +	struct scrub_progress_cycle spc;
>> +	pthread_mutex_t spc_write_mutex = PTHREAD_MUTEX_INITIALIZER;
>> +	void *terr;
>> +	u64 devid;
>> +
>> +	optind = 1;
>> +	while ((c = getopt(argc, argv, "BdqrR")) != -1) {
>> +		switch(c) {
>> +		case 'B':
>> +			do_background = 0;
>> +			do_wait = 1;
>> +			do_print = 1;
>> +			break;
>> +		case 'd':
>> +			do_stats_per_dev = 1;
>> +			break;
>> +		case 'q':
>> +			do_quiet = 1;
>> +			break;
>> +		case 'r':
>> +			readonly = 1;
>> +			break;
>> +		case 'R':
>> +			print_raw = 1;
>> +			break;
>> +		case '?':
>> +		default:
>> +			fprintf(stderr, "ERROR: scrub args invalid.\n"
>> +			                " -B  do not background (implies -W)\n"
> 
>    What's -W?

A development option that was removed before submitting v2 and is
removed for v3 now from that comment above as well.

>> +			                " -d  stats per device (-B only)\n"
>> +			                " -q  quiet\n"
>> +			                " -r  read only mode\n");
>> +			return 1;
>> +		}
>> +	}
>> +
>> +	/* try to catch most error cases before forking */
>> +
>> +	spc.progress = NULL;
>> +	if (do_quiet && do_print)
>> +		do_print = 0;
>> +
>> +	if (mkdir_p(datafile)) {
>> +		err(!do_quiet, "WARNING: cannot create scrub data "
>> +			       "file, mkdir %s failed: %s. Status recording "
>> +			       "disabled\n", datafile, strerror(errno));
>> +		do_record = 0;
>> +	}
>> +
>> +	path = argv[optind];
> 
>    No bounds check:
> 
> hrm@ruthven:btrfs-progs-unstable $ ./btrfs scrub start -B
> ERROR: can't access '(null)'
> 
>> +	fdmnt = open_file_or_dir(path);
>> +	if (fdmnt < 0) {
>> +		err(!do_quiet, "ERROR: can't access '%s'\n", path);
>> +		return 12;
>> +	}
>> +
>> +	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
>> +	if (ret) {
>> +		err(!do_quiet, "ERROR: getting dev info for scrub failed: "
>> +		    "%s\n", strerror(-ret));
>> +		err = 1;
>> +		goto out;
>> +	}
>> +	if (!fi_args.num_devices) {
>> +		err(!do_quiet, "ERROR: no devices found\n");
>> +		err = 1;
>> +		goto out;
>> +	}
>> +
>> +	uuid_unparse(fi_args.fsid, fsid);
>> +	fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
>> +	if (fdres < 0 && fdres != -ENOENT) {
>> +		err(!do_quiet, "WARNING: failed to open status file: "
>> +		    "%s\n", strerror(-fdres));
>> +	} else if (fdres >= 0) {
>> +		past_scrubs = scrub_read_file(fdres, !do_quiet);
>> +		if (IS_ERR(past_scrubs))
>> +			err(!do_quiet, "WARNING: failed to read status file: "
>> +			    "%s\n", strerror(-PTR_ERR(past_scrubs)));
>> +		close(fdres);
>> +	}
>> +
>> +	t_devs = malloc(fi_args.num_devices*sizeof(*t_devs));
>> +	sp = calloc(1, fi_args.num_devices*sizeof(*sp));
> 
>    Shouldn't that be calloc(fi_args.num_devices, sizeof(*sp)) ? (OK,
> it doesn't make any particular difference, but it just seems odd to
> keep a dog and bark yourself).

Sounds quite reasonable.

>> +	spc.progress = calloc(1, fi_args.num_devices*2*sizeof(*spc.progress));
> 
>    Woof! (And why do we need twice as many progress markers as devices?)

We need them for consistency reasons. Both are used alternately when
progress is recorded to make sure we never write a half baked record.

>> +	if (!t_devs || !sp || !spc.progress) {
>> +		err(!do_quiet, "ERROR: scrub failed: %s", strerror(errno));
>> +		err = 1;
> 
>    [2] Eugh. Calling what looks like a function, then assigning a
> value to it. Can you call the variable something else? (Or make the
> macro a more obvious macro: ERR() say?)
> 
>> +		goto out;
>> +	}
>> +
>> +	ret = pthread_attr_init(&t_attr);
>> +	if (ret) {
>> +		err(!do_quiet, "ERROR: pthread_attr_init failed: %s\n",
>> +		    strerror(ret));
>> +		err = 1;
>> +		goto out;
>> +	}
>> +
>> +	for (i = 0; i < fi_args.num_devices; ++i) {
>> +		devid = di_args[i].devid;
>> +		ret = pthread_mutex_init(&sp[i].progress_mutex, NULL);
>> +		if (ret) {
>> +			err(!do_quiet, "ERROR: pthread_mutex_init failed: "
>> +			    "%s\n", strerror(ret));
>> +			err = 1;
>> +			goto out;
>> +		}
>> +		last_scrub = last_dev_scrub(past_scrubs, devid);
>> +		sp[i].scrub_args.devid = devid;
>> +		sp[i].fd = fdmnt;
>> +		if (resume && last_scrub && (last_scrub->stats.canceled ||
>> +		                             !last_scrub->stats.finished)) {
>> +			++n_resume;
>> +			sp[i].scrub_args.start = last_scrub->p.last_physical;
>> +			sp[i].resumed = last_scrub;
>> +		} else if (resume) {
>> +			++n_skip;
>> +			sp[i].skip = 1;
>> +			sp[i].resumed = last_scrub;
>> +			continue;
>> +		} else {
>> +			++n_start;
>> +			sp[i].scrub_args.start = 0ll;
>> +			sp[i].resumed = NULL;
>> +		}
>> +		sp[i].skip = 0;
>> +		sp[i].scrub_args.end = (u64)-1ll;
>> +		sp[i].scrub_args.flags = readonly ? BTRFS_SCRUB_READONLY : 0;
>> +	}
>> +
>> +	if (!n_start && !n_resume) {
>> +		if (!do_quiet)
>> +			printf("scrub: nothing to resume for %s, fsid %s\n",
>> +			       path, fsid);
>> +		err = 0;
>> +		goto out;
>> +	}
>> +
>> +	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);
>> +	while (ret != -1) {
>> +		_scrub_datafile(SCRUB_PROGRESS_SOCKET_PATH, fsid,
>> +				NULL, sock_path, sizeof(sock_path));
>> +		/* ignore EOVERFLOW, as strncpy follows anyway */
> 
>    The name in sock_path could still be truncated on -EOVERFLOW,
> though. Is that always safe?

Yeah, no, that wasn't nice. It's changed now.

>> +		strncpy(addr.sun_path, sock_path,
>> +			sizeof(addr.sun_path)-1);
>> +		ret = bind(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
>> +		if (ret != -1 || errno != EADDRINUSE)
>> +			break;
> 
>    If we failed to bind because the address was in use, is there much
> point in trying to connect to the socket here?

Had to think about those lines for a moment, so I'll add a comment. It's
code that cares for an orphan socket file: try to connect, if that's
working, scrub must be running, so error out. If it doesn't, unlink the
file and loop.

>> +		ret = connect(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
>> +		if (!ret || errno != ECONNREFUSED) {
>> +			fprintf(stderr, "ERROR: scrub already running\n");
>> +			close(prg_fd);
>> +			goto out;
>> +		}
>> +		ret = unlink(sock_path);
> 
>    Under the right (wrong) set of circumstances, isn't this loop going
> to busy-wait?

In general, the loop can't execute more than twice.

If you manage to recreate that socket file in exactly the same moment
over and over again, that's possible, yes. But you would have to do that
externally on your own, this can't happen if you only use btrfs scrub.

>> +	}
>> +	if (ret != -1) {
>> +		ret = listen(prg_fd, 100);
>> +	}
>> +	if (ret == -1) {
>> +		err(!do_quiet, "WARNING: failed to open the progress status "
>> +		    "socket at %s: %s. Progress cannot be queried\n",
>> +		    sock_path[0] ? sock_path : SCRUB_PROGRESS_SOCKET_PATH,
>> +		    strerror(errno));
>> +		if (prg_fd != -1) {
>> +			close(prg_fd);
>> +			prg_fd = -1;
>> +			if (sock_path[0])
>> +				unlink(sock_path);
>> +		}
>> +	}
>> +
>> +	if (do_record) {
>> +		/* write all-zero progress file for a start */
>> +		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
>> +					   fi_args.num_devices);
> 
>    -HRM: Unchecked scrub_write_progress
> 
>> +		if (ret) {
>> +			err(!do_quiet, "WARNING: failed to write the progress "
>> +			    "status file: %s. Status recording disabled\n",
>> +			    strerror(-ret));
>> +			do_record = 0;
>> +		}
>> +	}
>> +
>> +	if (do_background) {
>> +		pid = fork();
>> +		if (pid == -1) {
>> +			err(!do_quiet, "ERROR: cannot scrub, fork failed: "
>> +			               "%s\n", strerror(errno));
>> +			err = 1;
>> +			goto out;
>> +		}
>> +
>> +		if (pid) {
>> +			int stat;
>> +			scrub_handle_sigint_parent();
>> +			if (!do_quiet)
>> +				printf("scrub %s on %s, fsid %s (pid=%d)\n",
>> +				       n_start ? "started" : "resumed",
>> +				       path, fsid, pid);
>> +			if (!do_wait) {
>> +				err = 0;
>> +				goto out;
>> +			}
>> +			ret = wait(&stat);
>> +			if (ret != pid) {
>> +				err(!do_quiet, "ERROR: wait failed: (ret=%d) "
>> +				    "%s\n", ret, strerror(errno));
>> +				err = 1;
>> +				goto out;
>> +			}
>> +			if (!WIFEXITED(stat) || WEXITSTATUS(stat)) {
>> +				err(!do_quiet, "ERROR: scrub process failed\n");
>> +				err = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
>> +				goto out;
>> +			}
>> +			err = 0;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	scrub_handle_sigint_child(fdmnt);
>> +
>> +	for (i = 0; i < fi_args.num_devices; ++i) {
>> +		if (sp[i].skip) {
>> +			sp[i].scrub_args.progress = sp[i].resumed->p;
>> +			sp[i].stats = sp[i].resumed->stats;
>> +			sp[i].ret = 0;
>> +			sp[i].stats.finished = 1;
>> +			continue;
>> +		}
>> +		devid = di_args[i].devid;
>> +		gettimeofday(&tv, NULL);
>> +		sp[i].stats.t_start = tv.tv_sec;
>> +		ret = pthread_create(&t_devs[i], &t_attr, scrub_one_dev,&sp[i]);
> 
>    -HRM not checked scrub_one_dev()
> 
>> +		if (ret) {
>> +			if (do_print)
>> +				fprintf(stderr, "ERROR: creating "
>> +				        "scrub_one_dev[%llu] thread failed: "
>> +				        "%s\n", devid, strerror(ret));
>> +			err = 1;
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	spc.fdmnt = fdmnt;
>> +	spc.prg_fd = prg_fd;
>> +	spc.do_record = do_record;
>> +	spc.write_mutex = &spc_write_mutex;
>> +	spc.shared_progress = sp;
>> +	spc.fi = &fi_args;
>> +	pthread_create(&t_prog, &t_attr, scrub_progress_cycle, &spc);
>> +
> 
>    -HRM: Not checked: scrub_progress_cycle()
> 
>> +	err = 0;
>> +	for (i = 0; i < fi_args.num_devices; ++i) {
>> +		if (sp[i].skip)
>> +			continue;
>> +		devid = di_args[i].devid;

HRM: mark1

>> +		ret = pthread_join(t_devs[i], NULL);
>> +		if (ret) {
>> +			if (do_print)
>> +				fprintf(stderr, "ERROR: pthread_join failed "
>> +				        "for scrub_one_dev[%llu]: %s\n", devid,
>> +			                strerror(ret));
>> +			err++;
>> +			continue;
>> +		}
>> +		if (sp[i].ret && sp[i].ioctl_errno == ENODEV) {
>> +			if (do_print)
>> +				fprintf(stderr, "WARNING: device %lld not "
>> +				        "present\n", devid);
>> +			continue;
>> +		}
>> +		if (sp[i].ret && sp[i].ioctl_errno == ECANCELED) {
>> +			err++;
>> +		} else if (sp[i].ret) {
>> +			if (do_print)
>> +				fprintf(stderr, "ERROR: scrubbing %s failed "
>> +				        "for device id %lld (%s)\n", path,
>> +				        devid, strerror(sp[i].ioctl_errno));
>> +			err++;
>> +			continue;
>> +		}
>> +	}
>> +
>> +	if (do_print) {
>> +		const char *append = "done";
>> +		if (!do_stats_per_dev)
>> +			init_fs_stat(&fs_stat);
>> +		for (i = 0; i < fi_args.num_devices; ++i) {
>> +			if (do_stats_per_dev) {
>> +				print_scrub_dev(&di_args[i],
>> +				                &sp[i].scrub_args.progress,
>> +				                print_raw,
>> +				                sp[i].ret ? "canceled" : "done",
>> +				                &sp[i].stats);
>> +			} else {
>> +				if (sp[i].ret)
>> +					append = "canceled";
>> +				add_to_fs_stat(&sp[i].scrub_args.progress,
>> +						&sp[i].stats, &fs_stat);
>> +			}
>> +		}
>> +		if (!do_stats_per_dev) {
>> +			printf("scrub %s for %s\n", append, fsid);
>> +			print_fs_stat(&fs_stat, print_raw);
>> +		}
>> +	}
>> +
>> +	pthread_cancel(t_prog);
>> +	ret = pthread_join(t_prog, &terr);
> 
>    Does this need to happen before the output above? Is there a

No, it doesn't. Look at the line below the "mark1" mark above. (What a
sentence!) There we join all the worker threads and print their results.
After succeeding, all workers must be done, so the progress thread can't
do anything useful anymore.

> possible race between scrub_progress_cycle() and the stats gathering
> code here? (I've not looked at scrub_progress_cycle() in detail yet,
> so I don't know).

As I see it, no. In addition to the fact that there won't come any fresh
progress notification at this state, we have those progress fields twice
to ensure consistency together with the progress_mutex taken by
scrub_progress_cycle.

-Jan
