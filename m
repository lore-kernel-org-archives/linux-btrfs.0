Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f47.google.com ([209.85.160.47]:33943 "EHLO
        mail-pl0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeBWWoq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:44:46 -0500
Received: by mail-pl0-f47.google.com with SMTP id u13so5715559plq.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 14:44:46 -0800 (PST)
Date: Fri, 23 Feb 2018 14:44:44 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 07/27] libbtrfsutil: add btrfs_util_subvolume_path()
Message-ID: <20180223224444.GD7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <af89178dc6f35fe6a807aec6fecc0611ae99b3fb.1518720598.git.osandov@fb.com>
 <0452f2f6-02c5-7cb8-6a20-e1a65de096db@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0452f2f6-02c5-7cb8-6a20-e1a65de096db@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 23, 2018 at 03:27:52PM +0900, Misono, Tomohiro wrote:
> On 2018/02/16 4:04, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> 
> > +PUBLIC enum btrfs_util_error btrfs_util_subvolume_path_fd(int fd, uint64_t id,
> > +							  char **path_ret)
> > +{
> > +	char *path, *p;
> > +	size_t capacity = 4096;
> > +
> > +	path = malloc(capacity);
> > +	if (!path)
> > +		return BTRFS_UTIL_ERROR_NO_MEMORY;
> > +	p = path + capacity - 1;
> > +	p[0] = '\0';
> > +
> > +	if (id == 0) {
> > +		enum btrfs_util_error err;
> > +
> > +		err = btrfs_util_is_subvolume_fd(fd);
> > +		if (err)
> > +			return err;
> 
> 'path' should be freed here and below.
> 
> > +
> > +		err = btrfs_util_subvolume_id_fd(fd, &id);
> > +		if (err)
> > +			return err;
> > +	}

Indeed, although I'll just change it to allocate path after this
instead.
