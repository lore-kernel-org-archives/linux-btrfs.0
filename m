Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55907 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab3B0NZQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:25:16 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 97F7B9A034A
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 06:25:15 -0700 (MST)
Date: Wed, 27 Feb 2013 08:25:13 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Daniel =?iso-8859-1?Q?Koz=E1k?= <kozzi11@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Running Apache Derby on 3.8 and BTRFS cause kernel oops
Message-ID: <20130227132513.GG19641@localhost.localdomain>
References: <op.ws51z2nllpxuyk@kozzifx.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <op.ws51z2nllpxuyk@kozzifx.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 06:20:16AM -0700, Daniel Kozák wrote:
> Hello,
> 
> On my both machine I have ArchLinux with recent kernel 3.8.0 btrfs as a  
> filesystem (with lzo compression). When I try use Apache derby (create  
> database), I almost every time get this kernel oops:

Sweet somebody else is hitting this and I haven't been able to reproduce.  Can
you give me the exact commands you run so I can try and reproduce myself?
Thanks,

Josef
