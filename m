From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Getting a lot of fs-generated information to user space
Date: Fri, 12 Aug 2011 16:41:41 +0200
Message-ID: <4E453BA5.4090403@jan-o-sch.net>
References: <4E451917.6080306@jan-o-sch.net> <20110812123154.GA29309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110812123154.GA29309@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 12.08.2011 14:31, Matthew Wilcox wrote:
> On Fri, Aug 12, 2011 at 02:14:15PM +0200, Jan Schmidt wrote:
>> (1) Normally, requests to the file system go through ioctls (on the fd
>> of the mountpoint) and the result is small enough to be returned when
>> the ioctl finishes. That said, I thought of passing a user land fd along
>> with this ioctl to the kernel and make it dump the generated bits there.
>> Only, I don't see how to turn a fd into a struct file pointer. And I
>> don't know if that would be considered really ugly by a lot of people.
> 
> struct file *filp = fget(fd);
> ...
> fput(filp);
>
> That said, why not have the ioctl mutate the existing fd?
> ie in userspace:
> 
> int fd = open("/mnt/btrfs");
> ioctl(fd, BTRFS_IOC_STREAM);
> while (...) {
> 	read(fd, buf, 4096);
> 	...
> }
> close(fd);

After thinking twice, this has a drawback: I'd have to track state
between two read(2) calls, waiting for userspace to "pull" more data.

In contrast, I'd rather use a "push" like approach, having the buffering
done for me. Getting back to my suggestion (1, giving a fd to the kernel
where the output is expected), that should look like this in userspace:

-
int fd;
int pipefd[2];
struct io_args io_args;

fd = open("/mnt/btrfs");
pipe(pipefd);
io_agrs.dest = pipefd[0];

/* thread 1 */
ioctl(fd, BTRFS_IOC_STREAM, &io_args);
/* thread 2 */
while (...) {
	read(pipefd[1], buf, 4096);
	...
}
-

Any suggestions and opinions appreciated. Thanks,
-Jan
