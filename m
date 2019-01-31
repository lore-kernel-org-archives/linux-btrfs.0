Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34EFC169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:48:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7729920855
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbfAaPs4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:48:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:52132 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725855AbfAaPs4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:48:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8F7EB0B0
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 15:48:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 71075DA7D6; Thu, 31 Jan 2019 16:48:20 +0100 (CET)
Date:   Thu, 31 Jan 2019 16:48:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 01/15] btrfs: Honour FITRIM range constraints during free
 space trim
Message-ID: <20190131154820.GJ2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, jeffm@suse.com
References: <20190130145102.4708-1-nborisov@suse.com>
 <20190130145102.4708-2-nborisov@suse.com>
 <20190131152135.GG2900@twin.jikos.cz>
 <ef5b4561-8337-a28a-4419-98e8f1e20e73@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef5b4561-8337-a28a-4419-98e8f1e20e73@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 05:35:10PM +0200, Nikolay Borisov wrote:
> On 31.01.19 г. 17:21 ч., David Sterba wrote:
> > On Wed, Jan 30, 2019 at 04:50:48PM +0200, Nikolay Borisov wrote:
> >> Up until know trimming the freespace was done irrespective of what the
> >> arguments of the FITRIM ioctl were. For example fstrim's -o/-l arguments
> >> will be entirely ignored. Fix it by correctly handling those paramter.
> >> This requires breaking if the found freespace extent is after the end
> >> of the passed range as well as completing trim after trimming
> >> fstrim_range::len bytes.
> > 
> > How does this work with with multipe-device filesystems? The fstrim
> > range would apply to all of them. Which does make some sense, though
> > might be unexpected as this does not happen for other filesystems.
> 
> Well FITRIM doesn't have support for multiple device so it's to the
> discretion of the fs how exactly this is implemented. And this is indeed
> the way things work currently.
> 
> > The FITRIM range is in the physical coordinates, so eg. the taking the
> > maximum size of all devices and iterating over that by 1GiB steps would
> > go though the whole filesystem. Something to put to the changelog and
> > documentation.
> 
> I don't follow, trimming would just trim the physical range as passed by
> fstrim -o/-l options. That 1gb value is not hardcoded anywhere. If
> someone wants to trim all of the freespace (which is what the majority
> of the user do) then they can run FITRIM with 0 for offset and -1 for
> length.

Yeah but I wanted to give an example of usecase when the range is not
0/-1 and how this is could to be used.
