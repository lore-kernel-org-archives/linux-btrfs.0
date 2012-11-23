Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:60485 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab2KWRpI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Nov 2012 12:45:08 -0500
Received: from extserver.intern.prnet.org (ip-213-135-240-128.static.luxdsl.pt.lu [213.135.240.128])
	by extserver1.prnet.org (8.14.5/8.14.5) with ESMTP id qANHj5wT072452
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2012 18:45:05 +0100 (CET)
	(envelope-from admin@prnet.org)
Received: from [192.168.1.1] (server.intern.prnet.org [192.168.1.1])
	(authenticated bits=0)
	by extserver.intern.prnet.org (8.14.4/8.14.4) with ESMTP id qANHj4kW023290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Nov 2012 18:45:05 +0100
Message-ID: <50AFB620.6040707@prnet.org>
Date: Fri, 23 Nov 2012 18:45:04 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: extended attributes wiredness
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am using kernel 3.7-rc6.

I have written a test application for extended attributes and have for
some folders a wired behaviour:

#include <stdio.h>
#include <string.h>
#include <attr/xattr.h>

char attrs[1024];
ssize_t attrslen;
int i;
char value[1024];
ssize_t valuelen;

int main(int argc, char *argv[])
{
  if (argc != 2)
  {
    fprintf(stderr, "Syntax: testxattr <filename>\n");

    return 1;
  }

  printf("processing file %s\n", argv[1]);

  attrslen = llistxattr(argv[1], attrs, 1024);

  if (attrslen < 0)
  {
    perror("listxattr failed");

    return 1;
  }

  for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
  {
    printf("processing attribute %s\n", &attrs[i]);

    valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);

    if (valuelen < 0);
    {
      perror("lgetxattr failed");

      return 1;
    }

    printf("value %.*s", (int) valuelen, value);
  }

  return 0;
}

is returning:

processing file /u00/root.20121121.210102.full/var/lib/nfs/sm
processing attribute system.posix_acl_default
lgetxattr failed: No data available

output of stat:

File: '/u00/root.20121121.210102.full/var/lib/nfs/sm'
Size: 94            Blocks: 0          IO Block: 4096   directory
Device: 3ah/58d    Inode: 1331353     Links: 1
Access: (0755/drwxr-xr-x)  Uid: (65534/  nobody)   Gid: (    0/    root)
Access: 2012-10-18 21:25:11.350000993 +0200
Modify: 2012-11-21 06:32:24.050210417 +0100
Change: 2012-11-21 06:32:24.050210417 +0100
Birth: -

Is this a bug in btrfs or do I miss something here ?

Thanks in advance,
David Arendt
