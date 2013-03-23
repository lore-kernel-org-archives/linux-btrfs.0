Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:41862 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998Ab3CWKbz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Mar 2013 06:31:55 -0400
Received: by mail-we0-f176.google.com with SMTP id s10so750347wey.21
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2013 03:31:54 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 23 Mar 2013 21:31:53 +1100
Message-ID: <CA+QDxdY6DmLLy_0Bq2=LOtJMVY4rPxysk1Av6AZvbJzrFyy4ug@mail.gmail.com>
Subject: The limitation of 1024 extends of btrfs restore seems to smal
From: Earth Engine <earthengine@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have recently tried to restore a btrfs partition that was mounted as "/home".

The "btrfs restore" keep asking annoying questions like "we seem to
loop deep...", and I have to use "yes 'n' | btrfs restore" to bypass
this.

But I was interesting what kind of files that have such a problem. So
I downloaded btrfs source code and looked at it. By adding additional
print point to the output, I proved that all the problematic files
just have too many (more than 1024) extends. Furthermore, I listed all
problematic files into a file. The result shows that all those files
falls in the following categories:

1. Firefox related files
       .mozilla/firefox/c6tw6z0l.default/urlclassifier3.sqlite
       .mozilla/firefox/6huj12lo.default/Cache/_CACHE_???_

2. Google earth cache file
      .googleearth/Cache/dbCache.dat

3. aMule download files (Temp or Incoming)

4. Transmission download files (part files or full files)

Base on my knowledge about the above applications, I believe that it
is natural for those files to have more than 1024 extends. So why the
official "btrfs restore" shall alert the user about those files? and
not even provides an option to bypass it?

It is easy to provide a patch since the "1024" is a easy to find hard
coded value. However I want to know why this limitation even exists.
