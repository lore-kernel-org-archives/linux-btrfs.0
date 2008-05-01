From: "Jeff Schroeder" <jeffschroed@gmail.com>
Subject: Re: Btrfs v0.14 Released
Date: Thu, 1 May 2008 09:18:55 -0700
Message-ID: <c24352ca0805010918j395470d0o8f2088571c90183b@mail.gmail.com>
References: <200804291601.32945.chris.mason@oracle.com>
	 <200805011204.20847.chris.mason@oracle.com>
Reply-To: jeffschroeder@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: "Chris Mason" <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761620AbYEAQTN@vger.kernel.org>
In-Reply-To: <200805011204.20847.chris.mason@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 1, 2008 at 9:04 AM, Chris Mason <chris.mason@oracle.com> wrote:
> On Tuesday 29 April 2008, Chris Mason wrote:
>  > Hello everyone,
>  >
>  > Btrfs v0.14 is now available for download.  Please note the disk format has
>  > changed, and it is not compatible with older versions of Btrfs.
>  >
>  > For downloads and documention, please see the Btrfs project page:
>  >
>  > http://btrfs.wiki.kernel.org
>  >
>
>  Hello everyone,
>
>  I've rolled up some fixes for older kernels and fixed an uninitialized
>  variables in btrfs-progs that could cause an oops on mount.  I'll wait a few
>  days to see if other bug reports come in and cut a 0.15 with any other
>  critical fixes.
Well it oopses on writes everytime in Ubuntu 8.04 (Hardy). I'd planned
on digging into
it more before spending a bug report, but will send it tonight after
getting to the affected
machine.

With 1 volume on 1 disk, 2 volumes raid1 on 2 disks, or with 2 volumes
raid0 on 2 disks.
something like:
echo omg > /mnt/btrfs/file

Would segfault, exit the current shell, and leave a nice stack trace
in the kernel's ring buffer.

The file gets created as 0 bytes. Unlinking the file works fine via
rm, but any sort of write fails.
Tried and reproduced the bug with stdout redirection, cp, and dd to a
btrfs v0.14 volume.

Will send the report later today.



>
>  Until then, you can find download information on the important fixes so far:
>
>  http://btrfs.wiki.kernel.org/index.php/Hot_Fixes
>
>
>
>  -chris


-- 
Jeff Schroeder

Don't drink and derive, alcohol and analysis don't mix.
http://www.digitalprognosis.com
