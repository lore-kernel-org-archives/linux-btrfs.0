Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbbCQQHT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Mar 2015 12:07:19 -0400
Date: Tue, 17 Mar 2015 17:07:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: number of hardlinks for directory in ls -lid always 1?
Message-ID: <20150317160717.GU20767@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <9389540.MYekrP2a8Q@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9389540.MYekrP2a8Q@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 17, 2015 at 02:33:30PM +0100, Martin Steigerwald wrote:
> On BTRFS I see
> 
> martin@merkaba:~> ls -lid /usr/local
> 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local
> martin@merkaba:~> ls -lid /usr/local/.
> 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/.
> martin@merkaba:~> ls -lid /usr/local/bin/..
> 27138 drwxrwsr-x 1 root staff 62 Aug 15  2014 /usr/local/bin/..
> 
> On other filesystems like Ext4 I see the actual number of hardlinks to the 
> directory.
> 
> Is this intended behaviour of BTRFS or a bug?

Intended behaviour, this has been asked in the past, I don't have the
link sorry, try searching the mailinglist archives.
