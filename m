Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51397 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2KRVZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Nov 2012 16:25:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so770878eek.19
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Nov 2012 13:25:14 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Sparsify / hole punching tool
From: Remco Hosman - Yerf IT <remco@yerf-it.nl>
In-Reply-To: <20121118211930.GD11121@carfax.org.uk>
Date: Sun, 18 Nov 2012 22:25:12 +0100
Message-Id: <809CB6CF-BB2F-4E9E-A1D0-7FDF765C4D62@yerf-it.nl>
References: <97B8CC50-0F4A-42BE-959F-26C86A2C3FAD@yerf-it.nl> <20121118211930.GD11121@carfax.org.uk>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

as requested. like this? 


---begin
#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <linux/falloc.h>
#include <unistd.h>

#define BLOCKSIZE 4096

int main(int argc, char** argv) {
    ssize_t rsize;
    int fh, result;
    char buff[BLOCKSIZE], ebuff[BLOCKSIZE];
    off_t curpos, pstart, psize;
    int freed;

    if (argc < 2) {
	printf("%s [file...]\n", argv[0]);
	return 0;
    } 

    memset(ebuff, 0, BLOCKSIZE);	// prepare a block of 0's
    
    for (int i = 1; i < argc; i++) {
	char* file=argv[i];
	curpos = 0;
	pstart = 0;
	psize = 0;
	freed = 0;

	fh = open(file, O_RDWR, O_NOATIME);
	if (fh == -1) {
	    perror("open()");
	    return -1;
	}
    
	printf("sparseifying %s ", file);
	fflush(stdout);
	while ((rsize = read(fh, buff, BLOCKSIZE)) > 0) {
	    result = memcmp(buff, ebuff,rsize);
	    if (result == 0) { // block is empty
		if (pstart == 0) { // previous block as not empty?
		    pstart = curpos;
		    psize = rsize; // save for later punching
		} else {
		    psize += rsize; // previous block was empty too, add size
		}
	    
		freed += rsize;
	    } else if (pstart) { // block is not empty and we have a block that we still need to punch
		result = fallocate(fh, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, pstart, psize);
		if (result == -1) {
		    perror("fallocate()");
		    return -1;
		}
		pstart = 0;
		psize = 0;
	    }
	    curpos += rsize;
	}

	if (pstart) { // still a block to do ?
	    result = fallocate(fh, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, pstart, psize);
	    if (result == -1) {
		perror("fallocate()");
		return -1;
	    }
	}

	if (rsize == 0) {
	    printf("done. freed %i bytes\n", freed);
	    continue;
	}
	if (rsize == -1) {
	    perror("read()");
	    return -1;
	}
    }
    return -1;
}
---end


Remco Hosman


On Nov 18, 2012, at 10:19 PM, Hugo Mills <hugo@carfax.org.uk> wrote:

> On Sun, Nov 18, 2012 at 10:04:29PM +0100, Remco Hosman - Yerf IT wrote:
>> I wrote a little tool you can use to scan a file and punch holes, so make it sparse.
>> 
>> Confirmed to work on 3.7.0-rc6
>> Feel free to use it in any way you like, and of course improve it. 
>> 
>> http://pastebin.com/8SjEsBLD
> 
>   For archival purposes, it's probably better to put the whole thing
> inline in the text of your mail. This also makes it far easier to make
> comments on it, should anyone feel moved to do so.
> 
>   Hugo.
> 
> -- 
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>  PGP key: 515C238D from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>         --- In theory, theory and practice are the same. In ---         
>                      practice,  they're different.                      

