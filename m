Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbaA2RMn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 12:12:43 -0500
Date: Wed, 29 Jan 2014 18:12:41 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2 2/6] btrfs: search_ioctl rejects unused setted
 values
Message-ID: <20140129171241.GF6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
 <1390829312-814-3-git-send-email-Gerhard@Heift.Name>
 <20140127172835.GB6498@twin.jikos.cz>
 <CACeaM89+t0dse3znsq5_YrEemMCLt5KdJ9kxLqNOMYj8LkqkOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACeaM89+t0dse3znsq5_YrEemMCLt5KdJ9kxLqNOMYj8LkqkOw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 28, 2014 at 01:32:36AM +0100, Gerhard Heift wrote:
> > If any future version of the ioctl uses the now unused fields, it also
> > has to increase the version.
> 
> Just for me to learn: If we have to increase the version, why do we
> have the unused fields anyway? We could expand the struct on demand if
> we need new fields. Do I miss something?

The spare fields can be used for minor updates, eg. returning a simple
number or status information, or passing some flags down to the ioctl.

Your patch does a major change to the crucial member of the ioctl
structure, the existing unused fileds don't help here and will stay
unused.
