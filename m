Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000Ab3IPPmh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Sep 2013 11:42:37 -0400
Date: Mon, 16 Sep 2013 17:42:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: use kernel for mounted and lblkid to
 scan disks
Message-ID: <20130916154224.GT6810@suse.cz>
Reply-To: dsterba@suse.cz
References: <1379071943-27543-1-git-send-email-anand.jain@oracle.com>
 <1379071943-27543-3-git-send-email-anand.jain@oracle.com>
 <20130913172520.GP6810@twin.jikos.cz>
 <523537EB.5020604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <523537EB.5020604@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 15, 2013 at 12:30:35PM +0800, Anand Jain wrote:
>  IMO group profile is useful info to have it at both the places.
>  end user using this new btrfs fi show would surely notice that it
>  will reduce other commands normally used following the current
>  btrfs fi show command. (like mount and btrfs fi df). of course
>  user should use fi df to know detailed info about the sizes.

Yeah, the output of df/show needs reworking, but please do not mix
unrelated changes to other patches, although it may be too tempting in
this particular case.

david
