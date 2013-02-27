Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3B0MiV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 07:38:21 -0500
Date: Wed, 27 Feb 2013 13:38:19 +0100
From: David Sterba <dsterba@suse.cz>
To: kreijack@inwind.it
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 16/17] btrfs-progs: fix fd leak in cmd_subvol_set_default
Message-ID: <20130227123819.GB27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
 <1361832890-40921-17-git-send-email-sandeen@redhat.com>
 <512D031D.20408@gmail.com>
 <512D169C.3020100@redhat.com>
 <512D2344.40607@tiscalinet.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512D2344.40607@tiscalinet.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:04:04PM +0100, Goffredo Baroncelli wrote:
> On 02/26/2013 09:10 PM, Eric Sandeen wrote:
> IMHO this would be simple enough to be done in one shot. However this
> problem exists also in other points.
> May be that for now your patch is ok. But then we should start another
> set of patches which correct/sanitise all these use of
> "parse_size/strto[u]ll/parse_limit...".
> 
> Unfortunately this means that these next series of patches will start
> only when these one will be accepted in order to avoid patches conflict.

The small and localized changes as can be found in this series are going
to the integration branches early. Thanks all who are reviewing, it
helps to speed up the process. I prefer to separate the changes here, as
you point out there are other places to be fixed.

thanks,
david
