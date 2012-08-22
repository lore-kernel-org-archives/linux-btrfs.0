Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:41898 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab2HVPOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Aug 2012 11:14:02 -0400
Date: Wed, 22 Aug 2012 17:13:39 +0200
From: David Sterba <dave@jikos.cz>
To: Marc MERLIN <marc@merlins.org>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: linux 3.5.0: BTRFS error in compress_file_range:581 (failed to
 join transaction)
Message-ID: <20120822151339.GU17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20120814182314.GF12659@merlins.org>
 <20120815024856.GL12659@merlins.org>
 <502B1147.5070901@oracle.com>
 <20120815040053.GA22300@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120815040053.GA22300@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 14, 2012 at 09:00:53PM -0700, Marc MERLIN wrote:
> > What does the 'ret' shows?  Is it -ENOSPC?
> 
> I got nothing else in my logs.

Unless it was a second error from a filesystem that went RO, there
should be more than the "Failed to join transaction" message, and the
first occurence of some transaction abort would spit some stacktrace as
well.

As you wrote in next paragraphs, it was probably a cable disconnection, so my
bet is on EIO, and the transaction abort did the right things, so

> I powered the laptop back on and it came up like nothing ever happened.

s/I/you/
.

(besides the few uncommitted changes)


david
