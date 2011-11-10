From: David Sterba <dave@jikos.cz>
Subject: Re: How to remount btrfs without compression?
Date: Thu, 10 Nov 2011 01:11:04 +0100
Message-ID: <20111110001103.GV12759@twin.jikos.cz>
References: <4EB72C1B.1030702@parallels.com> <201111071319.14493.Martin@lichtvoll.de> <4EB87E01.1040704@parallels.com> <4EB880A0.1030304@gmail.com> <CAG1y0seMUUNwXCY6-=JehE+rrd4PRF55MZoHEUB_9+jDm6N_rA@mail.gmail.com> <4EB88BC9.7020509@gmail.com> <4EB88D4A.5050908@parallels.com> <20111108150151.GA4954@shiny> <20111108151208.GB4954@shiny> <4EB9D0D9.1000009@parallels.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="mP3DRpeJDSE+ciuQ"
Cc: linux-btrfs@vger.kernel.org
To: dima <dolenin@parallels.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EB9D0D9.1000009@parallels.com>
List-ID: <linux-btrfs.vger.kernel.org>


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 09, 2011 at 10:01:13AM +0900, dima wrote:
> Just for the record - I could find a solution thanks to the btrfs wiki 
> being online again. In Gotchas it says
> 
> mount -o nodatacow also disables compression
> 
> and indeed it does. Remounting with this option and re-saving the file 
> makes it uncompressed. However, I could not find how to remount the 
> filesystem afterwards without nodatacow.

I saw this mentioned on irc today (that nodatacow diasables
compression). There is a way how to turn off compression on a file --
with help of the NOCOW _file_ attribute, ie. you don't have to remount.

* create the file, compression enabled
* set NOCOW (with the attached single-purpose nocow.c utility)
* btrfs fi defrag the_file

Make sure you have enough free space for the uncompressed file size. You
can compare the extent layout before and after the defrag with
"filefrag -v" .

I did a test first, here's what I saw with a ~60M file (filled with
zeros, suitable for compression):

# filefrag -v zerofile2
Filesystem type is: 9123683e
File size of zerofile2 is 69927424 (17073 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0     2700              32
   1      32     2942     2731     32
   2      64     2943     2973     32
   3      96     2944     2974     32
   4     128     2945     2975     32
...
 533   17039     2641     2671     32
 534   17071     2643     2672      2 eof
zerofile2: 535 extents found

# btrfs fi defrag zerofile2

# filefrag -v zerofile2
Filesystem type is: 9123683e
File size of zerofile2 is 69927424 (17073 blocks, blocksize 4096)
 ext logical physical expected length flags
   0       0    20992            2107
   1    2107    23552    23098   1581
   2    3688    16400    25132   1185
   3    4873    12410    17584    889
   4    5762    14762    13298    667
   5    6429    15881    15428    500
   6    6929    17585    16380    751
   7    7680    23099    18335    375
   8    8055    25133    23473    376
   9    8431     3072    25508   2160
  10   10591     5632     5231   1620
  11   12211     8192     7251   2431
  12   14642    18432    10622   2431 eof
zerofile2: 13 extents found


david

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nocow.c"

#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <string.h>

#include <linux/types.h>
#include <stdio.h>
#include <errno.h>

#ifndef FS_IOC_SETFLAGS
#define FS_IOC_SETFLAGS                 _IOW('f', 2, long)
#warning defining SETFLAGS locally
#endif

#ifndef FS_IOC_GETFLAGS
#define FS_IOC_GETFLAGS                 _IOR('f', 1, long)
#warning defining GETFLAGS locally
#endif

#ifndef FS_NOCOW_FL
#define FS_NOCOW_FL                     0x00800000 /* Do not cow file */
#endif

int main(int argc, char **argv)
{
        int fd;
        int r;
	long flags;

	if (argc < 2) {
		printf("usage: %s file\n", argv[0]);
		exit(1);
	}

        fd = open(argv[1], O_RDONLY);
	if (fd == -1) {
		perror("open()");
		return 1;
	}
	printf("GETFLAGS ioctl 0x%x\n", FS_IOC_GETFLAGS);
	printf("SETFLAGS ioctl 0x%x\n", FS_IOC_SETFLAGS);

	r = ioctl(fd, FS_IOC_GETFLAGS, &flags);
	if (r == -1) {
		perror("ioctl(GETFLAGS)");
		return 1;
	} else {
		printf("file flags: 0x%lx\n", flags);
	}

	printf("Set NOCOW flag for %s\n", argv[1]);
	flags |= FS_NOCOW_FL;
        r = ioctl(fd, FS_IOC_SETFLAGS, &flags);
	printf("ioctl returned: %d\n", r);
	if (r == -1) {
		perror("ioctl()");
		return 1;
	}

        return 0;
}

--mP3DRpeJDSE+ciuQ--
