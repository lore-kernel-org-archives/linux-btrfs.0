Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58413 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028Ab2JDHPj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Oct 2012 03:15:39 -0400
Date: Thu, 4 Oct 2012 09:15:29 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?iso-8859-1?Q?S=E9bastien?= Maury <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V2] btrfs filesystem df
Message-ID: <20121004071529.GY14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com>
 <20121003193211.GX14582@twin.jikos.cz>
 <506C9435.2030505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <506C9435.2030505@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 09:38:29PM +0200, Goffredo Baroncelli wrote:
> the output of the program ends with the "Metadata Single....". What you
> called "Help text" is a short description in the email.

Ah, I see. I still find it useful, would be good to include it in help
text or under a separate option.

david
