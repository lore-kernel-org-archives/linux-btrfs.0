Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933381AbeFRLhX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Jun 2018 07:37:23 -0400
Date: Mon, 18 Jun 2018 13:34:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: About more loose parameter sequence requirement
Message-ID: <20180618113432.GJ24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 14, 2018 at 03:17:45PM +0800, Qu Wenruo wrote:
> I understand that btrfs-progs introduced restrict parameter/option order
> to distinguish global and sub-command parameter/option.
> 
> However it's really annoying if one just want to append some new options
> to previous command:
> 
> E.g.
> # btrfs check /dev/data/btrfs
> # !! --check-data-csum
> 
> The last command will fail as current btrfs-progs doesn't allow any
> option after parameter.
> 
> 
> Despite the requirement to distinguish global and subcommand
> option/parameter, is there any other requirement for such restrict
> option-first-parameter-last policy?

I'd say that it's a common and recommended pattern. Getopt is able to
reorder the parameters so mixed options and non-options are accepted,
unless POSIXLY_CORRECT (see man getopt(3)) is not set. With the more
strict requirement, 'btrfs' option parser works the same regardless of
that.

> If I could implement a enhanced getopt to allow more loose order inside
> subcomand while still can distinguish global option, will it be accepted
> (if it's quality is acceptable) ?

I think it's not worth updating the parser just to support an IMHO
narrow usecase.
