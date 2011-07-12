From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v2 4/5] scrub userland implementation
Date: Tue, 12 Jul 2011 10:48:39 +0200
Message-ID: <4E1C0A67.8010203@jan-o-sch.net>
References: <cover.1301503683.git.list.btrfs@jan-o-sch.net> <6321f041bfb9f439198cc03d2f7cb8ce8c5db867.1301503683.git.list.btrfs@jan-o-sch.net> <20110711204555.GL4325@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: chris.mason@oracle.com
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110711204555.GL4325@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 11.07.2011 22:45, Hugo Mills wrote:
>    OK, here's the remainder of my comments for this file. Not much for
> this bit -- just one comment about locking, a reminder, and an
> observation.

Again, I ripped out the bits I simply corrected. My comments below.

> [...]
>
>> +static int scrub_write_progress(pthread_mutex_t *m, const char *fsid,
>> +                                struct scrub_progress* data, int n)
>> +{
>> +	int ret;
>> +	int fd;
>> +	int old;
>> +
>> +	ret = pthread_mutex_lock(m);
>> +	if (ret) {
>> +		ret = -errno;
>> +		goto out;
>> +	}
>> +
>> +	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, &old);
> 
>    Probably not massively important, but you don't check for the
> return value of this call or its counterpart at the end of this
> function.

pthread_* return values where wrong throughout the code. Good that you
pointed at this one. It's all fixed now.

> [...]
>
>> +static void *scrub_one_dev(void *ctx)
>> +{
>> +	struct scrub_progress *sp = ctx;
>> +	int ret;
>> +	struct timeval tv;
>> +
>> +	sp->stats.canceled = 0;
>> +	sp->stats.duration = 0;
>> +	sp->stats.finished = 0;
>> +
>> +	ret = ioctl(sp->fd, BTRFS_IOC_SCRUB, &sp->scrub_args);
>> +	gettimeofday(&tv, NULL);
>> +	sp->ret = ret;
>> +	sp->stats.duration = tv.tv_sec - sp->stats.t_start;
>> +	sp->stats.canceled = !!ret;
>> +	sp->ioctl_errno = errno;
>> +	ret = pthread_mutex_lock(&sp->progress_mutex);
>> +	if (ret)
>> +		return ERR_PTR(-errno);
>> +	sp->stats.finished = 1;
>> +	ret = pthread_mutex_unlock(&sp->progress_mutex);
> 
>    If you downgrade .finished to a plain int, rather than a u64, then
> is this locking actually be needed? You have one place where the lock
> is held to write a single value (which is atomic for an int, IIRC),
> and you have another place where you hold the lock to read and compare
> it. I don't see any problem with removing the lock for that.

Conclusion first: I want to stick with the mutex. My reasoning:
- this is by no means time critical code
- the mutexes do the memory barriers required for synchronization
- using int instead of u64 would complicate the kvread macros

Thanks,
-Jan
