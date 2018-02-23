Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pl0-f49.google.com ([209.85.160.49]:44408 "EHLO
        mail-pl0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeBWW6O (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 17:58:14 -0500
Received: by mail-pl0-f49.google.com with SMTP id w21so5713544plp.11
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Feb 2018 14:58:13 -0800 (PST)
Date: Fri, 23 Feb 2018 14:58:12 -0800
From: Omar Sandoval <osandov@osandov.com>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 06/27] libbtrfsutil: add btrfs_util_create_subvolume()
Message-ID: <20180223225812.GF7046@vader.DHCP.thefacebook.com>
References: <cover.1518720598.git.osandov@fb.com>
 <afd80fc716f0242909ca573abdf0ba3ae432b6e4.1518720598.git.osandov@fb.com>
 <3bbfd6e3-d89e-add3-3391-74802cbcdf6a@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3bbfd6e3-d89e-add3-3391-74802cbcdf6a@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 23, 2018 at 05:24:04PM +0900, Misono, Tomohiro wrote:
> On 2018/02/16 4:04, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> 
> > +static enum btrfs_util_error openat_parent_and_name(int dirfd, const char *path,
> > +						    char *name, size_t name_len,
> > +						    int *fd)
> > +{
> > +	char *tmp_path, *slash, *dirname, *basename;
> > +	size_t len;
> > +
> > +	/* Ignore trailing slashes. */
> > +	len = strlen(path);
> > +	while (len > 1 && path[len - 1] == '/')
> > +		len--;
> > +
> > +	tmp_path = malloc(len + 1);
> > +	if (!tmp_path)
> > +		return BTRFS_UTIL_ERROR_NO_MEMORY;
> > +	memcpy(tmp_path, path, len);
> > +	tmp_path[len] = '\0';
> > +
> > +	slash = memrchr(tmp_path, '/', len);
> > +	if (slash == tmp_path) {
> > +		dirname = "/";
> > +		basename = tmp_path + 1;
> > +	} else if (slash) {
> > +		*slash = '\0';
> > +		dirname = tmp_path;
> > +		basename = slash + 1;
> > +	} else {
> > +		dirname = ".";
> > +		basename = tmp_path;
> > +	}
> > +
> > +	len = strlen(basename);
> > +	if (len >= name_len) {
> > +		errno = ENAMETOOLONG;
> 
> tmp_path should be also freed here.

Another good catch, thanks.
