Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37687 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbcESKxb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 06:53:31 -0400
Date: Thu, 19 May 2016 12:53:28 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: sharing page cache pages between multiple mappings
Message-ID: <20160519105328.GJ26110@dhcp22.suse.cz>
References: <CAJfpeguD-S=CEogqcDOYAYJBzfyJG=MMKyFfpMo55bQk7d0_TQ@mail.gmail.com>
 <20160519090521.GA26114@dhcp22.suse.cz>
 <CAJfpegvqPrP=AtaOSwMX1s=-oVAEE97NMwEHUkg93dBWvOykHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJfpegvqPrP=AtaOSwMX1s=-oVAEE97NMwEHUkg93dBWvOykHw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 19-05-16 12:17:14, Miklos Szeredi wrote:
> On Thu, May 19, 2016 at 11:05 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Thu 19-05-16 10:20:13, Miklos Szeredi wrote:
> >> Has anyone thought about sharing pages between multiple files?
> >>
> >> The obvious application is for COW filesytems where there are
> >> logically distinct files that physically share data and could easily
> >> share the cache as well if there was infrastructure for it.
> >
> > FYI this has been discussed at LSFMM this year[1]. I wasn't at the
> > session so cannot tell you any details but the LWN article covers it at
> > least briefly.
> 
> Cool, so it's not such a crazy idea.

FWIW it is ;)
-- 
Michal Hocko
SUSE Labs
