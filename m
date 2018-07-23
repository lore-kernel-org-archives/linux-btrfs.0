Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.dpl.mendix.net ([83.96.177.10]:50542 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387831AbeGWQnM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 12:43:12 -0400
Subject: Re: python-btrfs & btrfs-heatmap ebuilds now available for Gentoo
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <2356e8d0-3dcd-34c5-bfc7-b01340fc9cef@applied-asynchrony.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <e553ccb0-05ff-4001-c928-82b1886c65d9@mendix.com>
Date: Mon, 23 Jul 2018 17:41:20 +0200
MIME-Version: 1.0
In-Reply-To: <2356e8d0-3dcd-34c5-bfc7-b01340fc9cef@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/2018 04:25 PM, Holger Hoffstätte wrote:
> 
> I wanted to migrate my collection of questionable shell scripts for btrfs
> maintenance/inspection to a more stable foundation and therefore created
> Gentoo ebuilds for Hans van Kranenburg's excellent python-btrfs [1] and
> btrfs-heatmap [2] packages.
> 
> They can be found in my overlay at:
> 
> https://github.com/hhoffstaette/portage/tree/master/sys-fs/python-btrfs
> https://github.com/hhoffstaette/portage/tree/master/sys-fs/btrfs-heatmap

Thanks for doing this!

And now you're making us curious about those
not-so-questionable-any-more scripts. :D

> Both are curently only available for python-3.6 since a change in 3.7
> broke the existing python API [3]. As soon as that is fixed I'll add 3.7
> to the PYTHON_COMPAT entries.

Yes, thanks for testing, I'll have a look at it and will probably also
ask you to help testing the fix.

> btrfs-heatmap properly uses the python-exec wrapper and therefore works
> regardless of currently selected default python version.  :)
> 
> I hope this is useful to someone.

I bet it will. ;-]

-- 
Hans van Kranenburg
