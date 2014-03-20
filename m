Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757878AbaCTRwy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 13:52:54 -0400
Date: Thu, 20 Mar 2014 18:52:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Ajesh js <coolajeshjs@gmail.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Please help me to contribute to btrfs project
Message-ID: <20140320175252.GL29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CA+nQTon3WcD_gdcFyhDwXt=Y7kBu4DZ78YD2=-G+1z8yA2fCQg@mail.gmail.com>
 <87wqfrr53o.fsf@gmail.com>
 <CA+nQTom=VFTK61Nkgmwd53hRgXS+kzWixZ725L+ksBcrAqFc9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+nQTom=VFTK61Nkgmwd53hRgXS+kzWixZ725L+ksBcrAqFc9Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 19, 2014 at 02:47:50PM +0530, Ajesh js wrote:
> I did go though the links send by you & got the complete details for
> sending the kernel component.
> 
> Also my change has a patch in btrfs-tools. It will be nice if you can
> share the process for submitting that patch also.

The patch submission process and coding style is the same for userspace
tools. The common practice is to prefix the subject of patch that
modifies userspace tools with 'btrfs-progs:'.
