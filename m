Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eta.wiserhosting.co.uk ([85.92.82.55]:43858 "EHLO
	eta.wiserhosting.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3GBVf7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 17:35:59 -0400
Message-ID: <51D34803.2010004@petezilla.co.uk>
Date: Tue, 02 Jul 2013 22:37:07 +0100
From: Peter Chant <pete@petezilla.co.uk>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: Hardware failure or btrfs issue?
References: <51D2091E.9010800@petezilla.co.uk> <20130702072915.GA8170@carfax.org.uk> <51D30FB0.5000304@petezilla.co.uk> <20130702174759.GB804@carfax.org.uk>
In-Reply-To: <20130702174759.GB804@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2013 06:48 PM, Hugo Mills wrote:
> So the damage probably happened then, if that stick is bad. 
> Filesystems have this irritating habit of remembering things done to 
> them across reboots. :) Hugo.

The previous action  to the defrag was to delete 48 hours worth of 
hourly snapshots.  I was wondering if the numerous snapshots were what 
was making defrag so painfully slow.  Not that I know anything about 
btrfs internals, but I suspect that is major enough action to catch out 
any random corruption if there was any.  I think I'll restrict snapshots 
to once or twice a day at most unless that really should cause no issue.

Pete

