From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Getting a lot of fs-generated information to user space
Date: Fri, 12 Aug 2011 06:31:55 -0600
Message-ID: <20110812123154.GA29309@parisc-linux.org>
References: <4E451917.6080306@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4E451917.6080306@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 12, 2011 at 02:14:15PM +0200, Jan Schmidt wrote:
> (1) Normally, requests to the file system go through ioctls (on the fd
> of the mountpoint) and the result is small enough to be returned when
> the ioctl finishes. That said, I thought of passing a user land fd along
> with this ioctl to the kernel and make it dump the generated bits there.
> Only, I don't see how to turn a fd into a struct file pointer. And I
> don't know if that would be considered really ugly by a lot of people.

struct file *filp = fget(fd);
...
fput(filp);

That said, why not have the ioctl mutate the existing fd?
ie in userspace:

int fd = open("/mnt/btrfs");
ioctl(fd, BTRFS_IOC_STREAM);
while (...) {
	read(fd, buf, 4096);
	...
}
close(fd);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
