Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:41392 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JaLcF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 07:32:05 -0400
Date: Wed, 31 Oct 2012 12:31:54 +0100
From: David Sterba <dave@jikos.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: =?iso-8859-1?Q?G=E1bor?= Nyers <gnyers@suse.com>,
        Liu Bo <liub.liubo@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: How to find (out if) files sharing content?
Message-ID: <20121031113154.GG3102@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <20121030162005.0308d5a2@lupus.demo.lan>
 <5090736C.5040609@oracle.com>
 <50908D3E.3000609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50908D3E.3000609@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 10:30:22AM +0800, Jeff Liu wrote:
> One idea is to mark those cloned extents as FIEMAP_EXTENT_SHARED so that
> we can go through a file to figure out how many extents are shared
> through fiemap(2), and calculate the real storage(fs/subvolume) footprint
> in the end.

This will cost at least one more seek per extent to find out that the
extent is shared, could be quite expensive. And without any possibility
to turn this off, I'm afraid this will render FIEMAP unusable in
practice.

david
