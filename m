Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34791 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751570AbeBWXFg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 18:05:36 -0500
Received: by mail-pg0-f67.google.com with SMTP id m19so3915204pgn.1
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 15:05:36 -0800 (PST)
Date: Fri, 23 Feb 2018 15:05:34 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 26/27] btrfs-progs: use libbtrfsutil for subvolume list
Message-ID: <20180223230534.GG7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <6492726d6e89bf792627e4431f7ba7691f09c3d2.1518720598.git.osandov@fb.com>
 <2bbba01e-1c72-90ae-a7b5-56b341ec1c1a@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2bbba01e-1c72-90ae-a7b5-56b341ec1c1a@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 23, 2018 at 11:26:35AM +0900, Misono, Tomohiro wrote:
> 
> 
> On 2018/02/16 4:05, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> 
> > +static struct subvol_list *btrfs_list_deleted_subvols(int fd,
> > +						      struct btrfs_list_filter_set *filter_set)
> > +{
> > +	struct subvol_list *subvols = NULL;
> > +	uint64_t *ids = NULL;
> > +	size_t i, n;
> > +	enum btrfs_util_error err;
> > +	int ret = -1;
> > +
> > +	err = btrfs_util_deleted_subvolumes_fd(fd, &ids, &n);
> > +	if (err) {
> > +		error_btrfs_util(err);
> > +		return NULL;
> > +	}
> > +
> > +	subvols = malloc(sizeof(*subvols) + n * sizeof(subvols->subvols[0]));
> > +	if (!subvols) {
> > +		error("out of memory");
> > +		goto out;
> > +	}
> > +
> > +	subvols->num = 0;
> > +	for (i = 0; i < n; i++) {
> > +		struct listed_subvol *subvol = &subvols->subvols[subvols->num];
> > +
> > +		err = btrfs_util_subvolume_info_fd(fd, ids[i], &subvol->info);
> > +		if (err) {
> 
> I think there is a small chance that subvolume would be removed from tree between 
> btrfs_util_deleted_subvolumes_fd() and btrfs_util_subvolume_info_fd().
> So, error of BTRFS_UTIL_ERROR_SUBVOLUME_NOT_FOUND should be ignored.

Thanks, since this patch isn't in the devel branch in, I'll fold the fix
in.
