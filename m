From: Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Sun, 10 Jul 2011 19:23:00 +0100
Message-ID: <20110710182300.GI4325@carfax.org.uk>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net>
 <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kH8JNVvasRCCW1Oz"
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>


--kH8JNVvasRCCW1Oz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

   Yes, this is over three months after the initial posting, but since
nobody else has looked at it yet, and the patch is in my integration
stack...

   I've not reviewed the whole thing -- just the "scrub start" code so
far. I've removed the bits I've not checked from the file below.

On Wed, Mar 30, 2011 at 06:53:12PM +0200, Jan Schmidt wrote:

   No commit message at all?

> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> ---
>  scrub.c | 1568 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1568 insertions(+), 0 deletions(-)

   This is quite big to review in one lump... Is it possible to split
the patch into functional sections? (Add shared infrastructure, then
each of the four functions separately, maybe?)

> diff --git a/scrub.c b/scrub.c
> new file mode 100644
> index 0000000..22052ed
> --- /dev/null
> +++ b/scrub.c
> @@ -0,0 +1,1568 @@

   It seems to be conventional to put a GPL notice at the top of
source files... :)

> +
> +#include <sys/ioctl.h>
> +#include <sys/wait.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +#include <sys/un.h>
> +#include <poll.h>
> +#include <sys/file.h>
> +#include <uuid/uuid.h>
> +#include <fcntl.h>
> +#include <unistd.h>
> +#include <pthread.h>
> +#include <ctype.h>
> +#include <signal.h>
> +#include <stdarg.h>
> +
> +#include "ctree.h"
> +#include "ioctl.h"
> +#include "btrfs_cmds.h"
> +#include "utils.h"
> +#include "volumes.h"
> +#include "disk-io.h"
> +
> +#define SCRUB_DATA_FILE "/var/btrfs/scrub.status"
> +#define SCRUB_PROGRESS_SOCKET_PATH "/var/btrfs/scrub.progress"

   I'd suggest /var/lib/btrfs/[...] instead. Putting it in the top
level of /var seems a bit presumptuous (and contravenes the FHS).

> +#define SCRUB_FILE_VERSION_PREFIX "scrub status:"

   I'd drop the : from this, since there's no colons used in other key
names elsewhere (in scrub_read_file() and _scrub_kvread()), and the
correction for the colon at [1] is confusing.

> +#define SCRUB_FILE_VERSION "1"
> +
> +struct scrub_stats {
> +	time_t t_start;
> +	time_t t_resumed;
> +	u64 duration;
> +	u64 finished;
> +	u64 canceled;
> +};
> +
> +struct scrub_progress {
> +	struct btrfs_ioctl_scrub_args scrub_args;
> +	int fd;
> +	int ret;
> +	int skip;
> +	struct scrub_stats stats;
> +	struct scrub_file_record *resumed;
> +	int ioctl_errno;
> +	pthread_mutex_t progress_mutex;
> +};
> +
> +struct scrub_file_record {
> +	u8 fsid[BTRFS_FSID_SIZE];
> +	u64 devid;
> +	struct scrub_stats stats;
> +	struct btrfs_scrub_progress p;
> +};
> +
> +struct scrub_progress_cycle {
> +	int fdmnt;
> +	int prg_fd;
> +	int do_record;
> +	struct btrfs_ioctl_fs_info_args *fi;
> +	struct scrub_progress *progress;
> +	struct scrub_progress *shared_progress;
> +	pthread_mutex_t *write_mutex;
> +};
> +
> +struct scrub_fs_stat {
> +	struct btrfs_scrub_progress p;
> +	struct scrub_stats s;
> +	int i;
> +};
> +
> +static void print_scrub_full(struct btrfs_scrub_progress *sp)
> +{
> +	printf("\tdata_extents_scrubbed: %lld\n", sp->data_extents_scrubbed);
> +	printf("\ttree_extents_scrubbed: %lld\n", sp->tree_extents_scrubbed);
> +	printf("\tdata_bytes_scrubbed: %lld\n", sp->data_bytes_scrubbed);
> +	printf("\ttree_bytes_scrubbed: %lld\n", sp->tree_bytes_scrubbed);
> +	printf("\tread_errors: %lld\n", sp->read_errors);
> +	printf("\tcsum_errors: %lld\n", sp->csum_errors);
> +	printf("\tverify_errors: %lld\n", sp->verify_errors);
> +	printf("\tno_csum: %lld\n", sp->no_csum);
> +	printf("\tcsum_discards: %lld\n", sp->csum_discards);
> +	printf("\tsuper_errors: %lld\n", sp->super_errors);
> +	printf("\tmalloc_errors: %lld\n", sp->malloc_errors);
> +	printf("\tuncorrectable_errors: %lld\n", sp->uncorrectable_errors);
> +	printf("\tcorrected_errors: %lld\n", sp->corrected_errors);
> +	printf("\tlast_physical: %lld\n", sp->last_physical);
> +}
> +
> +#define err(test, ...) do {			\
> +	if (test)				\
> +		fprintf(stderr, __VA_ARGS__);	\
> +} while (0)
> +
> +#define PRINT_SCRUB_ERROR(test, desc) do {	\
> +	if (test)				\
> +		printf(" %s=%llu", desc, test);	\
> +} while (0)

   Extra line of space here, otherwise it looks like the function is
part of the macro. (And in a number of other places throughout the
file, too)

> +static void print_scrub_summary(struct btrfs_scrub_progress *p)
> +{
> +	u64 err_cnt;
> +	u64 err_cnt2;
> +
> +	err_cnt = p->read_errors +
> +			p->csum_errors +
> +			p->verify_errors +
> +			p->csum_discards +
> +			p->super_errors +
> +			p->malloc_errors;
> +
> +	err_cnt2 = p->corrected_errors + p->uncorrectable_errors;
> +
> +	printf("\ttotal bytes scrubbed: %s with %llu errors\n",
> +		pretty_sizes(p->data_bytes_scrubbed + p->tree_bytes_scrubbed),
> +		max(err_cnt, err_cnt2));

   Memory leak: pretty_sizes() mallocs space for its result.

> +	if (err_cnt || err_cnt2) {
> +		printf("\terror details:");
> +		PRINT_SCRUB_ERROR(p->read_errors, "read");
> +		PRINT_SCRUB_ERROR(p->super_errors, "super");
> +		PRINT_SCRUB_ERROR(p->malloc_errors, "malloc");
> +		PRINT_SCRUB_ERROR(p->verify_errors, "verify");
> +		PRINT_SCRUB_ERROR(p->csum_errors, "csum");
> +		PRINT_SCRUB_ERROR(p->csum_discards, "csum-discards");
> +		printf("\n");
> +		printf("\tcorrected errors: %llu, uncorrectable errors: %llu\n",
> +		       p->corrected_errors, p->uncorrectable_errors);
> +	}
> +}
> +
> +#define _SCRUB_FS_STAT(p, name, fs_stat) fs_stat->p.name += p->name

   checkpatch.pl says:
scrub.c:130: ERROR: Macros with complex values should be enclosed in parenthesis

(and in general, checkpatch.pl is whinging about lots of whitespace/
indentation issues with this file)

> +#define _SCRUB_FS_STAT_MIN(ss, name, fs_stat)	\
> +do {						\
> +	if (fs_stat->s.name > ss->name) {	\
> +		fs_stat->s.name = ss->name;	\
> +	}					\
> +} while (0)
> +#define _SCRUB_FS_STAT_ZMIN(ss, name, fs_stat)			\
> +do {								\
> +	if (!fs_stat->s.name || fs_stat->s.name > ss->name) {	\
> +		fs_stat->s.name = ss->name;			\
> +	}							\
> +} while (0)
> +#define _SCRUB_FS_STAT_MAX(ss, name, fs_stat)			\

   Maybe use _SCRUB_FS_STAT_ZMAX to match the ZMIN usage above?

> +do {								\
> +	if (!fs_stat->s.name || fs_stat->s.name < ss->name) {	\
> +		fs_stat->s.name = ss->name;			\
> +	}							\
> +} while (0)

   Line of space needed here.

> +static void add_to_fs_stat(struct btrfs_scrub_progress *p,
> +                           struct scrub_stats *ss,
> +                           struct scrub_fs_stat *fs_stat)
> +{
> +	_SCRUB_FS_STAT(p, data_extents_scrubbed, fs_stat);
> +	_SCRUB_FS_STAT(p, tree_extents_scrubbed, fs_stat);
> +	_SCRUB_FS_STAT(p, data_bytes_scrubbed, fs_stat);
> +	_SCRUB_FS_STAT(p, tree_bytes_scrubbed, fs_stat);
> +	_SCRUB_FS_STAT(p, read_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, csum_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, verify_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, no_csum, fs_stat);
> +	_SCRUB_FS_STAT(p, csum_discards, fs_stat);
> +	_SCRUB_FS_STAT(p, super_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, malloc_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, uncorrectable_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, corrected_errors, fs_stat);
> +	_SCRUB_FS_STAT(p, last_physical, fs_stat);
> +	_SCRUB_FS_STAT_ZMIN(ss, t_start, fs_stat);
> +	_SCRUB_FS_STAT_ZMIN(ss, t_resumed, fs_stat);
> +	_SCRUB_FS_STAT_MAX(ss, duration, fs_stat);
> +	_SCRUB_FS_STAT_MAX(ss, canceled, fs_stat);
> +	_SCRUB_FS_STAT_MIN(ss, finished, fs_stat);
> +}
> +
> +static void init_fs_stat(struct scrub_fs_stat *fs_stat)
> +{
> +	memset(fs_stat, 0, sizeof(*fs_stat));
> +	fs_stat->s.finished = 2;

   What does 2 mean? ->s.finished seems to be a boolean everywhere
except here. Can you turn this value into a more descriptive #define?
Or just use 1?

> +}
> +
> +static void _print_scrub_ss(struct scrub_stats *ss)
> +{
> +	char t[BTRFS_PATH_NAME_MAX+1];

   Since this string is used for storing formatted dates, there's a
little cognitive dissonance over it being long enough to store a btrfs
path name... (Yeah, OK, it's a convenient large value, but still a tad
confusing to use it here)

> +	struct tm tm;
> +
> +	if (!ss || !ss->t_start) {
> +		printf("\tno stats available\n");
> +		return;
> +	}
> +	if (ss->t_resumed) {
> +		localtime_r(&ss->t_resumed, &tm);
> +		strftime(t, sizeof(t), "%c", &tm);

   strftime doesn't append a terminating zero if the string is longer
than the buffer it's filling.

> +		printf("\tscrub resumed at %s", t);
> +	} else {
> +		localtime_r(&ss->t_start, &tm);
> +		strftime(t, sizeof(t), "%c", &tm);
> +		printf("\tscrub started at %s", t);
> +	}
> +	if (ss->finished && !ss->canceled) {
> +		printf(" and finished after %llu seconds\n",
> +		       ss->duration);
> +	} else if (ss->canceled) {
> +		printf(" and was aborted after %llu seconds\n",
> +		       ss->duration);
> +	} else {
> +		printf(", running for %llu seconds\n", ss->duration);
> +	}
> +}
> +
> +static void print_scrub_dev(struct btrfs_ioctl_dev_info_args *di,
> +                            struct btrfs_scrub_progress *p, int raw,
> +                            const char *append, struct scrub_stats *ss)
> +{
> +	printf("scrub device %s (id %llu) %s\n", di->path, di->devid,
> +	       append ? append : "");
> +
> +	_print_scrub_ss(ss);
> +
> +	if (p) {
> +		if (raw)
> +			print_scrub_full(p);
> +		else
> +			print_scrub_summary(p);
> +	}
> +}
> +
> +static void print_fs_stat(struct scrub_fs_stat *fs_stat, int raw)
> +{
> +	_print_scrub_ss(&fs_stat->s);
> +
> +	if (raw)
> +		print_scrub_full(&fs_stat->p);
> +	else
> +		print_scrub_summary(&fs_stat->p);
> +}
> +
> +static void free_history(struct scrub_file_record **last_scrubs)
> +{
> +	struct scrub_file_record **l = last_scrubs;
> +	if (!l)
> +		return;
> +	while (*l)
> +		free(*l++);
> +	free(last_scrubs);
> +}
> +
> +static int cancel_fd = -1;
> +static void scrub_sigint_record_progress(int signal)

   What does this function have to do with recording progress? Seems a
bit of a misnomer to me. (Call it scrub_sigint_cancel_scrub, maybe?)

> +{
> +	ioctl(cancel_fd, BTRFS_IOC_SCRUB_CANCEL, NULL);
> +}
> +
> +static int scrub_handle_sigint_parent(void)
> +{
> +	struct sigaction sa = {
> +		.sa_handler = SIG_IGN,
> +		.sa_flags = SA_RESTART,
> +	};
> +
> +	return sigaction(SIGINT, &sa, NULL);
> +}
> +
> +static int scrub_handle_sigint_child(int fd)
> +{
> +	struct sigaction sa = {
> +		.sa_handler = fd == -1 ? SIG_DFL : scrub_sigint_record_progress,
> +	};
> +
> +	cancel_fd = fd;
> +	return sigaction(SIGINT, &sa, NULL);
> +}
> +
> +static int _scrub_datafile(const char *fn_base, const char *fn_local,
> +                           const char *fn_tmp, char *datafile, int max)
> +{
> +	int ret;
> +
> +	strncpy(datafile, fn_base, max);

   You need to put a zero byte at datafile[max], otherwise it could be
unterminated (if max <= strlen(fn_base)), and the strlen will then run
off the end of the string.

> +	ret = strlen(datafile);
> +	
> +	if (ret + 1 >= max)
> +		return -EOVERFLOW;

   This will never happen (if you put the zero terminator in)

> +	datafile[ret] = '.';
> +	strncpy(datafile+ret+1, fn_local, max-ret-1);

   ... and add a zero byte here, too (or use strncat)

> +	ret = strlen(datafile);
> +
> +	if (ret + 1 >= max)
> +		return -EOVERFLOW;

   as above: won't happen

> +	if (fn_tmp) {
> +		datafile[ret] = '_';
> +		strncpy(datafile+ret+1, fn_tmp, max-ret-1);

   ... and add a zero byte here (or use strncat)

> +		ret = strlen(datafile);
> +
> +		if (ret >= max)
> +			return -EOVERFLOW;
> +	}
> +
> +	return 0;
> +}
> +
> +static int _scrub_open_file(const char *datafile, int m)

   Just a niggle: Why the leading _ when other scrub-specific
functions don't have it? (There's about a dozen other such symbols --
was there a criterion you used to decide which ones have _ and which
don't?)

> +{
> +	int fd;
> +	int ret;
> +
> +	fd = open(datafile, m, 0600);
> +	if (fd < 0)
> +		return -errno;
> +
> +	ret = flock(fd, LOCK_EX|LOCK_NB);
> +	if (ret) {
> +		ret = errno;
> +		close(fd);
> +		return -ret;
> +	}
> +
> +	return fd;
> +}
> +
> +static int scrub_open_file_r(const char *fn_base, const char *fn_local)
> +{
> +	int ret;
> +	char datafile[BTRFS_PATH_NAME_MAX+1];
> +	ret = _scrub_datafile(fn_base, fn_local, NULL,
> +	                      datafile, sizeof(datafile));
> +	if (ret < 0)
> +		return ret;
> +	return _scrub_open_file(datafile, O_RDONLY);
> +}
> +
> +static int scrub_open_file_w(const char *fn_base, const char *fn_local,
> +                             const char *tmp)
> +{
> +	int ret;
> +	char datafile[BTRFS_PATH_NAME_MAX+1];
> +	ret = _scrub_datafile(fn_base, fn_local, tmp,
> +	                      datafile, sizeof(datafile));
> +	if (ret < 0)
> +		return ret;
> +	return _scrub_open_file(datafile, O_WRONLY|O_CREAT);
> +}
> +
> +static int scrub_rename_file(const char *fn_base, const char *fn_local,
> +                             const char *tmp)
> +{
> +	int ret;
> +	char datafile_old[BTRFS_PATH_NAME_MAX+1];
> +	char datafile_new[BTRFS_PATH_NAME_MAX+1];
> +	ret = _scrub_datafile(fn_base, fn_local, tmp,
> +	                      datafile_old, sizeof(datafile_old));
> +	if (ret < 0)
> +		return ret;
> +	ret = _scrub_datafile(fn_base, fn_local, NULL,
> +	                      datafile_new, sizeof(datafile_new));
> +	if (ret < 0)
> +		return ret;
> +	ret = rename(datafile_old, datafile_new);
> +	return ret ? -errno : 0;
> +}
> +
> +#define _SCRUB_KVREAD(i, name, avail, l, dest) \
> +	_scrub_kvread(i, sizeof(#name), avail, l, #name, dest.name)
> +#define _SCRUB_KVREAD_STATS(i, name, avail, l, dest) \
> +	_scrub_kvread(i, sizeof(#name), avail, l, #name, dest->stats.name)
> +/*
> + * returns 0 if the key did not match (nothing was read)
> + *         1 if the key did match (success)
> + *        -1 if the key did match and an error occured
> + */
> +static int _scrub_kvread(int *i, int len, int avail, const char *buf,
> +                         const char *key, u64 *dest)
> +{
> +	int j;
> +
> +	if (*i+len+1 < avail && strncmp(&buf[*i], key, len-1) == 0) {
> +		*i += len-1;
> +		if (buf[*i] != ':') {
> +			return -1;
> +		}
> +		*i += 1;
> +		for (j=0; isdigit(buf[*i+j]) && *i+j < avail; ++j)
> +			;
> +		if (*i+j >= avail)
> +			return -1;
> +		*dest = atoll(&buf[*i]);
> +		*i += j;
> +		return 1;
> +	}
> +	
> +	return 0;
> +}
> +
> +#define _SCRUB_ILLEGAL do {						\

   I'd better call the police, then... :) I think you mean invalid (or
unexpected, or unparsable), not illegal. (and likewise in the message,
below, of course).

> +	if (report_errors) {						\
> +		fprintf(stderr, "WARNING: illegal data in line %d pos "	\
> +		        "%d state %d (near \"%.*s\") at %s:%d\n",	\
> +		        lineno, i, state, 20 > avail ? avail : 20, l+i,	\
> +		        __FILE__, __LINE__);				\
> +	}								\
> +	goto skip;							\
> +} while (0)

   Extra line of space here

> +static struct scrub_file_record **scrub_read_file(int fd, int report_errors)
> +{
> +	int avail = 0;
> +	int old_avail = 0;
> +	char l[512];
> +	int state = 0;
> +	int curr = -1;
> +	int i = 0;
> +	int j;
> +	int ret;
> +	int eof = 0;
> +	int lineno = 0;
> +	u64 version;
> +	char empty_uuid[BTRFS_FSID_SIZE] = {0};
> +	struct scrub_file_record **p = NULL;
> +
> +	if (fd < 0)
> +		return ERR_PTR(-EINVAL);
> +
> +again:
> +	old_avail = avail-i;
> +	BUG_ON(old_avail < 0);
> +	if (old_avail)
> +		memmove(l, l+i, old_avail);
> +	avail = read(fd, l+old_avail, sizeof(l)-old_avail);
> +	if (avail == 0) {
> +		eof = 1;
> +	}
> +	if (avail + old_avail == 0) {
> +		if (curr >= 0 &&
> +		    memcmp(p[curr]->fsid, empty_uuid, BTRFS_FSID_SIZE) == 0) {
> +			p[curr] = NULL;
> +		} else if (curr == -1) {
> +			p = ERR_PTR(-ENODATA);
> +		}
> +		return p;
> +	}
> +	if (avail == -1)
> +		return ERR_PTR(-errno);

   If avail == -1 (i.e. the read failed) and old_avail == 1
(i.e. there was only one character left in the buffer), then that
triggers the code in the previous if statement (avail+old_avail == 0)
as well.

> +	avail += old_avail;
> +
> +	i = 0;
> +	while (i < avail) {
> +		switch (state) {
> +		case 0: /* start if file */
                         of

> +			ret = _scrub_kvread(&i,
> +				sizeof(SCRUB_FILE_VERSION_PREFIX)-1, avail, l,

   [1] Drop the colon from SCRUB_FILE_VERSION_PREFIX and leave out the
-1 here.

> +				SCRUB_FILE_VERSION_PREFIX, &version);
> +			if (ret != 1)
> +				_SCRUB_ILLEGAL;
> +			if (version != atoll(SCRUB_FILE_VERSION))
> +				return ERR_PTR(-ENOTSUP);
> +			state = 6;
> +			continue;
> +		case 1: /* start of line, alloc */
> +			if (!eof && !memchr(l+i, '\n', avail-i))
> +				goto again;

   This will cause problems (an infinite loop), I think, if there's an
input line greater than 512 bytes in length -- you can't find a line
ending, so you go back to "again", read in zero bytes because you've
not consumed anything in your buffer, and come back here to discover
that there's no line ending...

> +			++lineno;
> +			if (curr > -1 && memcmp(p[curr]->fsid, empty_uuid,
> +			                        BTRFS_FSID_SIZE) == 0) {
> +				state = 2;
> +				continue;
> +			}
> +			++curr;
> +			p = realloc(p, (curr+2)*sizeof(*p));
> +			if (p)
> +				p[curr] = malloc(sizeof(**p));
> +			if (!p || !p[curr])
> +				return ERR_PTR(-errno);
> +			memset(p[curr], 0, sizeof(**p));
> +			p[curr+1] = NULL;
> +			++state;

   You probably need a comment here (and below, as appropriate) to
indicate that the lack of a continue or break is intended, and not a
bug.

> +		case 2: /* start of line, skip space */
> +			while (isspace(l[i]) && i<avail) {
> +				if (l[i] == '\n')
> +					++lineno;
> +				++i;
> +			}
> +			if (i >= avail || (!eof && !memchr(l+i, '\n', avail-i)))
> +				goto again;
> +			++state;
> +		case 3: /* read fsid */
> +			if (i == avail)
> +				continue;
> +			for (j=0; l[i+j] != ':' && i+j < avail; ++j)
> +				;
> +			if (i+j+1 >= avail)
> +				_SCRUB_ILLEGAL;

   Possibly a comment needed here to indicate that state 1 guarantees
a full line of text in the buffer, so hitting the end of the buffer
here is a fatal error. (It took me a while to work out why this case
was always an error).

> +			if (j != 36)
> +				_SCRUB_ILLEGAL;
> +			l[i+j] = '\0';
> +			ret = uuid_parse(l+i, p[curr]->fsid);
> +			if (ret)
> +				_SCRUB_ILLEGAL;
> +			i += j + 1;
> +			++state;
> +		case 4: /* read dev id */
> +			for (j=0; isdigit(l[i+j]) && i+j < avail; ++j)
> +				;
> +			if (!j || i+j+1 >= avail)

   j == 0 is clearer than !j here, IMO

> +				_SCRUB_ILLEGAL;
> +			p[curr]->devid = atoll(&l[i]);
> +			i += j + 1;

   Is there any reason that you couldn't just use strtoull here? We
know that the string is terminated with a \n (by the guarantee of
state 1), so strtoull will always finish within the buffer.

> +			++state;
> +		case 5: /* read key/value pair */
> +			ret = _SCRUB_KVREAD(&i, data_extents_scrubbed, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, data_extents_scrubbed, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, tree_extents_scrubbed, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, data_bytes_scrubbed, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, tree_bytes_scrubbed, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, read_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, csum_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, verify_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, no_csum, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, csum_discards, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, super_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, malloc_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, uncorrectable_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, corrected_errors, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, last_physical, avail,
> +			                    l, &p[curr]->p) ||
> +			      _SCRUB_KVREAD(&i, finished, avail,
> +			                    l, &p[curr]->stats) ||
> +			      _SCRUB_KVREAD(&i, t_start, avail,
> +			                    l, (u64*)&p[curr]->stats) ||
> +			      _SCRUB_KVREAD(&i, t_resumed, avail,
> +			                    l, (u64*)&p[curr]->stats) ||
> +			      _SCRUB_KVREAD(&i, duration, avail,
> +			                    l, (u64*)&p[curr]->stats) ||
> +			      _SCRUB_KVREAD(&i, canceled, avail,
> +			                    l, &p[curr]->stats);
> +			if (ret != 1)
> +				_SCRUB_ILLEGAL;

   If there's a syntax error in the parser (i.e. the matched key is
not followed by a colon, or we run out of data), then _SCRUB_KVREAD
returns -1, which is converted to 1 by the ||, and the error is
dropped silently.

> +			++state;
> +		case 6: /* after number */
> +			if (l[i] == '|') {
> +				state = 5;
> +			} else if (l[i] == '\n') {
> +				state = 1;
> +			} else {
> +				_SCRUB_ILLEGAL;
> +			}
> +			++i;
> +			continue;
> +		case 99: /* skip rest of line */
> +skip:
> +			state = 99;
> +			do {
> +				++i;
> +				if (l[i-1] == '\n') {
> +					state = 1;
> +					break;
> +				}
> +			} while (i < avail);
> +			continue;
> +		}
> +		BUG();
> +	}
> +	goto again;
> +}
> +#undef _SCRUB_ILLEGAL

[...]

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

   If you leave out the colon from SCRUB_FILE_VERSION_PREFIX, then you
don't need the -1 here. You can add a literal colon in the middle of
the string concatenation between the prefix and the version number.

> +	                       + sizeof(SCRUB_FILE_VERSION)-1 + 1);
> +	if (ret)
> +		return -EOVERFLOW;
> +

[...]

> +static struct scrub_file_record *last_dev_scrub(
> +		struct scrub_file_record *const *const past_scrubs, u64 devid)
> +{
> +	int i;
> +
> +	if (!past_scrubs || IS_ERR(past_scrubs))
> +		return NULL;
> +
> +	for (i=0; past_scrubs[i]; ++i)
> +		if (past_scrubs[i]->devid == devid)
> +			return past_scrubs[i];
> +
> +	return NULL;
> +}
> +
> +static int scrub_device_info(int fd, u64 devid,
> +			     struct btrfs_ioctl_dev_info_args *di_args)
> +{
> +	int ret;
> +
> +	di_args->devid = devid;
> +	memset(&di_args->uuid, '\0', sizeof(di_args->uuid));
> +
> +	ret = ioctl(fd, BTRFS_IOC_DEV_INFO, di_args);
> +	return ret ? -errno : 0;
> +}
> +
> +static int scrub_fs_info(int fd, char *path,
> +                         struct btrfs_ioctl_fs_info_args *fi_args,
> +                         struct btrfs_ioctl_dev_info_args **di_ret)
> +{
> +	int ret = 0;
> +	int ndevs = 0;
> +	int i = 1;
> +	struct btrfs_fs_devices* fs_devices_mnt = NULL;
> +	struct btrfs_ioctl_dev_info_args *di_args;
> +	char mp[BTRFS_PATH_NAME_MAX+1];
> +
> +	memset(fi_args, 0, sizeof(*fi_args));
> +
> +	ret = ioctl(fd, BTRFS_IOC_FS_INFO, fi_args);
> +	if (ret && errno == EINVAL) {
> +		/* path is no mounted btrfs. try if it's a device */
> +		ret = check_mounted_where(fd, path, mp, sizeof(mp),
> +		                          &fs_devices_mnt);
> +		if (!ret)
> +			return -EINVAL;
> +		fi_args->num_devices = 1;

   Is this a valid assumption? What happens if I pass just one device
of a multi-device FS to "btrfs scrub start"?

> +		fi_args->max_id = fs_devices_mnt->latest_devid;
> +		i = fs_devices_mnt->latest_devid;
> +		memcpy(fi_args->fsid, fs_devices_mnt->fsid, BTRFS_FSID_SIZE);
> +		close(fd);
> +		fd = open_file_or_dir(mp);
> +		if (fd < 0)
> +			return -errno;
> +	} else if (ret) {
> +		return -errno;
> +	}
> +
> +	if (!fi_args->num_devices)
> +		return 0;
> +
> +	di_args = *di_ret = malloc(fi_args->num_devices*sizeof(*di_args));
> +	if (!di_args)
> +		return -errno;
> +
> +	for (; i<=fi_args->max_id; ++i) {
> +		BUG_ON(ndevs >= fi_args->num_devices);
> +		ret = scrub_device_info(fd, i, &di_args[ndevs]);
> +		if (ret == -ENODEV)
> +			continue;
> +		if (ret)
> +			return ret;
> +		++ndevs;
> +	}
> +
> +	BUG_ON(ndevs == 0);
> +
> +	return 0;
> +}
> +
> +int mkdir_p(char *path)
> +{
> +	int i;
> +	int ret;
> +
> +	for (i=1; i<strlen(path); ++i) {
> +		if (path[i] != '/')
> +			continue;
> +		path[i] = '\0';
> +		ret = mkdir(path, 0777);
> +		if (ret && errno != EEXIST)
> +			return 1;
> +		path[i] = '/';
> +	}
> +
> +	return 0;
> +}
> +
> +static int scrub_start(int argc, char **argv, int resume)
> +{
> +	int fdmnt;
> +	int prg_fd = -1;
> +	int fdres = -1;
> +	int ret;
> +	pid_t pid;
> +	int c;
> +	int i;
> +	int err = 0;

   This clashes with the macro err(). OK, I know the compiler's clever
enough to disambiguate, but it leads to nastiness like [2], below.

> +	int print_raw = 0;
> +	char *path;
> +	int do_background = 1;
> +	int do_wait = 0;
> +	int do_print = 0;
> +	int do_quiet = 0;
> +	int do_record = 1;
> +	int readonly = 0;
> +	int do_stats_per_dev = 0;
> +	int n_start = 0;
> +	int n_skip = 0;
> +	int n_resume = 0;
> +	struct btrfs_ioctl_fs_info_args fi_args;
> +	struct btrfs_ioctl_dev_info_args *di_args = NULL;
> +	struct scrub_progress *sp = NULL;
> +	struct scrub_fs_stat fs_stat;
> +	struct timeval tv;
> +	struct sockaddr_un addr = {
> +		.sun_family = AF_UNIX,
> +	};
> +	pthread_t *t_devs = NULL;
> +	pthread_t t_prog;
> +	pthread_attr_t t_attr;
> +	struct scrub_file_record **past_scrubs = NULL;
> +	struct scrub_file_record *last_scrub = NULL;
> +	char *datafile = strdup(SCRUB_DATA_FILE);

   This is never freed.

> +	char fsid[37];

   Magic number. is there a #define in libuuid for this value?

> +	char sock_path[BTRFS_PATH_NAME_MAX+1] = "";
> +	struct scrub_progress_cycle spc;
> +	pthread_mutex_t spc_write_mutex = PTHREAD_MUTEX_INITIALIZER;
> +	void *terr;
> +	u64 devid;
> +
> +	optind = 1;
> +	while ((c = getopt(argc, argv, "BdqrR")) != -1) {
> +		switch(c) {
> +		case 'B':
> +			do_background = 0;
> +			do_wait = 1;
> +			do_print = 1;
> +			break;
> +		case 'd':
> +			do_stats_per_dev = 1;
> +			break;
> +		case 'q':
> +			do_quiet = 1;
> +			break;
> +		case 'r':
> +			readonly = 1;
> +			break;
> +		case 'R':
> +			print_raw = 1;
> +			break;
> +		case '?':
> +		default:
> +			fprintf(stderr, "ERROR: scrub args invalid.\n"
> +			                " -B  do not background (implies -W)\n"

   What's -W?

> +			                " -d  stats per device (-B only)\n"
> +			                " -q  quiet\n"
> +			                " -r  read only mode\n");
> +			return 1;
> +		}
> +	}
> +
> +	/* try to catch most error cases before forking */
> +
> +	spc.progress = NULL;
> +	if (do_quiet && do_print)
> +		do_print = 0;
> +
> +	if (mkdir_p(datafile)) {
> +		err(!do_quiet, "WARNING: cannot create scrub data "
> +			       "file, mkdir %s failed: %s. Status recording "
> +			       "disabled\n", datafile, strerror(errno));
> +		do_record = 0;
> +	}
> +
> +	path = argv[optind];

   No bounds check:

hrm@ruthven:btrfs-progs-unstable $ ./btrfs scrub start -B
ERROR: can't access '(null)'

> +	fdmnt = open_file_or_dir(path);
> +	if (fdmnt < 0) {
> +		err(!do_quiet, "ERROR: can't access '%s'\n", path);
> +		return 12;
> +	}
> +
> +	ret = scrub_fs_info(fdmnt, path, &fi_args, &di_args);
> +	if (ret) {
> +		err(!do_quiet, "ERROR: getting dev info for scrub failed: "
> +		    "%s\n", strerror(-ret));
> +		err = 1;
> +		goto out;
> +	}
> +	if (!fi_args.num_devices) {
> +		err(!do_quiet, "ERROR: no devices found\n");
> +		err = 1;
> +		goto out;
> +	}
> +
> +	uuid_unparse(fi_args.fsid, fsid);
> +	fdres = scrub_open_file_r(SCRUB_DATA_FILE, fsid);
> +	if (fdres < 0 && fdres != -ENOENT) {
> +		err(!do_quiet, "WARNING: failed to open status file: "
> +		    "%s\n", strerror(-fdres));
> +	} else if (fdres >= 0) {
> +		past_scrubs = scrub_read_file(fdres, !do_quiet);
> +		if (IS_ERR(past_scrubs))
> +			err(!do_quiet, "WARNING: failed to read status file: "
> +			    "%s\n", strerror(-PTR_ERR(past_scrubs)));
> +		close(fdres);
> +	}
> +
> +	t_devs = malloc(fi_args.num_devices*sizeof(*t_devs));
> +	sp = calloc(1, fi_args.num_devices*sizeof(*sp));

   Shouldn't that be calloc(fi_args.num_devices, sizeof(*sp)) ? (OK,
it doesn't make any particular difference, but it just seems odd to
keep a dog and bark yourself).

> +	spc.progress = calloc(1, fi_args.num_devices*2*sizeof(*spc.progress));

   Woof! (And why do we need twice as many progress markers as devices?)

> +	if (!t_devs || !sp || !spc.progress) {
> +		err(!do_quiet, "ERROR: scrub failed: %s", strerror(errno));
> +		err = 1;

   [2] Eugh. Calling what looks like a function, then assigning a
value to it. Can you call the variable something else? (Or make the
macro a more obvious macro: ERR() say?)

> +		goto out;
> +	}
> +
> +	ret = pthread_attr_init(&t_attr);
> +	if (ret) {
> +		err(!do_quiet, "ERROR: pthread_attr_init failed: %s\n",
> +		    strerror(ret));
> +		err = 1;
> +		goto out;
> +	}
> +
> +	for (i = 0; i < fi_args.num_devices; ++i) {
> +		devid = di_args[i].devid;
> +		ret = pthread_mutex_init(&sp[i].progress_mutex, NULL);
> +		if (ret) {
> +			err(!do_quiet, "ERROR: pthread_mutex_init failed: "
> +			    "%s\n", strerror(ret));
> +			err = 1;
> +			goto out;
> +		}
> +		last_scrub = last_dev_scrub(past_scrubs, devid);
> +		sp[i].scrub_args.devid = devid;
> +		sp[i].fd = fdmnt;
> +		if (resume && last_scrub && (last_scrub->stats.canceled ||
> +		                             !last_scrub->stats.finished)) {
> +			++n_resume;
> +			sp[i].scrub_args.start = last_scrub->p.last_physical;
> +			sp[i].resumed = last_scrub;
> +		} else if (resume) {
> +			++n_skip;
> +			sp[i].skip = 1;
> +			sp[i].resumed = last_scrub;
> +			continue;
> +		} else {
> +			++n_start;
> +			sp[i].scrub_args.start = 0ll;
> +			sp[i].resumed = NULL;
> +		}
> +		sp[i].skip = 0;
> +		sp[i].scrub_args.end = (u64)-1ll;
> +		sp[i].scrub_args.flags = readonly ? BTRFS_SCRUB_READONLY : 0;
> +	}
> +
> +	if (!n_start && !n_resume) {
> +		if (!do_quiet)
> +			printf("scrub: nothing to resume for %s, fsid %s\n",
> +			       path, fsid);
> +		err = 0;
> +		goto out;
> +	}
> +
> +	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);
> +	while (ret != -1) {
> +		_scrub_datafile(SCRUB_PROGRESS_SOCKET_PATH, fsid,
> +				NULL, sock_path, sizeof(sock_path));
> +		/* ignore EOVERFLOW, as strncpy follows anyway */

   The name in sock_path could still be truncated on -EOVERFLOW,
though. Is that always safe?

> +		strncpy(addr.sun_path, sock_path,
> +			sizeof(addr.sun_path)-1);
> +		ret = bind(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
> +		if (ret != -1 || errno != EADDRINUSE)
> +			break;

   If we failed to bind because the address was in use, is there much
point in trying to connect to the socket here?

> +		ret = connect(prg_fd, (struct sockaddr *)&addr, sizeof(addr));
> +		if (!ret || errno != ECONNREFUSED) {
> +			fprintf(stderr, "ERROR: scrub already running\n");
> +			close(prg_fd);
> +			goto out;
> +		}
> +		ret = unlink(sock_path);

   Under the right (wrong) set of circumstances, isn't this loop going
to busy-wait?

> +	}
> +	if (ret != -1) {
> +		ret = listen(prg_fd, 100);
> +	}
> +	if (ret == -1) {
> +		err(!do_quiet, "WARNING: failed to open the progress status "
> +		    "socket at %s: %s. Progress cannot be queried\n",
> +		    sock_path[0] ? sock_path : SCRUB_PROGRESS_SOCKET_PATH,
> +		    strerror(errno));
> +		if (prg_fd != -1) {
> +			close(prg_fd);
> +			prg_fd = -1;
> +			if (sock_path[0])
> +				unlink(sock_path);
> +		}
> +	}
> +
> +	if (do_record) {
> +		/* write all-zero progress file for a start */
> +		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
> +					   fi_args.num_devices);

   -HRM: Unchecked scrub_write_progress

> +		if (ret) {
> +			err(!do_quiet, "WARNING: failed to write the progress "
> +			    "status file: %s. Status recording disabled\n",
> +			    strerror(-ret));
> +			do_record = 0;
> +		}
> +	}
> +
> +	if (do_background) {
> +		pid = fork();
> +		if (pid == -1) {
> +			err(!do_quiet, "ERROR: cannot scrub, fork failed: "
> +			               "%s\n", strerror(errno));
> +			err = 1;
> +			goto out;
> +		}
> +
> +		if (pid) {
> +			int stat;
> +			scrub_handle_sigint_parent();
> +			if (!do_quiet)
> +				printf("scrub %s on %s, fsid %s (pid=%d)\n",
> +				       n_start ? "started" : "resumed",
> +				       path, fsid, pid);
> +			if (!do_wait) {
> +				err = 0;
> +				goto out;
> +			}
> +			ret = wait(&stat);
> +			if (ret != pid) {
> +				err(!do_quiet, "ERROR: wait failed: (ret=%d) "
> +				    "%s\n", ret, strerror(errno));
> +				err = 1;
> +				goto out;
> +			}
> +			if (!WIFEXITED(stat) || WEXITSTATUS(stat)) {
> +				err(!do_quiet, "ERROR: scrub process failed\n");
> +				err = WIFEXITED(stat) ? WEXITSTATUS(stat) : -1;
> +				goto out;
> +			}
> +			err = 0;
> +			goto out;
> +		}
> +	}
> +
> +	scrub_handle_sigint_child(fdmnt);
> +
> +	for (i = 0; i < fi_args.num_devices; ++i) {
> +		if (sp[i].skip) {
> +			sp[i].scrub_args.progress = sp[i].resumed->p;
> +			sp[i].stats = sp[i].resumed->stats;
> +			sp[i].ret = 0;
> +			sp[i].stats.finished = 1;
> +			continue;
> +		}
> +		devid = di_args[i].devid;
> +		gettimeofday(&tv, NULL);
> +		sp[i].stats.t_start = tv.tv_sec;
> +		ret = pthread_create(&t_devs[i], &t_attr, scrub_one_dev,&sp[i]);

   -HRM not checked scrub_one_dev()

> +		if (ret) {
> +			if (do_print)
> +				fprintf(stderr, "ERROR: creating "
> +				        "scrub_one_dev[%llu] thread failed: "
> +				        "%s\n", devid, strerror(ret));
> +			err = 1;
> +			goto out;
> +		}
> +	}
> +
> +	spc.fdmnt = fdmnt;
> +	spc.prg_fd = prg_fd;
> +	spc.do_record = do_record;
> +	spc.write_mutex = &spc_write_mutex;
> +	spc.shared_progress = sp;
> +	spc.fi = &fi_args;
> +	pthread_create(&t_prog, &t_attr, scrub_progress_cycle, &spc);
> +

   -HRM: Not checked: scrub_progress_cycle()

> +	err = 0;
> +	for (i = 0; i < fi_args.num_devices; ++i) {
> +		if (sp[i].skip)
> +			continue;
> +		devid = di_args[i].devid;
> +		ret = pthread_join(t_devs[i], NULL);
> +		if (ret) {
> +			if (do_print)
> +				fprintf(stderr, "ERROR: pthread_join failed "
> +				        "for scrub_one_dev[%llu]: %s\n", devid,
> +			                strerror(ret));
> +			err++;
> +			continue;
> +		}
> +		if (sp[i].ret && sp[i].ioctl_errno == ENODEV) {
> +			if (do_print)
> +				fprintf(stderr, "WARNING: device %lld not "
> +				        "present\n", devid);
> +			continue;
> +		}
> +		if (sp[i].ret && sp[i].ioctl_errno == ECANCELED) {
> +			err++;
> +		} else if (sp[i].ret) {
> +			if (do_print)
> +				fprintf(stderr, "ERROR: scrubbing %s failed "
> +				        "for device id %lld (%s)\n", path,
> +				        devid, strerror(sp[i].ioctl_errno));
> +			err++;
> +			continue;
> +		}
> +	}
> +
> +	if (do_print) {
> +		const char *append = "done";
> +		if (!do_stats_per_dev)
> +			init_fs_stat(&fs_stat);
> +		for (i = 0; i < fi_args.num_devices; ++i) {
> +			if (do_stats_per_dev) {
> +				print_scrub_dev(&di_args[i],
> +				                &sp[i].scrub_args.progress,
> +				                print_raw,
> +				                sp[i].ret ? "canceled" : "done",
> +				                &sp[i].stats);
> +			} else {
> +				if (sp[i].ret)
> +					append = "canceled";
> +				add_to_fs_stat(&sp[i].scrub_args.progress,
> +						&sp[i].stats, &fs_stat);
> +			}
> +		}
> +		if (!do_stats_per_dev) {
> +			printf("scrub %s for %s\n", append, fsid);
> +			print_fs_stat(&fs_stat, print_raw);
> +		}
> +	}
> +
> +	pthread_cancel(t_prog);
> +	ret = pthread_join(t_prog, &terr);

   Does this need to happen before the output above? Is there a
possible race between scrub_progress_cycle() and the stats gathering
code here? (I've not looked at scrub_progress_cycle() in detail yet,
so I don't know).

> +	if (do_print && terr && terr != PTHREAD_CANCELED) {
> +		fprintf(stderr, "ERROR: recording progress "
> +			"failed: %s\n", strerror(-PTR_ERR(terr)));
> +	}
> +
> +	if (do_record) {
> +		ret = scrub_write_progress(&spc_write_mutex, fsid, sp,
> +					   fi_args.num_devices);

   -HRM Not checked scrub_write_progress()

> +		if (ret && do_print) {
> +			fprintf(stderr, "ERROR: failed to record the result: "
> +				"%s\n", strerror(-ret));
> +		}
> +	}
> +
> +	scrub_handle_sigint_child(-1);
> +
> +out:
> +	free_history(past_scrubs);
> +	free(di_args);
> +	free(t_devs);
> +	free(sp);
> +	free(spc.progress);
> +	if (prg_fd > -1) {
> +		close(prg_fd);
> +		if (sock_path[0])
> +			unlink(sock_path);
> +	}
> +	close(fdmnt);
> +
> +	return !!err;
> +}
> +
> +int do_scrub_start(int argc, char **argv)
> +{
> +	return scrub_start(argc, argv, 0);
> +}
> +
> +int do_scrub_resume(int argc, char **argv)
> +{
> +	return scrub_start(argc, argv, 1);
> +}
[...]

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
              --- Welcome to Rivendell,  Mr Anderson... ---              

--kH8JNVvasRCCW1Oz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQFOGe4EIKyzvlFcI40RAic5AKCcmI0Kl8Pn0tIi+9r4+9JU4w1UkACgnpXu
W5WxthY+yt3JriQsXcwf+tI=
=q5k1
-----END PGP SIGNATURE-----

--kH8JNVvasRCCW1Oz--
