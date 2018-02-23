Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:45487 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752031AbeBWWtf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:49:35 -0500
Received: by mail-pg0-f49.google.com with SMTP id e11so3889708pgq.12
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 14:49:35 -0800 (PST)
Date: Fri, 23 Feb 2018 14:49:33 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 11/27] libbtrfsutil: add subvolume iterator helpers
Message-ID: <20180223224933.GE7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <4cc1bad06e7e064dbf1af7a4e5b9d66ffe9c0913.1518720598.git.osandov@fb.com>
 <2bd6c3a5-722f-412a-041c-66837bc21d73@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2bd6c3a5-722f-412a-041c-66837bc21d73@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 23, 2018 at 04:40:45PM +0900, Misono, Tomohiro wrote:
> On 2018/02/16 4:04, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> 
> > +PUBLIC enum btrfs_util_error btrfs_util_create_subvolume_iterator(const char *path,
> > +								  uint64_t top,
> > +								  int flags,
> > +								  struct btrfs_util_subvolume_iterator **ret)
> > +{
> > +	enum btrfs_util_error err;
> > +	int fd;
> > +
> > +	fd = open(path, O_RDONLY);
> > +	if (fd == -1)
> > +		return BTRFS_UTIL_ERROR_OPEN_FAILED;
> > +
> > +	err = btrfs_util_create_subvolume_iterator_fd(fd, top, flags, ret);
> > +	if (err == BTRFS_UTIL_OK)
> > +		(*ret)->flags |= BTRFS_UTIL_SUBVOLUME_ITERATOR_CLOSE_FD;
> 
> If btrfs_util_create_subvolume_iterator_fd() returns error, 'fd' remains open.
> So, fd should be closed here.

Good catch, fixed.
