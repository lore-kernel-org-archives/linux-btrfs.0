Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25918 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab3IVS2P (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 14:28:15 -0400
Message-ID: <523F36B1.8080701@linux.intel.com>
Date: Sun, 22 Sep 2013 11:28:01 -0700
From: Saul Wold <sgw@linux.intel.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Issue building a file based rootfs image with mkfs.btrfs
References: <523B4036.7030204@linux.intel.com>
In-Reply-To: <523B4036.7030204@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2013 11:19 AM, Saul Wold wrote:
>
> Hi there,
>
> I am attempting to build a rootfs image from an existing rootfs
> directory tree.  I am using the 0.20 @ 194aa4a of Chris's git repo.
>
> The couple problem I saw was that the target image file needed to exist,
> although I think I can patch that then the FS size was much larger than
> the actual size, I tracked this to the usage of ftw not accounting for
> symlinks, I have a patch for that which I will send once I finish
> getting the other issues resolved.
>
> Next issue I hit was an assertion failure after getting "not enough free
> space" message:
>
> not enough free space
> add_file_items failed
> unable to traverse_directory
> Making image is aborted.
> mkfs.btrfs: mkfs.c:1542: main: Assertion `!(ret)' failed.
>
> I am kind of stuck on this one, took it as far as I can right now. Would
> I be better off dropping back to 0.19 or can we move forward fixing this?
>
Anybody have any ideas on this?  I can reproduce this at will on Fedora 
19 (with btrfs-progs-0.20), Ubuntu 12.10 (with btrfs-profs-0.19) and 
with HEAD from Chris's repo above (is this the right place these days)?

Thanks your your help.

Sau!

> Thanks
>
