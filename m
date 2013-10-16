Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout01.t-online.de ([194.25.134.80]:51501 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161Ab3JPIIP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 04:08:15 -0400
Received: from p3e9c3d7d.dip0.t-ipconnect.de ([62.156.61.125] helo=[172.24.11.38])
	by nas2.weinberger.local with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <christian.weinberger@t-online.de>)
	id 1VWLsy-0006yO-9V
	for linux-btrfs@vger.kernel.org; Wed, 16 Oct 2013 09:51:16 +0200
Message-ID: <525E456F.1070601@weinberger.in>
Date: Wed, 16 Oct 2013 09:51:11 +0200
From: Christian Weinberger <christian.weinberger@t-online.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [BUG] Reflinking fails for files >2GB on 32-bit platform
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I want to make you aware of a possible bug in the reflink handling of btrfs:

When I reflink a file larger 2GB (on the same subvol), the reflinking
fails. But it works fine for files smaller 2GB in size.

I was able to track this down to btrfs with great support of Martin
Raiber who created a small demo code:
Source: https://urbackup.atlassian.net/secure/attachment/10201/reflink.cpp
Compile: g++ reflink.cpp -o reflink
Usage: reflink source-file destination-file

Works if source-file is smaller 2GB and errors otherwise.

Environment:
Debian Wheezy 7.2 i386 --> 32 bit
Kernel: 3.10.11-1~bpo70+1 (most recent from wheezy backports rep)

Anything missing? I´m happy to provide additional input!

====snip===demo program source=======

#include <iostream>
#include <errno.h>
#include <stdio.h>
#include <sys/types.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

bool os_create_reflink(const char* linkname, const char* fname)
{
  int src_desc=open(fname, O_RDONLY);
  if( src_desc<0)
  return false;

  int dst_desc=open(linkname, O_WRONLY | O_CREAT | O_EXCL, S_IRWXU | S_IRWXG);
  if( dst_desc<0 )
  {
  close(src_desc);
  return false;
  }

  #define BTRFS_IOCTL_MAGIC 0x94
  #define BTRFS_IOC_CLONE _IOW (BTRFS_IOCTL_MAGIC, 9, int)

  int rc=ioctl(dst_desc, BTRFS_IOC_CLONE, src_desc);

  close(src_desc);
  close(dst_desc);

  return rc==0;
}

int main(int argc, char* argv[])
{
  if(argc<3)
  {
    std::cout << "not enough arguments: reflink [source file] [dest file]" << std::endl;
    return 1;
  }
  
  if(!os_create_reflink(argv[2], argv[1]))
  {
     perror("reflink");
     return 2;
  }
  
  return 0;
}


