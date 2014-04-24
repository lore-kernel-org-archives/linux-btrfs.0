Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:62473 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaDXNed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 09:34:33 -0400
Received: by mail-yk0-f175.google.com with SMTP id 131so2040124ykp.6
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 06:34:32 -0700 (PDT)
Message-ID: <535912E5.7080106@gmail.com>
Date: Thu, 24 Apr 2014 06:34:29 -0700
From: Daniel Lee <longinus00@gmail.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Which companies are using Btrfs in production?
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org>
In-Reply-To: <20140424011952.GO26949@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2014 06:19 PM, Marc MERLIN wrote:
> Oh while we're at it, are there companies that can say they are using btrfs
> in production?
>
> Marc
Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
They apparently use Oracle's linux distro so I assume they're relying on
them to do most of the heavy lifting as far as support BTRFS and
backporting goes since they're still on 3.0! They also have raid5/6
support so they are probably running BTRFS on top of md.

http://www.netgear.com/images/BTRFS%20on%20ReadyNAS%20OS%206_9May1318-76105.pdf

