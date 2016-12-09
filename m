Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:58821 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753628AbcLIIZV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Dec 2016 03:25:21 -0500
Date: Fri, 9 Dec 2016 09:25:00 +0100
From: Adam Borowski <kilobyte@angband.pl>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Marc Joliet <marcec@gmx.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: out-of-band dedup status?
Message-ID: <20161209082500.GA28652@angband.pl>
References: <1481222198.6563.3.camel@scientia.net>
 <539d7c1c-5041-fb99-0ec5-81291f9f6609@suse.com>
 <CAJCQCtQYof6yjOOc9rf5MFL=Gb-uai7CZGgygsThv+w=Hz=LFQ@mail.gmail.com>
 <59259055.MCA93YCoJj@thetick>
 <CAJCQCtStTRUnubdoCFr9JpaWS_y5_NFb5m7AFzRcA6-kPJ_N+A@mail.gmail.com>
 <20161209022647.GE16801@birch.djwong.org>
 <CAJCQCtSRUmQarebB6rK_sCiVGpBZ-Xcptr17zu_XoJC8EF9BoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSRUmQarebB6rK_sCiVGpBZ-Xcptr17zu_XoJC8EF9BoQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 08, 2016 at 07:54:39PM -0700, Chris Murphy wrote:
> On Thu, Dec 8, 2016 at 7:26 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > Ew, it's deduping these two 1.4GB files 128K at a time, which results in
> > 12000 ioctl calls.  Each of those 12000 calls has to lock the two
> > inodes, read the file contents, remap the blocks, etc.  instead of
> > finding the maximal identical range and making a single call for the
> > whole range.
> >
> > That's probably why it's taking forever to dedupe.
> 
> Yes but it looks like it's also heavily fragmenting the files as a
> result as well.

Thus I think it's better to do whole-file dedupe only, other than in some
special cases (like VM images).  Much simpler, faster and doesn't cause
fragmentation.

-- 
u-boot problems can be solved with the help of your old SCSI manuals, the
parts that deal with goat termination.  You need a black-handled knife, and
an appropriate set of candles (number and color matters).  Or was it a
silver-handled knife?  Crap, need to look that up.
